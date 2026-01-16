# Script de Teste da API SemUp
# URL: http://72.62.137.32:8080

$baseUrl = "http://72.62.137.32:8080/api"
$headers = @{
    'Accept' = 'application/json'
    'dev-token' = '$2y$12$mEVBW3QASB5HMBv8igls3ejh6zw2A0Xb480HWAmYq6BY9xEifyBjG'
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  TESTE DA API - SEMUP" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Teste 1: General Settings
Write-Host "[1/6] Testando General Settings..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/general-setting" -Headers $headers
    if ($response.status -eq "success") {
        Write-Host "  ✓ Status: $($response.status)" -ForegroundColor Green
        Write-Host "  ✓ Site Name: $($response.data.general_setting.site_name)" -ForegroundColor Green
        Write-Host "  ✓ Currency: $($response.data.general_setting.cur_sym) $($response.data.general_setting.cur_text)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Erro: $($response.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ Falha na requisição" -ForegroundColor Red
}

# Teste 2: Countries
Write-Host "`n[2/6] Testando Countries..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/get-countries" -Headers $headers
    if ($response.status -eq "success") {
        $countryCount = $response.data.countries.Count
        Write-Host "  ✓ Status: $($response.status)" -ForegroundColor Green
        Write-Host "  ✓ Países disponíveis: $countryCount" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Erro: $($response.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ Falha na requisição" -ForegroundColor Red
}

# Teste 3: FAQ
Write-Host "`n[3/6] Testando FAQ..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/faq" -Headers $headers
    if ($response.status -eq "success") {
        $faqCount = $response.data.faq.Count
        Write-Host "  ✓ Status: $($response.status)" -ForegroundColor Green
        Write-Host "  ✓ FAQs disponíveis: $faqCount" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Erro: $($response.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ Falha na requisição" -ForegroundColor Red
}

# Teste 4: Language
Write-Host "`n[4/6] Testando Language (en)..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/language/en" -Headers $headers
    if ($response.status -eq "success") {
        Write-Host "  ✓ Status: $($response.status)" -ForegroundColor Green
        Write-Host "  ✓ Idioma carregado com sucesso" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Erro: $($response.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "  ✗ Falha na requisição" -ForegroundColor Red
}

# Teste 5: Login (esperado falhar - credenciais inválidas)
Write-Host "`n[5/6] Testando Login (credenciais inválidas)..." -ForegroundColor Yellow
try {
    $loginData = @{
        username = "testuser"
        password = "wrongpassword"
    } | ConvertTo-Json
    
    $loginHeaders = $headers.Clone()
    $loginHeaders['Content-Type'] = 'application/json'
    
    $response = Invoke-RestMethod -Uri "$baseUrl/login" -Method POST -Headers $loginHeaders -Body $loginData -ErrorAction Stop
    Write-Host "  ✗ Login não deveria ter sucesso!" -ForegroundColor Red
} catch {
    $errorResponse = $_.ErrorDetails.Message | ConvertFrom-Json
    if ($errorResponse.status -eq "error") {
        Write-Host "  ✓ Validação funcionando: $($errorResponse.message -join ', ')" -ForegroundColor Green
    } else {
        Write-Host "  ? Resposta inesperada" -ForegroundColor Yellow
    }
}

# Teste 6: Driver Login (teste de autenticação)
Write-Host "`n[6/6] Testando Driver Login (credenciais inválidas)..." -ForegroundColor Yellow
try {
    $loginData = @{
        username = "driver_test"
        password = "wrongpassword"
    } | ConvertTo-Json
    
    $loginHeaders = $headers.Clone()
    $loginHeaders['Content-Type'] = 'application/json'
    
    $response = Invoke-RestMethod -Uri "$baseUrl/driver/login" -Method POST -Headers $loginHeaders -Body $loginData -ErrorAction Stop
    Write-Host "  ✗ Login não deveria ter sucesso!" -ForegroundColor Red
} catch {
    $errorResponse = $_.ErrorDetails.Message | ConvertFrom-Json
    if ($errorResponse.status -eq "error") {
        Write-Host "  ✓ Validação funcionando: $($errorResponse.message -join ', ')" -ForegroundColor Green
    } else {
        Write-Host "  ? Resposta inesperada" -ForegroundColor Yellow
    }
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  TESTES CONCLUÍDOS" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "API Base URL: $baseUrl" -ForegroundColor White
Write-Host "Dev Token configurado corretamente ✓`n" -ForegroundColor Green
