<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
    echo json_encode(["success" => false, "message" => "Hiányzó felhasználói azonosító!"]);
    exit;
}

$user_id = $data["user_id"];

//mind a kettő írányban (user_id, friend_id) lekérjük a felhasználó barátait, amit unióval egyesítünk!
$query = "
    SELECT u.id, u.username, u.profile_picture
    FROM friends f
    JOIN users u ON u.id = f.friend_id
    WHERE f.user_id = ?
    
    UNION
    
    SELECT u.id, u.username, u.profile_picture
    FROM friends f
    JOIN users u ON u.id = f.user_id
    WHERE f.friend_id = ?
";

$stmt = $conn->prepare($query);
$stmt->bind_param("ii", $user_id, $user_id);
$stmt->execute();
$result = $stmt->get_result();

$friends = [];
while ($row = $result->fetch_assoc()) {
    $friends[] = $row;
}

//és a barátok tömb a tömb-bent adjuk vissza!
echo json_encode(["success" => true, "friends" => $friends]);

$stmt->close();
$conn->close();
