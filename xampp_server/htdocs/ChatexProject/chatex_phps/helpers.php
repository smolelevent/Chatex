<?php

use JetBrains\PhpStorm\NoReturn;

/**
 * Sends a JSON response with a specified HTTP status code and exits the script.
 *
 * @param array $data The data to be JSON encoded.
 * @param int $statusCode The HTTP status code to send.
 */
#[NoReturn]
function send_json_response(array $data, int $statusCode = 200): void
{
    http_response_code($statusCode);
    echo json_encode($data);
    exit();
}