<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../db.php'; //Adatbázis kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    http_response_code(400);
    echo json_encode(["success" => false, "message" => "Hiányzó user_id!"]);
    exit;
}

$userId = intval($data["user_id"]);

//Csak a belépést frissítjük az állapotot nem, mert egyénileg beállított offline is lehet a felhasználó
$query = "UPDATE users SET signed_in = 0, last_seen = NOW() WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $userId);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "Sikeres kijelentkezés."]);
} else {
    echo json_encode(["success" => false, "message" => "Nem sikerült frissíteni."]);
}

//lezárjuk a kapcsolatot!
$stmt->close();
$conn->close();
