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

if (!isset($userData['profile_picture']) || !isset($userData['user_id'])) {
    echo json_encode(["status" => "error", "message" => "Hiányzó adatok"]);
    exit();
}

$profile_picture = $userData['profile_picture'];
$user_id = intval($userData['user_id']); //biztonságos integer konverzió

$query = "UPDATE users SET profile_picture = ? WHERE id = ?";
$stmt = $conn->prepare($query);

if ($stmt) {
    $stmt->bind_param("si", $profile_picture, $user_id);
    //egyből megjelenik a változtatás, nem is kell kijelentkezni, de azért ajánlott!
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Profilkép frissítve"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Hiba a frissítés során"]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Adatbázis hiba"]);
}

$stmt->close();
$conn->close();
