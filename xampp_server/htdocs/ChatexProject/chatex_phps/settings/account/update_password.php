<?php
/**
 * @var mysqli $conn The database connection object, created in bootstrap.php
 */
require_once __DIR__ . '/../../bootstrap.php';


$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['user_id']) || !isset($data['password'])) {
    echo json_encode(["status" => "error", "message" => "Hiányzó adatok!"]);
    exit();
}

$user_id = intval($data['user_id']);
$password = trim($data['password']);

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
