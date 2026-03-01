<?php
//ez a php felel az adatbázis kapcsolat létesítéséért, $conn változón keresztűl kezeljük
$serverIP = "localhost";
$serverUsername = "root";
$serverPassword = "";
$dbname = "dbchatex";

$conn = new mysqli($serverIP, $serverUsername, $serverPassword, $dbname);

if ($conn->connect_error) {
    http_response_code(500); // Belső szerverhiba
    echo json_encode(["message" => "Adatbázis kapcsolat sikertelen: " . $conn->connect_error]);
    exit();
}
