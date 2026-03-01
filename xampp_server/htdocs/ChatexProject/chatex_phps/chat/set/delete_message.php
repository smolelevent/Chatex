<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../../db.php'; //kapcsolat

$conn = getDbConnection();
$input = file_get_contents("php://input");
$userData = json_decode($input, true);

$messageId = intval($userData['message_id']);

$stmt = $conn->prepare("DELETE FROM messages WHERE message_id = ?");
$stmt->bind_param("i", $messageId);
$stmt->execute();

//ha a felhasználó üzenetet akar törölni akkor a csatolmányokat is töröljük ami az üzenethez tartozik!

$stmt = $conn->prepare("DELETE FROM message_attachments WHERE message_id = ?");
$stmt->bind_param("i", $messageId);
$stmt->execute();

echo json_encode(["success" => true]);

$stmt->close();
$conn->close();
