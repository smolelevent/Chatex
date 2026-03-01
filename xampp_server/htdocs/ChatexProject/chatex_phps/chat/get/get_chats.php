<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //adatbázis kapcsolat (fontos hogy megfelelő mappába keressük!)

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    http_response_code(400);
    echo json_encode(["error" => "Hiányzó user azonosító!"]);
    exit;
}

$user_id = intval($data["user_id"]);

//a felhasználó id-ja alapján lekérjük a beszélgetéseit! (külön kezelve az utolsó üzenet típusát lásd: SELECT CASE....)
//aliasok és 2 tábla bevonásával kérjük le a beszélgetések összes adatát
$query = "
    SELECT 
        c.chat_id,
        c.is_group,
        u.id AS friend_id,
        u.username AS friend_name,
        u.profile_picture AS friend_profile_picture,
        u.last_seen AS friend_last_seen,
        u.status,
        u.signed_in,

        (
            SELECT 
                CASE
                    WHEN m.message_text IS NOT NULL AND TRIM(m.message_text) != '' THEN m.message_text
            WHEN EXISTS (
                SELECT 1 FROM message_attachments ma WHERE ma.message_id = m.message_id AND ma.file_type = 'image'
            ) THEN '[IMAGE]'
            WHEN EXISTS (
                SELECT 1 FROM message_attachments ma WHERE ma.message_id = m.message_id AND ma.file_type = 'file'
            ) THEN '[FILE]'
            ELSE ''
                END
            FROM messages m
            WHERE m.chat_id = c.chat_id
            ORDER BY m.sent_at DESC
            LIMIT 1
        ) AS last_message,

        (
            SELECT m.sender_id
            FROM messages m
            WHERE m.chat_id = c.chat_id
            ORDER BY m.sent_at DESC
            LIMIT 1
        ) AS last_sender_id,

        (
            SELECT m.sent_at
            FROM messages m
            WHERE m.chat_id = c.chat_id
            ORDER BY m.sent_at DESC
            LIMIT 1
        ) AS last_message_time,

        (
            SELECT COUNT(*)
            FROM messages m
            WHERE m.chat_id = c.chat_id
              AND m.receiver_id = ?
              AND m.is_read = 0
        ) AS unread_count

    FROM chats c
    INNER JOIN chat_members cm ON cm.chat_id = c.chat_id
    INNER JOIN chat_members other_cm ON other_cm.chat_id = c.chat_id AND other_cm.user_id != ?
    INNER JOIN users u ON u.id = other_cm.user_id

    WHERE cm.user_id = ? AND c.is_group = 0
    ORDER BY last_message_time DESC
";

$stmt = $conn->prepare($query);

//az első paraméter azt csinálja hogy a megadott id lesz az üzenet fogadója hogy megtudjuk hány olvasatlan üzenete van!
//a második az a keresésre irányúl ahol a megadott id nem lehet a másik fél! (tehát a küldő)
//a harmadik paraméter pedig a feltételt adja meg hogy csak olyan adatokat kérjen le amik a felhasználóhoz tartoznak, és nem csoport!
$stmt->bind_param("iii", $user_id, $user_id, $user_id);
$stmt->execute();
$result = $stmt->get_result();

$chatList = [];

while ($row = $result->fetch_assoc()) {
    //az eredmény eltároljuk egyesével egy közre fogó tömbbe (tömb a tömb-ben!)
    $chatList[] = $row;
}

//majd visszaadjuk a programnak!
echo json_encode($chatList);

$stmt->close();
$conn->close();
