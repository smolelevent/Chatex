<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

if ($data['query'] == " ") {
    //az üres karakterek keresését nem kezeljük
    echo json_encode(["error" => "Hibás lekérdezés!"]);
    http_response_code(400);
    exit();
}

//elmentjük a keresendő szöveget amit %-ek használatával nézzük hogy van e előtte vagy utána karakter!
$query = "%" . $conn->real_escape_string($data['query']) . "%";

//limitáljuk 10 eredményre (nincsen annyi felhasználó, és könnyebb kezelni!)
$sql = "SELECT id, username, profile_picture FROM users WHERE username LIKE ? LIMIT 10";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $query);
$stmt->execute();
$result = $stmt->get_result();

$users = [];

//az eredmény adatait szét bontjuk majd elmentve átadjuk a Dart-nak!
while ($row = $result->fetch_assoc()) {
    $users[] = [
        "id" => $row["id"],
        "username" => $row["username"],
        "profile_picture" => $row["profile_picture"]
    ];
}

echo json_encode($users);

$stmt->close();
$conn->close();
