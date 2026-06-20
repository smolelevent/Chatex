<?php
require __DIR__ . '/vendor/autoload.php';
// db.php now defines getDbConnection() function
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/websocket_constants.php';

//Ratchet használata a websocket szerver implementálásához
use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

class ChatServer implements MessageComponentInterface
{
    private mysqli $db;
    protected SplObjectStorage $clients;
    protected SplObjectStorage $userMap;

    //ez a metódus a websocket-et használó Dart-ok felé küldi vissza a status_update típusú üzeneteket!
    private function broadcastStatus(int $userId, int $signedInStatus, ?string $lastSeen): void
    {
        // For now, let's trust the passed $signedInStatus for efficiency,
        // assuming the caller (onMessage/onClose) has just updated it.
        // If we want to be super robust, we could re-query here.
        // $stmt = $this->db->prepare("SELECT signed_in FROM users WHERE id = ?");
        // $stmt->bind_param("i", $userId);
        // $stmt->execute();
        // $signedIn = $stmt->get_result()->fetch_assoc()['signed_in'] ?? 0;

        $payload = [
            'message_type' => 'status_update',
            'data' => [
                'user_id' => $userId,
                'signed_in' => $signedInStatus,
                'last_seen' => $signedInStatus ? null : $lastSeen, // last_seen is only relevant if offline
            ]
        ];

        foreach ($this->clients as $client) {
            $client->send(json_encode($payload));
        }

        echo "📡 Státusz broadcast: $userId => " . ($signedInStatus ? 'online' : 'offline') . "\n";
    }

    // Helper method to insert a message into the database
    private function _insertMessage(int $chatId, int $senderId, int $receiverId, ?string $messageText): ?int
    {
        $stmt = null;
        try {
            $stmt = $this->db->prepare("INSERT INTO messages (chat_id, sender_id, receiver_id, message_text) VALUES (?, ?, ?, ?)");
            $stmt->bind_param("iiis", $chatId, $senderId, $receiverId, $messageText);
            if (!$stmt->execute()) {
                error_log("❌ INSERT hiba (üzenet): " . $stmt->error . "\n");
                return null;
            }
            return $this->db->insert_id;
        } catch (Throwable $e) {
            error_log("Kivétel az üzenet beszúrásakor: " . $e->getMessage());
            return null;
        } finally {
            $stmt->close();
            
        }
    }

    // Helper method to insert an attachment into the database
    private function _insertAttachment(int $messageId, string $fileType, string $fileName, string $downloadUrl): void
    {
        $stmt = null;
        try {
            $stmt = $this->db->prepare("INSERT INTO message_attachments (message_id, file_type, file_name, download_url) VALUES (?, ?, ?, ?)");
            $stmt->bind_param("isss", $messageId, $fileType, $fileName, $downloadUrl);
            $stmt->execute();
        } catch (Throwable $e) {
            error_log("Kivétel a csatolmány beszúrásakor: " . $e->getMessage());
        } finally {
            $stmt->close();
            
        }
    }

    private function _sendImage($data, $messageId) : void {
        foreach ($data['images'] as $img) {
            $fileName = basename($img['file_name']);
            $imageData = base64_decode($img['image_data']);

            if (strlen($imageData) > MAX_IMAGE_ATTACHMENT_SIZE) {
                error_log("❌ $fileName túl nagy! Méret: " . strlen($imageData) . " byte. Max: " . MAX_IMAGE_ATTACHMENT_SIZE . " byte.");
                continue;
            }

            $uploadPath = MEDIA_UPLOAD_DIR . "/$fileName";
            if (!file_exists(dirname($uploadPath))) {
                mkdir(dirname($uploadPath), 0777, true);
            }

            file_put_contents($uploadPath, $imageData);

            $downloadUrl = BASE_UPLOAD_URL . "/media/$fileName";

            $this->_insertAttachment($messageId, 'image', $fileName, $downloadUrl);
        }
}

//TODO: nem is tudok kiemelni míg teljesen nem hagytam el a base64-et
//private function _sendFileOrImage($data, $messageId, $searchDataBy, $alias, $attachmentName, $attachmentContent){
//    foreach ($data[$searchDataBy] as $alias) {
//        $attachmentName = basename($alias['file_name']);
//        $attachmentContent = base64_decode($alias['file_bytes']);
//
//        if (strlen($attachmentContent) > MAX_FILE_ATTACHMENT_SIZE) {
//            error_log("❌ $attachmentName túl nagy! Méret: " . strlen($attachmentContent) . " byte. Max: " . MAX_FILE_ATTACHMENT_SIZE . " byte.");
//            continue;
//        }
//
//        $uploadPath = FILES_UPLOAD_DIR . "/$attachmentName";
//        if (!file_exists(dirname($uploadPath))) {
//            mkdir(dirname($uploadPath), 0777, true);
//        }
//        file_put_contents($uploadPath, $attachmentContent);
//
//        $downloadUrl = BASE_UPLOAD_URL . "/files/$attachmentName";
//
//        $this->_insertAttachment($messageId, 'file', $attachmentName, $downloadUrl);
//    }
//}
//
//    private function _sendFile($data, $messageId){
//        foreach ($data['files'] as $file) {
//            $fileName = basename($file['file_name']);
//            $fileContent = base64_decode($file['file_bytes']);
//
//            if (strlen($fileContent) > MAX_FILE_ATTACHMENT_SIZE) {
//                error_log("❌ $fileName túl nagy! Méret: " . strlen($fileContent) . " byte. Max: " . MAX_FILE_ATTACHMENT_SIZE . " byte.");
//                continue;
//            }
//
//            $uploadPath = FILES_UPLOAD_DIR . "/$fileName";
//            if (!file_exists(dirname($uploadPath))) {
//                mkdir(dirname($uploadPath), 0777, true);
//            }
//            file_put_contents($uploadPath, $fileContent);
//
//            $downloadUrl = BASE_UPLOAD_URL . "/files/$fileName";
//
//            $this->_insertAttachment($messageId, 'file', $fileName, $downloadUrl);
//        }
//}

    /**
     * Fetches a message and its attachments by ID and broadcasts it to all clients.
     */
    private function _broadcastMessageById(int $messageId, string $originalType): void
    {
        $stmt = null;
        try {
            // 1. Fetch the core message data
            $stmt = $this->db->prepare("SELECT * FROM messages WHERE message_id = ?");
            $stmt->bind_param("i", $messageId);
            $stmt->execute();
            $messageData = $stmt->get_result()->fetch_assoc();
            $stmt->close(); // Close this statement

            if (!$messageData) {
                error_log("Broadcast hiba: Nem található üzenet a(z) $messageId ID-val.");
                return;
            }

            // 2. Fetch attachments
            $stmt = $this->db->prepare("SELECT file_name, download_url FROM message_attachments WHERE message_id = ?");
            $stmt->bind_param("i", $messageId);
            $stmt->execute();
            $attResult = $stmt->get_result();

            $attachments = [];
            while ($row = $attResult->fetch_assoc()) {
                $attachments[] = $row;
            }

            // 3. Build and send the payload
            $payload = [
                'message_type' => $originalType,
                'data' => array_merge($messageData, ['attachments' => $attachments])
            ];

            $encodedPayload = json_encode($payload);
            foreach ($this->clients as $client) {
                $client->send($encodedPayload);
            }

            echo "Üzenet ($originalType) broadcastolva: " . json_encode($messageData) . "\n";
        } catch (Throwable $e) {
            error_log("Hiba az üzenet broadcastolása közben (ID: $messageId): " . $e->getMessage());
        } finally {
            $stmt->close();
            
        }
    }

    //felépíti a websocket servert
    public function __construct()
    {
        try {
            $this->db = getDbConnection();
            echo "DB kapcsolat létrejött\n";
        } catch (mysqli_sql_exception $e) {
            error_log("DB hiba a WebSocket szerver indításakor: " . $e->getMessage());
            echo "DB hiba: " . $e->getMessage() . "\n";
            // It's critical for the server to have a DB connection. Re-throwing might be better.
            throw $e;
        }
        $this->clients = new SplObjectStorage;
        $this->userMap = new SplObjectStorage;
    }

    //websocket kapcsolat nyításakor ez történjen
    public function onOpen(ConnectionInterface $conn): void
    {
        
        $this->clients->attach($conn);
        echo "Új kapcsolat: $conn->resourceId\n";
    }

    //ha üzenet érkezik a websocket szerverre akkor típus alapján különböző üzeneteket küldünk,
    //mind az adatbázis felé, mind a Dart felé!
    public function onMessage(ConnectionInterface $from, $msg): void
    {
        
        echo "Üzenet: $msg\n";

        $data = json_decode($msg, true);
        if (!$data) {
            error_log("Hibás üzenet érkezett: $msg");
            return;
        }

        $type = $data['message_type'];
        if (!isset($data['message_type'])) {
            error_log("❌ Üzenetben nincs type! Üzenet: $msg");
            return;
        }

        echo "típus: " . $type . "\n";

        try {
            $messageId = null;

            switch ($type) {
                case 'auth':
                    if (!isset($data['user_id'])) {
                        error_log("❌ Auth hiba: nincs user_id! Üzenet: $msg");
                        return;
                    }

                    $userId = intval($data['user_id']);
                    echo "✅ Azonosított felhasználó: $userId (kapcsolat: $from->resourceId)\n";

                    $this->userMap[$from] = $userId; //az üzenet küldője a megfelelő felhasználó legyen

                    $stmt = null;
                    try {
                        // signed_in = 1-re állítjuk a felhasználót mert jelen van az üzenetéből adódóan
                        $stmt = $this->db->prepare("UPDATE users SET signed_in = 1 WHERE id = ?");
                        $stmt->bind_param("i", $userId);
                        $stmt->execute();
                        $stmt->close(); // Close the statement immediately

                        // Lekérjük az aktuális státuszt és last_seen értéket
                        $stmt = $this->db->prepare("SELECT last_seen FROM users WHERE id = ?"); // 'status' column is not used for broadcastStatus anymore
                        $stmt->bind_param("i", $userId);
                        $stmt->execute();
                        $result = $stmt->get_result();
                        $user = $result->fetch_assoc();

                        $this->broadcastStatus($userId, 1, $user['last_seen']); // Pass 1 for signed_in status
                        return;
                    } catch (Throwable $e) {
                        error_log("Auth hiba a DB művelet során: " . $e->getMessage());
                    } finally {
                        $stmt->close();
                        
                    }
                    break;

                case 'ping':
                    echo "📡 Ping érkezett: $from->resourceId\n";
                    return;

                case 'text':
                    // csak szöveges üzenet
                    if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'])) return;
                    $chatId = intval($data['chat_id']);
                    $senderId = intval($data['sender_id']);
                    $receiverId = intval($data['receiver_id']);
                    $messageText = isset($data['message_text']) && trim($data['message_text']) !== '' ? trim($data['message_text']) : null;

                    $messageId = $this->_insertMessage($chatId, $senderId, $receiverId, $messageText);
                    if ($messageId === null) {
                        return;
                    }
                    break;

                case 'file':
                    echo "➡️ FILE feldolgozás indul...\n";
                    if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['files'])) {
                        error_log("❌ Hiányzó adat a file üzenethez! Üzenet: $msg");
                        return;
                    }

                    $chatId = intval($data['chat_id']);
                    $senderId = intval($data['sender_id']);
                    $receiverId = intval($data['receiver_id']);
                    $messageText = isset($data['message_text']) && trim($data['message_text']) !== '' ? trim($data['message_text']) : null;
                    
                    $messageId = $this->_insertMessage($chatId, $senderId, $receiverId, $messageText);
                    if ($messageId === null) {
                        return;
                    }
                    echo "✅ FILE messageId: $messageId\n";

                    foreach ($data['files'] as $file) {
                        $fileName = basename($file['file_name']);
                        $fileContent = base64_decode($file['file_bytes']);
                        
                        if (strlen($fileContent) > MAX_FILE_ATTACHMENT_SIZE) {
                            error_log("❌ $fileName túl nagy! Méret: " . strlen($fileContent) . " byte. Max: " . MAX_FILE_ATTACHMENT_SIZE . " byte.");
                            continue;
                        }

                        $path = FILES_UPLOAD_DIR . "/$fileName";
                        if (!file_exists(dirname($path))) {
                            mkdir(dirname($path), 0777, true);
                        }
                        file_put_contents($path, $fileContent);

                        $url = BASE_UPLOAD_URL . "/files/$fileName";

                        $this->_insertAttachment($messageId, 'file', $fileName, $url);
                    }

                    break;


                case 'image':
                    if (!isset($data['chat_id'], $data['sender_id'], $data['receiver_id'], $data['images'])) {
                        error_log("❌ Hiányzó image adatok! Üzenet: $msg");
                        return;
                    }

                    $chatId = intval($data['chat_id']);
                    $senderId = intval($data['sender_id']);
                    $receiverId = intval($data['receiver_id']);
                    $messageText = isset($data['message_text']) && trim($data['message_text']) !== ''
                        ? trim($data['message_text'])
                        : null;
                    
                    $messageId = $this->_insertMessage($chatId, $senderId, $receiverId, $messageText);
                    if ($messageId === null) {
                        return;
                    }

                    $this->_sendImage($data, $messageId);
                    break;
//                    foreach ($data['images'] as $img) {
//                        $fileName = basename($img['file_name']);
//                        $imageData = base64_decode($img['image_data']);
//
//                        if (strlen($imageData) > MAX_IMAGE_ATTACHMENT_SIZE) {
//                            error_log("❌ $fileName túl nagy! Méret: " . strlen($imageData) . " byte. Max: " . MAX_IMAGE_ATTACHMENT_SIZE . " byte.");
//                            continue;
//                        }
//
//                        $uploadPath = MEDIA_UPLOAD_DIR . "/$fileName";
//                        if (!file_exists(dirname($uploadPath))) {
//                            mkdir(dirname($uploadPath), 0777, true);
//                        }
//
//                        file_put_contents($uploadPath, $imageData);
//
//                        $downloadUrl = BASE_UPLOAD_URL . "/media/$fileName";
//
//                        $this->_insertAttachment($messageId, 'image', $fileName, $downloadUrl);
//                    }




                case 'read_status_update':
                    if (!isset($data['chat_id'], $data['user_id'])) {
                        error_log("Hiányzó adatok a read_status_update-hez! Üzenet: $msg");
                        return;
                    }

                    $chatId = intval($data['chat_id']);
                    $userId = intval($data['user_id']);

                    // Update messages as read for this user in this chat
                    foreach ($this->clients as $client) {
                        if (isset($this->userMap[$client]) && $this->userMap[$client] == $userId) {
                            $stmt = null;
                            try {
                                $stmt = $this->db->prepare("UPDATE messages SET is_read = 1 WHERE chat_id = ? AND receiver_id = ? AND is_read = 0");
                                $stmt->bind_param("ii", $chatId, $userId);
                                $stmt->execute();
                                // No break here, as we might want to update all clients for this user if they have multiple connections
                            } catch (Throwable $e) {
                                error_log("DB hiba a read_status_update során: " . $e->getMessage());
                            } finally {
                                $stmt->close();
                                
                            }
                        }
                    }

                    // Broadcast the read status to all relevant clients
                    $stmt = null;
                    try {
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
                                if (isset($this->userMap[$client]) && $this->userMap[$client] == $userId) { // Only send to relevant user's connections
                                    $client->send(json_encode($payload));
                                }
                            }
                        }
                    } catch (Throwable $e) {
                        error_log("DB hiba a read_status_update broadcast során: " . $e->getMessage());
                    } finally {
                        $stmt->close();
                    }
                    return;

                default:
                    error_log("Ismeretlen message_type: $type. Üzenet: $msg");
                    return;
            }

            if ($messageId) {
                $this->_broadcastMessageById($messageId, $type);
            }
        } catch (Throwable $e) {
            error_log("Kivétel történt az onMessage során: " . $e->getMessage());
        }
    }

    //websocket kapcsolat bezárásakor mi történjen!
    public function onClose(ConnectionInterface $conn): void
    {
        
        $this->clients->detach($conn);

        if (isset($this->userMap[$conn])) {
            $userId = $this->userMap[$conn];

            $stmt = null;
            try {
                // signed_in = 0
                $stmt = $this->db->prepare("UPDATE users SET signed_in = 0, last_seen = NOW() WHERE id = ?");
                $stmt->bind_param("i", $userId);
                $stmt->execute();
                $stmt->close(); // Close the statement immediately

                // Broadcast offline status
                $this->broadcastStatus($userId, 0, date("Y-m-d H:i:s")); // Pass 0 for signed_in status
            } catch (Throwable $e) {
                error_log("DB hiba a kapcsolat bezárásakor: " . $e->getMessage());
            } finally {
                $stmt->close();
            }
        }

        echo "Kapcsolat lezárva: $conn->resourceId\n";
        // The main DB connection ($this->db) is not closed here, as it's a long-running server.
        // It should be closed when the entire server process shuts down.
    }

    //hiba esetén mi történjen
    public function onError(ConnectionInterface $conn, Exception $e): void
    {
        
        echo "Hiba: {$e->getMessage()}\n";
        $conn->close();
    }
}
