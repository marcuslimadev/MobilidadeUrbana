<?php

// Simple router for PHP built-in server so static files under this
// directory (e.g. /assets) are served directly without hitting Laravel.

$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?? '/');

// Resolve requested path relative to this directory while preventing traversal.
$path = realpath(__DIR__ . $uri);
$docRoot = realpath(__DIR__);

if ($path && str_starts_with($path, $docRoot) && is_file($path)) {
    return false; // Let PHP's dev server serve the file directly.
}

require __DIR__ . '/index.php';