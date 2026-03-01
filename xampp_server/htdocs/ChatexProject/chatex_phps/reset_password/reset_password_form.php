<?php
//a tényleges jelszó helyreállító HTML ami az átírányítás után kell hogy megjelenjen (viszonylag középre igazítva!)

require_once __DIR__ . "/../db.php";

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    //post kérés esetében (amikor submit-oljuk a Formot) alkalmazzuk a REST API header-eket
    header("Content-Type: application/json");
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

    //az átírányításkor átvett tokent elmentjük
    $token = $_POST["token"] ?? '';

    //az új jelszót pedig a Form submitolásakor tároljuk el
    $newPassword = $_POST["new_password"] ?? '';

    if (!$token || !$newPassword) {
        echo json_encode(["success" => false, "message" => "Érvénytelen kérés."]);
        exit;
    }

    //lekérjük a token alapján melyik felhasználóról van szó!
    $stmt = $conn->prepare("SELECT id, email FROM users WHERE password_reset_token = ? AND password_reset_expires > NOW()");
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        $userId = $row["id"];
        $userEmail = $row["email"];

        //hasheljük a felhasználó új jelszavát (biztonságos eltárolás!) és le NULL-oljuk a helyreállítási mezőket!
        $hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);
        $stmt = $conn->prepare("UPDATE users SET password_hash = ?, password_reset_token = NULL, password_reset_expires = NULL WHERE id = ?");
        $stmt->bind_param("si", $hashedPassword, $userId);
        $stmt->execute();

        echo json_encode(["success" => true, "message" => "Jelszó sikeresen frissítve!"]);
    } else {
        //Érvénytelen vagy lejárt token (ha túl lépte a 15 percet)
        echo json_encode(["success" => false, "message" => "A jelszó helyreállító email lejárt!"]);
    }

    $stmt->close();
    $conn->close();
    exit;
}

//Ha nem POST kérés (form által küldött adat), hanem GET (az oldal megjelenik) akkor:

$token = $_GET["token"] ?? '';
if (!$token) {
    die("Érvénytelen token.");
}

//lekérjük az email címet a token alapján (hogy megjelenítsük a felhasználónak)
$stmt = $conn->prepare("SELECT email FROM users WHERE password_reset_token = ? AND password_reset_expires > NOW()");
$stmt->bind_param("s", $token);
$stmt->execute();
$result = $stmt->get_result();

$userEmail = "";

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    //eltároljuk az emailt ami meg fog jelenni a helyreállító html-n!
    $userEmail = $row["email"];
} else {
    //ha nem volt olyan email ahol megegyezett a token akkor érvénytelen html-t jelenítünk meg:
    die('<!DOCTYPE html>
        <html lang="hu">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Érvénytelen vagy lejárt token</title>
        <style>
        * {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: rgb(124, 76, 255);
            display: flex;
            align-items: center;
            height: 100vh;
            text-align: center;
        }

        .content {
            max-width: 100%;
        }

        h1, h2 {
            color: white;
        }
        </style>
        </head>
        <body>
        <div class="content">
        <h1>Érvénytelen vagy lejárt token.</h1>
        <br>
        <h2>Jelentés: kérvényezz egy új jelszó helyreállításos emailt!</h2>
        </div>
        </body>
        </html>');
}

//különben pedig (ha érvényes):
echo '<!DOCTYPE html>
<html lang="hu">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jelszó visszaállítás</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background-color: rgb(124, 76, 255);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            width: 90%;
            max-width: 400px;
            border: 2px solid black;
        }

        h2 {
            margin-bottom: 10px;
            color: #333;
        }

        p {
            font-size: 14px;
            color: #666;
            margin-bottom: 20px;
        }

        .input-container {
            position: relative;
            margin-bottom: 15px;
        }

        input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            font-size: 18px;
        }

        .error {
            color: red;
            font-size: 12px;
            display: none;
        }

        input[type=submit] {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            background-color: grey;
            color: white;
            margin-top: 10px;
        }


        input[type=submit] {
            background-color: rgb(124, 76, 255);
        }

        input[type=submit]:hover {
            background-color: purple;
        }
    </style>
</head>

<body>
    <div class="container">
        <h2>Új jelszó megadása</h2>
        <p><b>' . htmlspecialchars($userEmail) . '</b> címre</p>
        <form action="" method="POST">
            <div class="input-container">
                <input type="password" id="password" placeholder="Új jelszó" required>
                <span class="toggle-password" id="visible1" onclick="togglePassword()">◉</span>
            </div>
            <p class="error" id="passwordError">A jelszónak 8-20 karakter hosszúnak kell lennie, tartalmaznia kell legalább 1 kisbetűt, 1 nagybetűt és 1 számot!</p>

            <div class="input-container">
                <input type="password" id="confirmPassword" placeholder="Új jelszó megerősítése" required>
                <span class="toggle-password" id="visible2" onclick="togglePassword()">◉</span>
            </div>
            <p class="error" id="confirmPasswordError">A jelszavak nem egyeznek!</p>

            <input type="submit" id="resetButton" value="Jelszó helyreállítása">
        </form>
    </div>

    <script>
        function togglePassword() {
            let passwordField = document.getElementById("password");
            let confirmPasswordField = document.getElementById("confirmPassword");
            let icon1 = document.getElementById("visible1");
            let icon2 = document.getElementById("visible2");

        if (passwordField.type === "password") {
                passwordField.type = "text";
                confirmPasswordField.type = "text";
                icon1.textContent = "◎";
                icon2.textContent = "◎";
            } else {
                passwordField.type = "password";
                confirmPasswordField.type = "password";
                icon1.textContent = "◉";
                icon2.textContent = "◉";
            }
        }

        function validatePassword() {
            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const passwordError = document.getElementById("passwordError");
            const confirmPasswordError = document.getElementById("confirmPasswordError");
            const resetButton = document.getElementById("resetButton");

            const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,20}$/;

            let isValid = true;

            if (!passwordRegex.test(password)) {
                passwordError.style.display = "block";
                isValid = false;
            } else {
                passwordError.style.display = "none";
            }

            if (password !== confirmPassword || confirmPassword === "") {
                confirmPasswordError.style.display = "block";
                isValid = false;
            } else {
                confirmPasswordError.style.display = "none";
            }

            if (isValid) {
                resetButton.classList.add("active");
                resetButton.removeAttribute("disabled");
            } else {
                resetButton.classList.remove("active");
                resetButton.setAttribute("disabled", "true");
            }
        }

        document.getElementById("password").addEventListener("input", validatePassword);
        document.getElementById("confirmPassword").addEventListener("input", validatePassword);

        document.getElementById("resetButton").addEventListener("click", function(event) {
            event.preventDefault(); // Megakadályozza az oldal újratöltését

            const password = document.getElementById("password").value;
            const confirmPassword = document.getElementById("confirmPassword").value;
            const token = ' . json_encode($token) . ';

            if (password !== confirmPassword) {
                alert("A jelszavak nem egyeznek!");
                return;
            }

            fetch(window.location.href, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: new URLSearchParams({
                        "token": token,
                        "new_password": password
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert("Sikeres jelszóváltoztatás! Az oldal most bezáródik.");
                        window.close(); // Bezárja az oldalt
                    } else {
                        alert("Hiba történt: " + data.message);
                    }
                })
                .catch(error => {
                    console.error("Hálózati hiba:", error);
                });
        });
    </script>
</body>

</html>';

//majd végezetül lezárjuk a kapcsolatot!
$stmt->close();
$conn->close();
