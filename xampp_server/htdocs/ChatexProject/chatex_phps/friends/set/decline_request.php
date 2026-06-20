<?php
/**
 * @var mysqli $conn The database connection object, created in bootstrap.php
 */
require_once __DIR__ . '/../../bootstrap.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["request_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó adat!"]);
    exit;
}

$request_id = intval($data["request_id"]);

//töröljük a barátkérést a kérések táblából ha valamelyik oldalt el lett utasítva (jelenleg ennek nincsen visszajelzése...)
$query = "DELETE FROM friend_requests WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("i", $request_id);
$success = $stmt->execute();

//true/false értéket küldünk vissza!
echo json_encode(["success" => $success]);

$stmt->close();
$conn->close();