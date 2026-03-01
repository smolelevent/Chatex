<?php
//REST API
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require_once __DIR__ . '/../vendor/autoload.php'; //Composer csomag
require_once __DIR__ . '/../db.php'; //Adatbázis kapcsolat

use Firebase\JWT\JWT; //token kezelő
use Firebase\JWT\Key; //kulcs kezelő (mivel dekódolni kell, ha visszalép a felhasználó)

$data = json_decode(file_get_contents("php://input"), true);
$token = $data["token"] ?? "";

if (!$token) {
    echo json_encode(["success" => false, "message" => "Hiányzó token!"]);
    exit;
}

$secret_key = "chatex"; //a titkos kulcs jelen tárolása nem ajánlott, de mivel localhost-on fut így megengedett...

try {
    //dekódolja és ha sikeres volt vissza küldjük az adatokat (így nem kell új adatbázis kéréseket végrehajtani)
    $decoded = JWT::decode($token, new Key($secret_key, 'HS256'));
    echo json_encode([
        "success" => true,
        "id" => $decoded->id,
        "preferred_lang" => $decoded->preferred_lang,
        "profile_picture" => $decoded->profile_picture,
        "username" => $decoded->username,
        "email" => $decoded->email,
        "password_hash" => $decoded->password_hash
    ]);
} catch (Exception $e) {
    echo json_encode(["success" => false, "message" => "Érvénytelen token: " . $e->getMessage()]);
}

//$stmt->close(); <- ez okozta a Kapcsolati hibát a token validálásakor mivel nincs ilyen változó a fájlban!
$conn->close();
