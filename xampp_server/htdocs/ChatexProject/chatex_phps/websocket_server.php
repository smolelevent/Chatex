<?php
//ez a websocket_server.php azért felel hogy a chateket "fél" valós időbe kezelje

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//FIGYELEM ENÉLKÜL NEM FOG MŰKÖDNI A CHAT RÉSZ EL KELL INDÍTANI A server_run.php-t
//TOVÁBBI INFORMÁCIÓ A README.TXT FÁJLBAN TALÁLHATÓ
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

require __DIR__ . '/vendor/autoload.php';
require __DIR__ . '/db.php';

//Ratchet használata a websocket szerver implementálásához
use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

class ChatServer implements MessageComponentInterface
{
    private $db;
    protected $clients;
    protected $userMap;

    //ez a metódus a websocket-et használó Dart-ok felé küldi vissza a status_update típusú üzeneteket!
    private function broadcastStatus(int $userId, string $status, ?string $lastSeen)
    {

        $stmt = $this->db->prepare("SELECT signed_in FROM users WHERE id = ?");
        $stmt->bind_param("i", $userId);
        $stmt->execute();
        $signedIn = $stmt->get_result()->fetch_assoc()['signed_in'] ?? 0;

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
        global $conn;
        $this->db = $conn;
        $this->clients = new \SplObjectStorage;
        $this->userMap = new \SplObjectStorage;

        if ($this->db->connect_error) {
            echo "DB hiba: " . $this->db->connect_error . "\n";
        } else {
            echo "DB kapcsolat létrejött\n";
        }
    }

    //websocket kapcsolat nyításakor ez történjen
    public function onOpen(ConnectionInterface $conn)
    {
        $this->clients->attach($conn);
        echo "Új kapcsolat: {$conn->resourceId}\n";
    }

    //ha üzenet érkezik a websocket szerverre akkor típus alapján különböző üzeneteket küldünk,
    //mind az adatbázis felé, mind a Dart felé!
    public function onMessage(ConnectionInterface $from, $msg)
    {
        echo "Üzenet: $msg\n";

        $data = json_decode($msg, true);
        if (!$data) {
            echo "Hibás üzenet! \n";
            return;
        }

        $type = $data['message_type'];
        if (!isset($data['message_type'])) {
            echo "❌ Üzenetben nincs type!\n";
            return;
        }

        echo "típus: " . $type . "\n";

        try {
            $messageId = null;

            switch ($type) {
                case 'auth':
                    if (!isset($data['user_id'])) {
                        echo "❌ Auth hiba: nincs user_id!\n";
                        return;
                    }

                    $userId = intval($data['user_id']);
                    echo "✅ Azonosított felhasználó: {$userId} (kapcsolat: {$from->resourceId})\n";

                    $this->userMap[$from] = $userId; //az üzenet küldője a megfelelő felhasználó legyen

                    // signed_in = 1-re állítjuk a felhasználót mert jelen van az üzenetéből adódóan
                    $stmt = $this->db->prepare("UPDATE users SET signed_in = 1 WHERE id = ?");
                    $stmt->bind_param("i", $userId);
                    $stmt->execute();

                    // Lekérjük az aktuális státuszt és last_seen értéket
                    $stmt = $this->db->prepare("SELECT status, last_seen FROM users WHERE id = ?");
                    $stmt->bind_param("i", $userId);
                    $stmt->execute();
                    $result = $stmt->get_result();
                    $user = $result->fetch_assoc();

                    $this->broadcastStatus($userId, $user['status'] === 'online' ? 'online' : 'offline', $user['last_seen']);
                    return;
                    break;

                case 'ping':
                    echo "📡 Ping érkezett a {$from->resourceId}-tól\n";
                    return;
                    break;

                case 'text':
                    // csak szöveges üzenet
                    if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'])) return;
                    $chatId = intval($data['chat_id']);
                    $senderId = intval($data['sender_id']);
                    $receiverId = intval($data['receiver_id']);
                    $messageText = isset($data['message_text']) && trim($data['message_text']) !== '' ? trim($data['message_text']) : null;

                    $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
                    $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);

                    if (!$stmt->execute()) {
                        echo "❌ INSERT hiba: " . $stmt->error . "\n";
                        return;
                    }

                    $messageId = $this->db->insert_id;
                    break;

                case 'file':
                    echo "➡️ FILE feldolgozás indul...\n";
                    if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['files'])) {
                        echo "❌ Hiányzó adat a file üzenethez!\n";
                        return;
                    }

                    $chatId = intval($data['chat_id']);
                    $senderId = intval($data['sender_id']);
                    $receiverId = intval($data['receiver_id']);
                    $messageText = isset($data['message_text']) && trim($data['message_text']) !== '' ? trim($data['message_text']) : null;

                    $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
                    $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);

                    if (!$stmt->execute()) {
                        echo "❌ INSERT hiba (file): " . $stmt->error . "\n";
                        return;
                    }

                    $messageId = $this->db->insert_id;
                    echo "✅ FILE messageId: $messageId\n";

                    foreach ($data['files'] as $file) {
                        $fileName = basename($file['file_name']);
                        $fileContent = base64_decode($file['file_bytes']);

                        if (strlen($fileContent) > 100 * 1024 * 1024) {
                            echo "❌ $fileName túl nagy!\n";
                            continue;
                        }

                        $path = __DIR__ . "/../uploads/files/$fileName";
                        file_put_contents($path, $fileContent);

                        $url = "http://10.0.2.2/ChatexProject/uploads/files/$fileName";

                        $attStmt = $this->db->prepare("INSERT INTO message_attachments (message_id, file_type, file_name, download_url) VALUES (?, 'file', ?, ?)");
                        $attStmt->bind_param("iss", $messageId, $fileName, $url);
                        $attStmt->execute();
                    }

                    break;


                case 'image':
                    if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['images'])) {
                        echo "❌ Hiányzó image adatok!\n";
                        return;
                    }

                    $chatId = intval($data['chat_id']);
                    $senderId = intval($data['sender_id']);
                    $receiverId = intval($data['receiver_id']);
                    $messageText = isset($data['message_text']) && trim($data['message_text']) !== ''
                        ? trim($data['message_text'])
                        : null;

                    $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
                    $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);

                    if (!$stmt->execute()) {
                        echo "❌ INSERT hiba (image): " . $stmt->error . "\n";
                        return;
                    }

                    $messageId = $this->db->insert_id;

                    foreach ($data['images'] as $img) {
                        $fileName = basename($img['file_name']);
                        $imageData = base64_decode($img['image_data']);

                        $uploadPath = __DIR__ . "/../uploads/media/$fileName";
                        if (!file_exists(dirname($uploadPath))) {
                            mkdir(dirname($uploadPath), 0777, true);
                        }

                        file_put_contents($uploadPath, $imageData);

                        $downloadUrl = "http://10.0.2.2/ChatexProject/uploads/media/$fileName";

                        $attStmt = $this->db->prepare("INSERT INTO message_attachments (message_id, file_type, file_name, download_url) VALUES (?, 'image', ?, ?)");
                        $attStmt->bind_param("iss", $messageId, $fileName, $downloadUrl);
                        $attStmt->execute();
                    }
                    break;



                case 'read_status_update':
                    if (!isset($data['chat_id'], $data['user_id'])) {
                        echo "Hiányzó adatok a read_status_update-hez!\n";
                        return;
                    }

                    $chatId = intval($data['chat_id']);
                    $userId = intval($data['user_id']);

                    foreach ($this->clients as $client) {
                        if ($client !== $from && isset($this->userMap[$client]) && $this->userMap[$client] == $userId) {
                            $stmt = $this->db->prepare("UPDATE messages SET is_read = 1 WHERE chat_id = ? AND receiver_id = ? AND is_read = 0");
                            $stmt->bind_param("ii", $chatId, $userId);
                            $stmt->execute();
                            break;
                        }
                    }

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
                    return;
                    break;

                default:
                    echo "Ismeretlen message_type: $type\n";
                    return;
                    break;
            }

            if ($messageId) {
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
                    'data' => array_merge($messageData, ['attachments' => $attachments])
                ];

                foreach ($this->clients as $client) {
                    $client->send(json_encode($payload));
                }

                echo "Üzenet ($type) broadcastolva: " . json_encode($messageData) . "\n";
            }
        } catch (Throwable $e) {
            echo "Kivétel történt: " . $e->getMessage() . "\n";
        }
    }

    //websocket kapcsolat bezárásakor mi történjen!
    public function onClose(ConnectionInterface $conn)
    {
        $this->clients->detach($conn);

        if (isset($this->userMap[$conn])) {
            $userId = $this->userMap[$conn];

            // signed_in = 0
            $stmt = $this->db->prepare("UPDATE users SET signed_in = 0, last_seen = NOW() WHERE id = ?");
            $stmt->bind_param("i", $userId);
            $stmt->execute();

            $stmt = $this->db->prepare("SELECT status FROM users WHERE id = ?");
            $stmt->bind_param("i", $userId);
            $stmt->execute();
            $result = $stmt->get_result()->fetch_assoc();

            $this->broadcastStatus($userId, 'offline', date("Y-m-d H:i:s"));
        }

        echo "Kapcsolat lezárva: {$conn->resourceId}\n";
    }

    //hiba esetén mi történjen
    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        echo "Hiba: {$e->getMessage()}\n";
        $conn->close();
    }
}
