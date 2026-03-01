<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["request_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adat!"]);
    exit;
}

$request_id = intval($data["request_id"]);

//lekérjük az adott kéréshez szükséges felhasználókat (ki küldte kinek!)
$query = "SELECT sender_id, receiver_id FROM friend_requests WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $request_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["success" => false, "message" => "Nincs ilyen kérés!"]);
    exit;
}

$row = $result->fetch_assoc();
$user1 = $row["receiver_id"];
$user2 = $row["sender_id"];

//majd a kinyert felhasználókat beszúrjuk egymás barátlistájába dátummal együtt
$insertQuery = "INSERT INTO friends (user_id, friend_id, created_at) VALUES (?, ?, NOW()), (?, ?, NOW())";
$insertStmt = $conn->prepare($insertQuery);
$insertStmt->bind_param("iiii", $user1, $user2, $user2, $user1);
$insertSuccess = $insertStmt->execute();

if (!$insertSuccess) {
    echo json_encode(["success" => false, "message" => "Nem sikerült felvenni barátnak."]);
    exit;
}

//ha a elfogadás sikeres volt, akkor töröljük a megfelelő kérést
$deleteQuery = "DELETE FROM friend_requests WHERE id = ?";
$deleteStmt = $conn->prepare($deleteQuery);
$deleteStmt->bind_param("i", $request_id);
$deleteSuccess = $deleteStmt->execute();

//és Dartnak továbbítunk mind bool-t és mind stringet válaszként
if ($deleteSuccess) {
    echo json_encode(["success" => true, "message" => "Barátság létrejött!"]);
} else {
    echo json_encode(["success" => false, "message" => "Barát hozzáadva, de nem sikerült törölni a kérést."]);
}

$stmt->close();
$conn->close();
