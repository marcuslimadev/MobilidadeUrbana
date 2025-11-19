<?php

/**
 * Script temporário para resetar senha do admin
 * Executar via: php reset-admin-password.php
 * DELETAR após uso por segurança
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

try {
    // Buscar admin pelo username
    $admin = \App\Models\Admin::where('username', 'admin')->first();
    
    if (!$admin) {
        echo "❌ Admin não encontrado!\n";
        exit(1);
    }
    
    echo "📋 Admin encontrado:\n";
    echo "   ID: {$admin->id}\n";
    echo "   Username: {$admin->username}\n";
    echo "   Email: {$admin->email}\n";
    echo "\n";
    
    // Resetar senha
    $admin->password = bcrypt('12345678');
    $admin->save();
    
    echo "✅ Senha resetada com sucesso!\n";
    echo "\n";
    echo "🔑 Credenciais de acesso:\n";
    echo "   URL: " . env('APP_URL') . "/admin\n";
    echo "   Username: admin\n";
    echo "   Senha: 12345678\n";
    echo "\n";
    echo "⚠️  IMPORTANTE: Altere esta senha após o primeiro login!\n";
    echo "⚠️  DELETE este arquivo após uso: rm reset-admin-password.php\n";
    
} catch (\Exception $e) {
    echo "❌ Erro ao resetar senha: " . $e->getMessage() . "\n";
    exit(1);
}
