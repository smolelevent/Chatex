<?php
/**
 * @var mysqli $conn The database connection object, created in bootstrap.php
 */
require_once __DIR__ . '/../../bootstrap.php';

$data = json_decode(file_get_contents("php://input"), true);

$user_id = $data["user_id"] ?? null;
$language = $data["language"] ?? null;

if (!$user_id || !$language) {
    echo json_encode(["success" => false, "message" => "Hiányzó paraméterek"]);
    exit;
}

//preferált nyelv frissítése (angol vagy magyar jelenleg)
$stmt = $conn->prepare("UPDATE users SET preferred_lang = ? WHERE id = ?");
$stmt->bind_param("si", $language, $user_id);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "nyelv sikeresen frissítve"]);
} else {
    echo json_encode(["success" => false, "message" => "sikertelen frissítés"]);
}

$stmt->close();
$conn->close();