<?php
//ez a websocket_server.php azért felel hogy a chateket "fél" valós időbe kezelje

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//FIGYELEM ENÉLKÜL NEM FOG MŰKÖDNI A CHAT RÉSZ EL KELL INDÍTANI A server_run.php-t
//TOVÁBBI INFORMÁCIÓ A README.TXT FÁJLBAN TALÁLHATÓ
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

require __DIR__ . '/vendor/autoload.php';
require_once __DIR__ . '/db.php'; // require_once a biztonság kedvéért

//TODO: képek javítása nem küldi el és lezárja a kapcsolatot amikor fotózik,

//Ratchet használata a websocket szerver implementálásához
use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

class ChatServer implements MessageComponentInterface
{
    private mysqli $db;
    protected SplObjectStorage $clients;
    protected SplObjectStorage $userMap;

    //ez a metódus a websocket-et használó Dart-ok felé küldi vissza a status_update típusú üzeneteket!
    private function broadcastStatus(int $userId, string $status, ?string $lastSeen): void
    {
        $stmt = $this->db->prepare("SELECT signed_in FROM users WHERE id = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $userRow = $stmt->get_result()->fetch_assoc();
        $signedIn = $userRow['signed_in'] ?? 0;

        $payload = [
            'message_type' => 'status_update',
            'data' => [
                'user_id' => $userId,
                'status' => $status, // csak akkor "online", ha status=online ÉS signed_in=1
                'last_seen' => $lastSeen,
                'signed_in' => (int)$signedIn,
            ]
        ];

        foreach ($this->clients as $client) {
            $client->send(json_encode($payload));
        }

        echo "📡 Státusz broadcast: $userId => $status\n";
    }

    //felépíti a websocket servert
    public function __construct()
    {
        // Itt már nem global $conn-t használunk, hanem a db.php függvényét
        $this->db = getDbConnection();
        $this->clients = new SplObjectStorage;
        $this->userMap = new SplObjectStorage;

        if ($this->db->connect_error) {
            echo "DB hiba: " . $this->db->connect_error . "\n";
        } else {
            echo "DB kapcsolat létrejött\n";
        }
    }

    //websocket kapcsolat nyításakor ez történjen
    public function onOpen(ConnectionInterface $conn): void
    {
        /** @var ConnectionInterface|stdClass $conn */
        $this->clients->attach($conn);
        echo "Új kapcsolat: $conn->resourceId\n";
    }

    //ha üzenet érkezik a websocket szerverre akkor típus alapján különböző üzeneteket küldünk,
    //mind az adatbázis felé, mind a Dart felé!
    public function onMessage(ConnectionInterface $from, $msg): void
    {
        /** @var ConnectionInterface|stdClass $from */
        echo "Üzenet: $msg\n";

        $data = json_decode($msg, true);
        if (!$data || !isset($data['message_type'])) {
            echo "❌ Hibás üzenet vagy hiányzó típus!\n";
            return;
        }

        $type = $data['message_type'];
        echo "típus: " . $type . "\n";

        try {
            switch ($type) {
                case 'auth':
                    $this->handleAuth($from, $data);
                    return; // Az auth nem küld broadcast üzenetet

                case 'ping':
                    echo "📡 Ping érkezett a $from->resourceId-tól\n";
                    return;

                case 'text':
                    $messageId = $this->handleText($data);
                    break;

                case 'file':
                    $messageId = $this->handleFile($data);
                    break;

                case 'image':
                    $messageId = $this->handleImage($data);
                    break;

                case 'read_status_update':
                    $this->handleReadStatus($data);
                    return; // Saját broadcastot kezel

                default:
                    echo "Ismeretlen message_type: $type\n";
                    return;
            }

            if (isset($messageId) && $messageId) {
                $this->broadcastMessage($messageId, $type);
            }
        } catch (Throwable $e) {
            echo "Kivétel történt: " . $e->getMessage() . "\n";
        }
    }

    // --- Privát kezelő metódusok a tisztább kódért ---

    private function handleAuth(ConnectionInterface $from, array $data): void
    {
        /** @var ConnectionInterface|stdClass $from */
        if (!isset($data['user_id'])) {
            echo "❌ Auth hiba: nincs user_id!\n";
            return;
        }

        $userId = intval($data['user_id']);
        echo "✅ Azonosított felhasználó: $userId (kapcsolat: $from->resourceId)\n";

        $this->userMap[$from] = $userId;

        $stmt = $this->db->prepare("UPDATE users SET signed_in = 1 WHERE id = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();

        $stmt = $this->db->prepare("SELECT status, last_seen FROM users WHERE id = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $user = $stmt->get_result()->fetch_assoc();
        
        // Csak akkor küldünk státuszt, ha a felhasználó létezik az adatbázisban
        if ($user) {
            $this->broadcastStatus($userId, $user['status'] === 'online' ? 'online' : 'offline', $user['last_seen']);
        }
    }

    private function handleText(array $data): ?int
    {
        if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'])) return null;

        $chatId = intval($data['chat_id']);
        $senderId = intval($data['sender_id']);
        $receiverId = intval($data['receiver_id']);
        $messageText = isset($data['message_text']) && trim($data['message_text']) !== '' ? trim($data['message_text']) : null;

        $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);

        if (!$stmt->execute()) {
            echo "❌ INSERT hiba: " . $stmt->error . "\n";
            return null;
        }

        return $this->db->insert_id;
    }

    private function handleFile(array $data): ?int
    {
        echo "➡️ FILE feldolgozás indul...\n";
        if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['files'])) {
            echo "❌ Hiányzó adat a file üzenethez!\n";
            return null;
        }

        // Először létrehozzuk az üzenetet
        $messageId = $this->handleText($data);
        if (!$messageId) return null;

        echo "✅ FILE messageId: $messageId\n";

        foreach ($data['files'] as $file) {
            $originalFileName = basename($file['file_name']);
            $uniqueFileName = $this->generateUniqueFileName($originalFileName);
            $fileContent = base64_decode($file['file_bytes']);

            if (strlen($fileContent) > 100 * 1024 * 1024) {
                echo "❌ $originalFileName túl nagy!\n";
                continue;
            }

            $path = __DIR__ . "/../uploads/files/$uniqueFileName";
            if (!file_exists(dirname($path))) {
                // Biztonságosabb jogosultság használata
                mkdir(dirname($path), 0755, true);
            }
            file_put_contents($path, $fileContent);

            $url = "http://10.0.2.2/ChatexProject/uploads/files/$uniqueFileName";

            $attStmt = $this->db->prepare("INSERT INTO message_attachments (message_id, file_type, file_name, download_url) VALUES (?, 'file', ?, ?)");
            $attStmt->bind_param("iss", $messageId, $originalFileName, $url);
            $attStmt->execute();
        }

        return $messageId;
    }

    private function handleImage(array $data): ?int
    {
        if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['images'])) {
            echo "❌ Hiányzó image adatok!\n";
            return null;
        }

        // Először létrehozzuk az üzenetet
        $messageId = $this->handleText($data);
        if (!$messageId) return null;

        foreach ($data['images'] as $img) {
            $originalFileName = basename($img['file_name']);
            $uniqueFileName = $this->generateUniqueFileName($originalFileName);
            $imageData = base64_decode($img['image_data']);

            $uploadPath = __DIR__ . "/../uploads/media/$uniqueFileName";
            if (!file_exists(dirname($uploadPath))) {
                // Biztonságosabb jogosultság használata
                mkdir(dirname($uploadPath), 0755, true);
            }

            file_put_contents($uploadPath, $imageData);

            $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/media/$uniqueFileName";

            $attStmt = $this->db->prepare("INSERT INTO message_attachments (message_id, file_type, file_name, download_url) VALUES (?, 'image', ?, ?)");
            $attStmt->bind_param("iss", $messageId, $originalFileName, $downloadUrl);
            $attStmt->execute();
        }

        return $messageId;
    }

    private function handleReadStatus(array $data): void
    {
        if (!isset($data['chat_id'], $data['user_id'])) {
            echo "Hiányzó adatok a read_status_update-hez!\n";
            return;
        }

        $chatId = intval($data['chat_id']);
        $userId = intval($data['user_id']);

        // Frissítjük az adatbázist
        $stmt = $this->db->prepare("UPDATE messages SET is_read = 1 WHERE chat_id = ? AND receiver_id = ? AND is_read = 0");
        $stmt->bind_param("ii", $chatId, $userId);
        $stmt->execute();

        // Lekérjük a frissített üzeneteket és értesítjük a klienseket
        $stmt = $this->db->prepare("SELECT * FROM messages WHERE chat_id = ? AND receiver_id = ? AND is_read = 1");
        $stmt->bind_param("ii", $chatId, $userId);
        $stmt->execute();
        $result = $stmt->get_result();

        while ($row = $result->fetch_assoc()) {
            $payload = [
                'message_type' => 'message_read',
                'data' => $row
            ];
            foreach ($this->clients as $client) {
                $client->send(json_encode($payload));
            }
        }
    }

    private function broadcastMessage(int $messageId, string $type): void
    {
        $query = $this->db->prepare("SELECT * FROM messages WHERE message_id = ?");
        $query->bind_param("i", $messageId);
        $query->execute();
        $messageData = $query->get_result()->fetch_assoc();
        $query->close();

        $attStmt = $this->db->prepare("SELECT file_name, download_url FROM message_attachments WHERE message_id = ?");
        $attStmt->bind_param("i", $messageId);
        $attStmt->execute();
        $attResult = $attStmt->get_result();

        $attachments = [];
        while ($row = $attResult->fetch_assoc()) {
            $attachments[] = $row;
        }

        $payload = [
            'message_type' => $type,
            'data' => array_merge($messageData ?? [], ['attachments' => $attachments])
        ];

        $jsonPayload = json_encode($payload);
        foreach ($this->clients as $client) {
            $client->send($jsonPayload);
        }

        echo "Üzenet ($type) broadcastolva: " . json_encode($messageData) . "\n";
    }

    private function generateUniqueFileName(string $originalName): string
    {
        $extension = pathinfo($originalName, PATHINFO_EXTENSION);
        // Generál egy egyedi azonosítót és hozzáfűzi a kiterjesztést
        return uniqid('file_', true) . '.' . $extension;
    }

    //websocket kapcsolat bezárásakor mi történjen!
    public function onClose(ConnectionInterface $conn): void
    {
        /** @var ConnectionInterface|stdClass $conn */
        $this->clients->detach($conn);

        if (isset($this->userMap[$conn])) {
            $userId = $this->userMap[$conn];

            // signed_in = 0
            $stmt = $this->db->prepare("UPDATE users SET signed_in = 0, last_seen = NOW() WHERE id = ?");
            $stmt->bind_param("i", $userId);
            $stmt->execute();

            // Értesítjük a többi klienst, hogy a felhasználó offline lett
            $this->broadcastStatus($userId, 'offline', date("Y-m-d H:i:s"));

            unset($this->userMap[$conn]);
        }

        echo "Kapcsolat lezárva: $conn->resourceId\n";
    }

    //hiba esetén mi történjen
    public function onError(ConnectionInterface $conn, Exception $e): void
    {
        echo "Hiba: {$e->getMessage()}\n";
        $conn->close();
    }
}
