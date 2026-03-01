<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../../db.php'; //adatbázis kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

$chatId = intval($data['chat_id']);
$userId = intval($data['user_id']);

//megszámoljuk az összes olyan chatet amihez a felhasználónak köze van!
$stmt = $conn->prepare("SELECT COUNT(*) as cnt FROM chat_members WHERE chat_id = ? AND user_id = ?");
$stmt->bind_param("ii", $chatId, $userId);
$stmt->execute();
$result = $stmt->get_result()->fetch_assoc();

if ($result['cnt'] == 0) { //ez azért szükséges hogyha valaki illetéktelen hozzáférni a felülethez ("jobb félni mint megijedni")
    echo json_encode(["success" => false, "error" => "Nincs jogosultságod törölni ezt a chatet."]);
    exit;
}

//ha van jogosultsági töröljük a chat minden adatát (az adatbázis szerkezete miatt az összekapcsolt táblákból is törlödnek az adatok!)
$stmt = $conn->prepare("DELETE FROM chats WHERE chat_id = ?");
$stmt->bind_param("i", $chatId);
$success = $stmt->execute();

//válasz
echo json_encode(["success" => $success]);

$stmt->close();
$conn->close();
