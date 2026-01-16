# Script para atualizar Google Maps API no VPS
# Execute: .\update-maps-vps.ps1

$VPS_IP = "72.62.137.32"
$VPS_USER = "root"
$VPS_PASSWORD = "MundoMelhor@10"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ATUALIZAR GOOGLE MAPS API NO VPS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/4] Testando conexão com VPS..." -ForegroundColor Yellow
$connectionTest = Test-Connection -ComputerName $VPS_IP -Count 1 -Quiet

if (-not $connectionTest) {
    Write-Host "  ✗ VPS não está acessível. Verifique a conexão." -ForegroundColor Red
    exit 1
}
Write-Host "  ✓ VPS acessível" -ForegroundColor Green

Write-Host ""
Write-Host "[2/4] Atualizando Google Maps API no banco de dados..." -ForegroundColor Yellow

$command = @"
cd /var/www/semup/Files/Laravel/core && php artisan tinker --execute="
\`$gs = \App\Models\GeneralSetting::first();
\`$gs->google_maps_api = 'AIzaSyBAuSnmKcSGEcEOEVlzWIJnYUbYlmTL8Hs';
\`$gs->save();
echo 'Google Maps API atualizada!';
" && echo "DB_UPDATE_SUCCESS"
"@

try {
    $result = plink -batch -ssh $VPS_USER@$VPS_IP -pw $VPS_PASSWORD $command
    if ($result -match "DB_UPDATE_SUCCESS") {
        Write-Host "  ✓ Google Maps API atualizada no banco" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Possível erro na atualização do banco" -ForegroundColor Yellow
        Write-Host $result
    }
} catch {
    Write-Host "  ✗ Erro ao atualizar banco: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "[3/4] Verificando configuração atual..." -ForegroundColor Yellow

$verifyCommand = @"
cd /var/www/semup/Files/Laravel/core && php artisan tinker --execute="
\`$gs = \App\Models\GeneralSetting::first();
echo 'Google Maps API: ' . \`$gs->google_maps_api;
"
"@

try {
    $apiKey = plink -batch -ssh $VPS_USER@$VPS_IP -pw $VPS_PASSWORD $verifyCommand
    Write-Host "  $apiKey" -ForegroundColor Cyan
} catch {
    Write-Host "  ✗ Erro ao verificar: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "[4/4] Limpando caches..." -ForegroundColor Yellow

$cacheCommand = @"
cd /var/www/semup/Files/Laravel/core && php artisan config:clear && php artisan cache:clear && echo "CACHE_CLEARED"
"@

try {
    $cacheResult = plink -batch -ssh $VPS_USER@$VPS_IP -pw $VPS_PASSWORD $cacheCommand
    if ($cacheResult -match "CACHE_CLEARED") {
        Write-Host "  ✓ Caches limpos com sucesso" -ForegroundColor Green
    }
} catch {
    Write-Host "  ✗ Erro ao limpar cache: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ATUALIZAÇÃO CONCLUÍDA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Google Maps API configurada:" -ForegroundColor White
Write-Host "  AIzaSyBAuSnmKcSGEcEOEVlzWIJnYUbYlmTL8Hs" -ForegroundColor Yellow
Write-Host ""
Write-Host "Próximos passos:" -ForegroundColor White
Write-Host "  1. Rebuild dos apps Flutter (Rider e Driver)" -ForegroundColor Gray
Write-Host "  2. Testar mapas nos apps Android" -ForegroundColor Gray
Write-Host "  3. Verificar APIs habilitadas no Google Cloud Console" -ForegroundColor Gray
Write-Host ""
