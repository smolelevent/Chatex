<?php
//ezt a php-t kell futtatni az XAMPP szerver MELLETT hogy működjön a chat!!!!
require __DIR__ . '/vendor/autoload.php';
require __DIR__ . '/websocket_server.php';

use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;

$server = IoServer::factory(
    new HttpServer(
        new WsServer(
            new ChatServer()
        )
    ),
    8080
);

echo "WebSocket szerver fut a 8080-as porton\n";
$server->run();
