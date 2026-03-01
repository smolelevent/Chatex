<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["sender_id"]) || !isset($data["receiver_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adatok!"]);
    exit;
}

//két felhasználó id-ja akikkel létrehozzuk a chatet!
$senderId = intval($data["sender_id"]);
$receiverId = intval($data["receiver_id"]);

//nem csoportként hozzuk létre (egy bool változó felel azért)
$insertChat = $conn->prepare("INSERT INTO chats (is_group) VALUES (0)");
$insertChat->execute();
$chatId = $conn->insert_id;

//a tagok táblába felvesszük az illetőket
$insertMember = $conn->prepare("INSERT INTO chat_members (chat_id, user_id) VALUES (?, ?)");
$insertMember->bind_param("ii", $chatId, $senderId);
$insertMember->execute();

//kétszer hajtuk végre más felhasználóval
$insertMember->bind_param("ii", $chatId, $receiverId);
$insertMember->execute();

//és mivel egyből megnyitjuk a chatet szükség van a fogadó felhasználó adataira!
$friendQuery = $conn->prepare("SELECT username, profile_picture, status, signed_in, last_seen FROM users WHERE id = ?");
$friendQuery->bind_param("i", $receiverId);
$friendQuery->execute();
$friendResult = $friendQuery->get_result();
$friendData = $friendResult->fetch_assoc();

//majd válaszként el is küldjük azokat!
echo json_encode([
    "success" => true,
    "message" => "Chat létrehozva!",
    "chat_id" => $chatId,
    "friend_id" => $receiverId,
    "friend_name" => $friendData["username"],
    "friend_profile_picture" => $friendData["profile_picture"],
    "status" => $friendData["status"],
    "signed_in" => $friendData["signed_in"],
    "last_seen" => $friendData["last_seen"],
]);

//$stmt->close(); <- ez okozta a Kapcsolati hibát a chat indításakor mivel nincs ilyen változó a fájlban!
$conn->close();
