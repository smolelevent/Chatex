<?php

require_once __DIR__ . '/../bootstrap.php';

//TODO: egyáltalán kell-e?
function normalizeEmail($email)
//ez a metódus engedélyezi a több felhasználó létrehozását ugyanazzal a Gmail-es email címmel!
{
    //a pontokat és a + utáni részt eltávolítjuk
    if (str_contains($email, '@gmail.com')) {
        $emailParts = explode('@', $email);
        $localPart = str_replace('.', '', $emailParts[0]); // Pontok eltávolítása
        $localPart = explode('+', $localPart)[0]; // + utáni rész eltávolítása
        return $localPart . '@gmail.com';
    }
    return $email;
}

$userData = json_decode(file_get_contents("php://input"), true);

$username = trim($userData['username']);
$email = normalizeEmail(trim($userData['email']));
$password = trim($userData['password']);
$password_hash = password_hash($password, PASSWORD_DEFAULT);
$language = $userData['language'];

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400); // Hibás kérés
    echo json_encode(["message" => "Érvénytelen email cím!"]);
    exit();
}

/**
 * @var mysqli $conn The database connection object, created in bootstrap.php
 */

$checkStmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$checkStmt->bind_param("s", $email);
$checkStmt->execute();
$checkStmt->store_result();

if ($checkStmt->num_rows > 0) {
    http_response_code(409); //konfliktus
    echo json_encode(["message" => "Ezzel az emailel már létezik felhasználó!"]);
    exit();
}

//ha nem létezik akkor végig megy a regisztráció! (NOW() a mostani időre gondol másodperc pontossággal)
$stmt = $conn->prepare("INSERT INTO users (preferred_lang, username, email, password_hash, created_at) VALUES (?, ?, ?, ?, NOW())");
if ($stmt === false) {
    http_response_code(500); // Belső szerverhiba
    echo json_encode(["message" => "SQL előkészítési hiba."]);
    exit();
}

$stmt->bind_param("ssss", $language, $username, $email, $password_hash);

if ($stmt->execute()) {
    http_response_code(201); //erőforrás létrehozva
    echo json_encode([
        "message" => "Sikeres regisztráció!",
        "username" => $username,
        "email" => $email,
        "password_hash" => $password_hash,
        "preferred_lang" => $language
    ]);
} else {
    http_response_code(500); //belső szerverhiba
    echo json_encode(["message" => "Sikertelen regisztráció!"]);
}

//lezárjuk a kapcsolatot!
$stmt->close();
$conn->close();
