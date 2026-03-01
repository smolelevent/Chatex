<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

$user_id = intval($data["user_id"]);
$friend_id = intval($data["friend_id"]);

//ez a lekérdezés megnézi hogy a kettő felhasználó (mind a két írányban) barátok e vagy sem
$query = "SELECT * FROM friends WHERE (user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)";
$stmt = $conn->prepare($query);
$stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);
$stmt->execute();

$result = $stmt->get_result();
if ($result->num_rows > 0) {
    //ez határozza meg hogy tudsz chatet létrehozni vele, vagy hogy hogy jelenik meg a felhasználók keresésénél!
    echo json_encode(["success" => true, "message" => "already_friends"]);
    exit;
}

//ha nem barátok még akkor megnézzük hogy a friend_requests tábla tartalmazza e (mind a két írányból)
$query = "SELECT * FROM friend_requests WHERE ((sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)) AND status = 'pending'";
$stmt = $conn->prepare($query);
$stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);
$stmt->execute();

$result = $stmt->get_result();
if ($result->num_rows > 0) {
    //ha igen akkor külön message
    echo json_encode(["success" => true, "message" => "pending_request"]);
    exit;
}

//és ha egyik sem akkor pedig a can_send message-el tér vissza!
//(Dart oldalon ez a 3 message alapján kezeljük az állapotot a felhasználók keresésénél)
echo json_encode(["success" => true, "message" => "can_send"]);

$stmt->close();
$conn->close();
