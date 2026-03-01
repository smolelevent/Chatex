<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../../db.php'; //adatbázis kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

$chatId = intval($data['chat_id']);

//minden üzenetet lekérünk ami a chat_id-hez tartozik, csökkenő sorrendben! (last message miatt)
$query = $conn->prepare("SELECT * FROM messages WHERE chat_id = ? ORDER BY sent_at ASC");
$query->bind_param("i", $chatId);
$query->execute();
$result = $query->get_result();

$messages = [];

while ($row = $result->fetch_assoc()) {
    //végigmegyünk a lekérdezés tartalmán és... 
    $messageId = intval($row['message_id']);

    //minden üzenet id-hoz megnézzük hogy tartozik e csatolmány!
    $attachmentQuery = $conn->prepare("SELECT file_name, download_url, file_type FROM message_attachments WHERE message_id = ?");
    $attachmentQuery->bind_param("i", $messageId);
    $attachmentQuery->execute();
    $attachmentResult = $attachmentQuery->get_result();

    $attachments = [];
    while ($attachment = $attachmentResult->fetch_assoc()) {
        //eltároljuk a csatolmányokat
        $attachments[] = $attachment;
    }

    if (isset($row['message_text']) && trim($row['message_text']) === '') {
        //ha valaki üres szöveget küldött el akkor NULL-oljuk az üzenetet pl.: csatolmány jelenik csak meg és szöveg nem
        $row['message_text'] = null;
    }

    $row['attachments'] = $attachments;

    $hasText = !empty($row['message_text']);
    $hasAttachments = !empty($attachments);

    if ($hasAttachments) {
        //megnézzük milyen csatolmányt küldött (kép vagy file)
        $firstType = $attachments[0]['file_type'] ?? 'file';
        //és eltároljuk az üzenet típusát
        $row['message_type'] = $firstType === 'image' ? 'image' : 'file';
    } elseif ($hasText) {
        $row['message_type'] = 'text';
    } else {
        $row['message_type'] = 'text'; //alapértelmezetten szöveg típusú
    }

    $messages[] = $row;
}

//vissza adjuk messages tömbként!
echo json_encode(["messages" => $messages]);

//$stmt->close(); <- ez okozta a Kapcsolati hibát az üzenetek betöltésekor mivel nincs ilyen változó a fájlban!
$conn->close();
