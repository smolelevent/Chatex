<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['username']) || !isset($data['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Hiányzó adatok"]);
    exit();
}

$username = trim($data['username']); //felhasználónév megtisztítása
$user_id = intval($data['user_id']); //biztonságos integer konverzió

$query = "UPDATE users SET username = ? WHERE id = ?";
$stmt = $conn->prepare($query);

if ($stmt) {
    $stmt->bind_param("si", $username, $user_id);
    if ($stmt->execute()) {
        //egyből megjelenik (ajánlott kilépni!)
        echo json_encode(["status" => "success", "message" => "Felhasználónév frissítve"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Hiba a frissítés során"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Adatbázis hiba"]);
}

$stmt->close();
$conn->close();
