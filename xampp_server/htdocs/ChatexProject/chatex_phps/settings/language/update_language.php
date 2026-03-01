<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

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