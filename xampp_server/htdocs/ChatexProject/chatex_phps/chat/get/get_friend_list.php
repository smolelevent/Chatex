<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . "/../../db.php"; //adatbázis kapcsolat

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["user_id"])) {
  echo json_encode(["success" => false, "message" => "Hiányzó user_id!"]);
  exit;
}

$user_id = intval($data["user_id"]);

//lekérjük az összes olyan barát adatait akikkel még nincsen létrehozva chat!
$query = "
    SELECT u.id, u.username, u.profile_picture
    FROM friends f
    JOIN users u ON u.id = f.friend_id
    WHERE f.user_id = ?
      AND NOT EXISTS (
        SELECT 1
        FROM chats c
        JOIN chat_members cm1 ON cm1.chat_id = c.chat_id
        JOIN chat_members cm2 ON cm2.chat_id = c.chat_id
        WHERE c.is_group = 0
          AND cm1.user_id = ?
          AND cm2.user_id = f.friend_id
      )
";

$stmt = $conn->prepare($query);
//az első paraméter megadja hogy a friends táblából mindenkit kérjen le ahol a user_id megegyezik a felhasználóéval! (tehát ha hozzá tartozik)
//a második paraméter pedig megadja hogy csak azokat az adatokat kérje le akikkel a felhasználó még nem kezdett beszélgetést!
$stmt->bind_param("ii", $user_id, $user_id);
$stmt->execute();

$result = $stmt->get_result();

$friends = [];
while ($row = $result->fetch_assoc()) {
  //ugyanúgy mint a get_chats.php-ban, itt is tömb a tömb-ben választ adunk vissza!
  $friends[] = $row;
}

echo json_encode($friends);

$stmt->close();
$conn->close();
