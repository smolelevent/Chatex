<?php
// Adatbázis kapcsolódási adatok
// Fejlesztéshez jó, de éles környezetben hozz létre dedikált felhasználót!
const DB_HOST = 'localhost';
const DB_USER = 'root';
const DB_PASS = '';
const DB_NAME = 'dbchatex';

function getDbConnection(): mysqli
{
    // A 'static' kulcsszó biztosítja, hogy a kapcsolat csak egyszer jöjjön létre
    // egy kérés során, még ha a függvényt többször is meghívják.
    static $conn = null;

    if ($conn === null) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        try {
            $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
            $conn->set_charset("utf8mb4");
        } catch (mysqli_sql_exception $e) {
            error_log('Adatbázis kapcsolódási hiba: ' . $e->getMessage());
            http_response_code(503); // Service Unavailable
            echo json_encode(['message' => 'A szolgáltatás átmenetileg nem elérhető.']);
            exit();
        }
    }
    return $conn;
}