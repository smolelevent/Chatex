<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../../db.php'; //kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

$chatId = intval($data["chat_id"]);
$userId = intval($data["user_id"]);

//csak olyan üzeneteket frissítsünk amiket még nem "láttamoztak le"
$stmt = $conn->prepare("
    UPDATE messages
    SET is_read = 1
    WHERE chat_id = ? AND receiver_id = ? AND is_read = 0
");

$stmt->bind_param("ii", $chatId, $userId);
$stmt->execute();

echo json_encode(["success" => true]);

$stmt->close();
$conn->close();
