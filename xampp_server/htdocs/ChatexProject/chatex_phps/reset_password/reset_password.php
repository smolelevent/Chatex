<?php
//REST API
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

use PHPMailer\PHPMailer\PHPMailer; //PHPMailer email küldő csomag
use PHPMailer\PHPMailer\Exception; //kivétel kezelés (ha rossz az email valahogy)

require_once __DIR__ . "/../db.php"; //adatbázis kapcsolat
require_once __DIR__ . '/../vendor/autoload.php'; //csomagok betöltéséért

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["email"])) {
    echo json_encode(["success" => false, "message" => "Email megadása kötelező."]);
    exit();
}

$email = $data["email"];

//megnézzük hogy a megadott email címmel létezik ilyen felhasználó és eltároljuk az id-ét!
$stmt = $conn->prepare("SELECT id FROM users WHERE email = ?");
$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $userId = $row["id"];

    //jelszó helyreállítási token generálása és lejárati idő beállítása
    $token = bin2hex(random_bytes(20)); //egy random 20 karakteres sorozatot generálunk
    $expires = date("Y-m-d H:i:s", strtotime("+15 minutes")); //ami 15 percig lesz érvényes!

    //majd elmentjük az adott felhasználó adatai közé a token-t és a email lejárati idejét!
    $stmt = $conn->prepare("UPDATE users SET password_reset_token = ?, password_reset_expires = ? WHERE id = ?");
    $stmt->bind_param("ssi", $token, $expires, $userId);
    $stmt->execute();

    //eltároljuk a változóba a token alapú elérési útvonalat ami a jelszó helyreállító weboldalat fogja megnyitni!
    $resetLink = "http://localhost/ChatexProject/chatex_phps/reset_password/open_reset_window.php?token=$token";

    //PHPMailer konfigurálása és az email küldése!
    //létrehozunk egy példányt a PHPMailer-ből
    $mail = new PHPMailer(true);

    try {
        //SMTP beállítások
        $mail->isSMTP();
        $mail->Host = 'smtp.gmail.com'; //az email küldéshez szükséges SMTP szerver (pl. Gmail)
        $mail->SMTPAuth = true; //azonosított küldő lásd:
        $mail->Username = 'chatexfejlesztok@gmail.com'; //SMTP e-mail címed
        $mail->Password = 'uvatzwfcrjlcujrs'; //App Password (ami a vizsgaremekes email címünkön lett generálva!)
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; //biztonságos kapcsolattal küldünk (így nem fogja a spam mappába dobni!)
        $mail->Port = 587; //gmail által használt port
        $mail->CharSet = 'UTF-8';
        $mail->Encoding = 'base64';

        //Feladó és címzett
        $mail->setFrom('chatexfejlesztok@gmail.com', 'Chatex support (no reply)');
        $mail->addAddress($email); //az email mező alapján továbbítjuk oda amit a felhasználó megadott!

        //E-mail tartalma
        $mail->isHTML(true);
        $mail->Subject = "Jelszó visszaállítás";
        $mail->Body = "<h1>Kattints az alábbi linkre a jelszó visszaállításához:</h1>
                       <p><a href='$resetLink' target='_blank'>$resetLink</a></p>
                       <h2>Ez a link 15 percig érvényes.</h2>
                       <p>Chatex</p>";

        //E-mail küldés, majd visszajelzés Dart-nak
        if ($mail->send()) {
            echo json_encode(["success" => true, "message" => "Helyreállító e-mail elküldve."]);
        } else {
            echo json_encode(["success" => false, "message" => "E-mail küldése sikertelen."]);
        }
    } catch (Exception $e) {
        echo json_encode(["success" => false, "message" => "E-mail hiba: {$mail->ErrorInfo}"]);
    }
} else {
    //nem volt olyan felhasználó akinek a megadott email címe lenne!
    echo json_encode(["success" => false, "message" => "Nincs ilyen email című felhasználó!"]);
}

//kapcsolat lezárása
$stmt->close();
$conn->close();
