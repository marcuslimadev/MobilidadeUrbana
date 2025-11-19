<?php

/**
 * Script para adicionar configurações de locale PT-BR no .env
 * Executar via: php fix-locale-env.php
 */

$envFile = __DIR__ . '/.env';

if (!file_exists($envFile)) {
    echo "❌ Arquivo .env não encontrado!\n";
    exit(1);
}

$envContent = file_get_contents($envFile);

// Verificar se já tem as configurações
if (strpos($envContent, 'APP_LOCALE') !== false) {
    echo "✅ APP_LOCALE já existe no .env\n";
} else {
    echo "📝 Adicionando APP_LOCALE ao .env...\n";
}

// Configurações a adicionar/atualizar
$localeSettings = [
    'APP_LOCALE' => 'pt_BR',
    'APP_FALLBACK_LOCALE' => 'pt_BR',
    'APP_FAKER_LOCALE' => 'pt_BR',
];

$lines = explode("\n", $envContent);
$updated = false;

foreach ($localeSettings as $key => $value) {
    $found = false;
    
    foreach ($lines as $index => $line) {
        // Se a linha começa com a chave
        if (strpos(trim($line), $key . '=') === 0) {
            $oldValue = trim($line);
            $newValue = $key . '=' . $value;
            
            if ($oldValue !== $newValue) {
                $lines[$index] = $newValue;
                echo "   🔄 Atualizado: {$key}={$value}\n";
                $updated = true;
            } else {
                echo "   ✓ {$key} já está correto\n";
            }
            
            $found = true;
            break;
        }
    }
    
    // Se não encontrou, adicionar após APP_FAKER_LOCALE ou APP_URL
    if (!$found) {
        $insertAfter = -1;
        
        foreach ($lines as $index => $line) {
            if (strpos(trim($line), 'APP_URL=') === 0 || 
                strpos(trim($line), 'APP_FAKER_LOCALE=') === 0) {
                $insertAfter = $index;
            }
        }
        
        if ($insertAfter >= 0) {
            array_splice($lines, $insertAfter + 1, 0, [$key . '=' . $value]);
            echo "   ✅ Adicionado: {$key}={$value}\n";
            $updated = true;
        }
    }
}

if ($updated) {
    // Salvar arquivo
    $newContent = implode("\n", $lines);
    file_put_contents($envFile, $newContent);
    echo "\n✅ Arquivo .env atualizado com sucesso!\n";
    echo "\n⚠️  Execute no terminal:\n";
    echo "   /opt/cpanel/ea-php82/root/usr/bin/php artisan config:clear\n";
    echo "   /opt/cpanel/ea-php82/root/usr/bin/php artisan cache:clear\n";
} else {
    echo "\n✅ Todas as configurações já estão corretas!\n";
    echo "\n💡 Se o site ainda não está em PT-BR, verifique:\n";
    echo "   1. Banco de dados: SELECT * FROM languages WHERE is_default=1;\n";
    echo "   2. Limpar cache: php artisan config:clear && php artisan cache:clear\n";
}

echo "\n";
