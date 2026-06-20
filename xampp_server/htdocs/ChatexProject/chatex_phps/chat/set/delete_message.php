<?php

require_once __DIR__ . '/../../bootstrap.php';

$data = json_decode(file_get_contents("php://input"), true);

$messageId = intval($data['message_id']);

/**
 * @var mysqli $conn The database connection object, created in bootstrap.php
 */
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
