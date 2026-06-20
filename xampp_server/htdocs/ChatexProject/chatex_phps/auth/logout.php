<?php
require_once __DIR__ . '/../bootstrap.php';

/**
 * @var mysqli $conn The database connection object, created in bootstrap.php
 */

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    send_json_response(["success" => false, "message" => "Hiányzó user_id!"], 400);
}

$userId = intval($data["user_id"]);

$query = "UPDATE users SET signed_in = 0, last_seen = NOW() WHERE id = ?";
$stmt = $conn->prepare($query);

try {
    $stmt->bind_param("i", $userId);

    if ($stmt->execute()) {
        send_json_response(["success" => true, "message" => "Sikeres kijelentkezés."]);
    } else {
        send_json_response(["success" => false, "message" => "Adatbázis hiba a kijelentkezés során."], 500);
    }
} finally {
    $stmt?->close();
    $conn->close();
}
