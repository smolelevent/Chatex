<?php
/**
 * @var mysqli $conn The database connection object, created in bootstrap.php
 */
require_once __DIR__ . '/../../bootstrap.php';

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
