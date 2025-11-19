<?php

// Testar inicialização do Laravel
require __DIR__ . '/../vendor/autoload.php';

$app = require_once __DIR__ . '/../bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

$response = $kernel->handle(
    $request = Illuminate\Http\Request::create('/', 'GET')
);

echo "Status: " . $response->getStatusCode() . PHP_EOL;
echo "Content: " . PHP_EOL;
echo $response->getContent();

$kernel->terminate($request, $response);
