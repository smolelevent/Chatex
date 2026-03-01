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

if (!isset($userData['user_id']) || !isset($userData['password'])) {
    echo json_encode(["status" => "error", "message" => "Hiányzó adatok!"]);
    exit();
}

$user_id = intval($userData['user_id']);
$password = trim($userData['password']);

//Hasheljük a jelszót biztonságosan
$password_hash = password_hash($password, PASSWORD_DEFAULT);

//a következő bejelentkezésnél már érvénybe fog lépni!
$stmt = $conn->prepare("UPDATE users SET password_hash = ? WHERE id = ?");
$stmt->bind_param("si", $password_hash, $user_id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => "Frissítés sikertelen!"]);
}

$stmt->close();
$conn->close();
