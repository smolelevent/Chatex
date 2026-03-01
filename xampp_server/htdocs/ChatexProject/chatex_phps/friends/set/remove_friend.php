<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

$conn = getDbConnection();
$input = file_get_contents("php://input");
$userData = json_decode($input, true);

if (!isset($userData["user_id"], $userData["friend_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adatok!"]);
    exit;
}

$user_id = $userData["user_id"];
$friend_id = $userData["friend_id"];

//a bekért id-kból mind a két írányban töröljük a barátságot (itt sincs még visszajelzés a felhasználók felé...)
$query = "DELETE FROM friends 
          WHERE (user_id = ? AND friend_id = ?) 
             OR (user_id = ? AND friend_id = ?)";

$stmt = $conn->prepare($query);
$stmt->bind_param("iiii", $user_id, $friend_id, $friend_id, $user_id);

//értelmezés a Dart-nak!
if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Barát törölve!"]);
} else {
    echo json_encode(["success" => false, "message" => "Hiba a törlés közben!"]);
}

$stmt->close();
$conn->close();
