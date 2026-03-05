Set-Location "e:\cangku\ruanjian\SuperChat"

$p12Path = "C:\Users\haiwu\Desktop\6OCIV5_证书文件（密码 1）.p12"
$provPath = "C:\Users\haiwu\Desktop\6OCIV5_描述文件.mobileprovision"

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  iOS 证书转换" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# 转换 P12
Write-Host "[1/2] 转换 P12 证书..." -ForegroundColor Yellow
if (Test-Path $p12Path) {
    $p12Bytes = [IO.File]::ReadAllBytes($p12Path)
    Write-Host "  文件大小：$($p12Bytes.Length) bytes" -ForegroundColor Green
    $p12Base64 = [Convert]::ToBase64String($p12Bytes)
    $p12Base64 | Out-File -FilePath "ios_p12_base64.txt" -Encoding ascii -NoNewline
    Write-Host "  ✓ 转换成功" -ForegroundColor Green
} else {
    Write-Host "  × 文件不存在：$p12Path" -ForegroundColor Red
}

Write-Host ""

# 转换 Provisioning Profile
Write-Host "[2/2] 转换 Provisioning Profile..." -ForegroundColor Yellow
if (Test-Path $provPath) {
    $provBytes = [IO.File]::ReadAllBytes($provPath)
    Write-Host "  文件大小：$($provBytes.Length) bytes" -ForegroundColor Green
    $provBase64 = [Convert]::ToBase64String($provBytes)
    $provBase64 | Out-File -FilePath "ios_mobileprovision_base64.txt" -Encoding ascii -NoNewline
    Write-Host "  ✓ 转换成功" -ForegroundColor Green
} else {
    Write-Host "  × 文件不存在：$provPath" -ForegroundColor Red
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  转换完成！" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "生成的文件：" -ForegroundColor White
Write-Host "  - ios_p12_base64.txt" -ForegroundColor Cyan
Write-Host "  - ios_mobileprovision_base64.txt" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "1. 打开 ios_p12_base64.txt，复制全部内容" -ForegroundColor White
Write-Host "2. 打开 ios_mobileprovision_base64.txt，复制全部内容" -ForegroundColor White
Write-Host "3. 访问 https://github.com/ashun520/CHAT/settings/secrets/actions" -ForegroundColor White
Write-Host "4. 添加 3 个 Secrets（详见 github_secrets_guide.txt）" -ForegroundColor White
Write-Host ""
