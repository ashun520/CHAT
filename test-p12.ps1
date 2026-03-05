Write-Host "Testing P12 certificate..." -ForegroundColor Cyan

$p12Path = "e:\cangku\ruanjian\SuperChat\6OCIV5_证书文件（密码 1）.p12"
$password = "1"

try {
    # 尝试用 OpenSSL 测试（如果已安装）
    $testCmd = "openssl pkcs12 -in `"$p12Path`" -passin pass:`"$password`" -nokeys -out nul 2>&1"
    Write-Host "Testing with OpenSSL..." -ForegroundColor Yellow
    $result = Invoke-Expression $testCmd
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ P12 certificate is valid!" -ForegroundColor Green
    } else {
        Write-Host "× P12 certificate test failed" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
        Write-Host ""
        Write-Host "Possible issues:" -ForegroundColor Yellow
        Write-Host "1. Wrong password (try the full password from filename)" -ForegroundColor White
        Write-Host "2. Certificate expired" -ForegroundColor White
        Write-Host "3. Corrupted file" -ForegroundColor White
    }
} catch {
    Write-Host "OpenSSL not available or test failed" -ForegroundColor Yellow
}
