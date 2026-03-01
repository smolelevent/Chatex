<?php
//ezt a php-t kell futtatni az XAMPP szerver MELLETT hogy működjön a chat!!!!
require __DIR__ . '/vendor/autoload.php';
require __DIR__ . '/db.php'; // Fontos: db.php behúzása az adatbázis eléréshez
require __DIR__ . '/websocket_server.php';

use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;
use React\Socket\SocketServer;

// Ellenőrizzük, hogy CLI-ből fut-e (böngészőből ne lehessen véletlenül elindítani)
if (php_sapi_name() !== 'cli') {
    die("Ezt a scriptet csak parancssorból (CLI) lehet futtatni!");
}

// Modern példányosítás (IoServer::factory helyett)
// Ez nagyobb kontrollt ad a Loop felett (pl. később időzítők hozzáadása)
$loop = React\EventLoop\Loop::get();

// Létrehozzuk a socket szervert a 8080-as porton
$socket = new SocketServer('0.0.0.0:8080', [], $loop);

$server = new IoServer(
    new HttpServer(
        new WsServer(
            new ChatServer()
        )
    ),
    $socket,
    $loop
);

echo "WebSocket szerver fut a 8080-as porton...\n";
$server->run();
