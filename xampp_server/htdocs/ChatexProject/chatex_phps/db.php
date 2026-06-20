<?php
//ez a php felel az adatbázis kapcsolat létesítéséért, $conn változón keresztűl kezeljük
$serverIP = "localhost";
$serverUsername = "root";
$serverPassword = "";
$dbname = "dbchatex";

function getDbConnection(): mysqli {
    global $serverIP, $serverUsername, $serverPassword, $dbname;
    $conn = new mysqli($serverIP, $serverUsername, $serverPassword, $dbname);
    if($conn->connect_error){
        throw new mysqli_sql_exception("Kapcsolati hiba: " . $conn->connect_error);
    }
    return $conn;
}
