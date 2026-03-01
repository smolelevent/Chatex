<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó paraméter!"]);
    exit;
}

$user_id = intval($data["user_id"]);

//itt a user_id maga a fogadó aki megszeretné tudni a küldője adatait (barátkérés kezelő képernyő)
$query = "
    SELECT fr.id, u.username, u.profile_picture, fr.sender_id 
    FROM friend_requests fr
    JOIN users u ON fr.sender_id = u.id
    WHERE fr.receiver_id = ? AND fr.status = 'pending'
";

$stmt = $conn->prepare($query);

//tehát receiver_id-nál keressük!
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$friendRequests = [];
while ($row = $result->fetch_assoc()) {
    $friendRequests[] = $row;
}

//sikeres lekérdezés, és maga az adatot küldjük vissza
echo json_encode([
    "success" => true,
    "requests" => $friendRequests,
]);

$stmt->close();
$conn->close();
