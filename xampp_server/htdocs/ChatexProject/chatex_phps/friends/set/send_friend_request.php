<?php
/**
 * @var mysqli $conn The database connection object, created in bootstrap.php
 */
require_once __DIR__ . '/../../bootstrap.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"]) || !isset($data["friend_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó paraméterek!"]);
    exit;
}

$user_id = intval($data["user_id"]);
$friend_id = intval($data["friend_id"]);

//barátjelölés felvétele a friend_requests táblába, függőben lévő (pending) státusszal
//created_at alapján jelenítjük meg csökkenő sorrenben (melyik kérés a legfrissebb)
$query = "INSERT INTO friend_requests (sender_id, receiver_id, status, created_at) VALUES (?, ?, 'pending', NOW())";
$stmt = $conn->prepare($query);
$stmt->bind_param("ii", $user_id, $friend_id);

//Dart felé írányuló válasz
if ($stmt->execute()) {
    echo json_encode([
        "success" => true,
        "message" => "Barátjelölés elküldve!"
    ]);
} else {
    echo json_encode(["success" => false, "message" => "Hiba történt a barátjelölés során!"]);
}

//kapcsolatok lezárása
$stmt->close();
$conn->close();
