Write-Host "正在处理桌面上的证书文件..." -ForegroundColor Cyan

# 查找桌面上的证书文件
$p12Files = Get-ChildItem -Path "$env:USERPROFILE\Desktop" -Filter "*.p12" -ErrorAction SilentlyContinue
$provFiles = Get-ChildItem -Path "$env:USERPROFILE\Desktop" -Filter "*.mobileprovision" -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "找到的 P12 文件:" -ForegroundColor Yellow
if ($p12Files.Count -eq 0) {
    Write-Host "  未找到 P12 文件，请将证书文件放到桌面" -ForegroundColor Red
} else {
    foreach ($file in $p12Files) {
        Write-Host "  ✓ $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "找到的 Provisioning Profile 文件:" -ForegroundColor Yellow
if ($provFiles.Count -eq 0) {
    Write-Host "  未找到 Provisioning Profile 文件，请将配置文件放到桌面" -ForegroundColor Red
} else {
    foreach ($file in $provFiles) {
        Write-Host "  ✓ $($file.Name)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "请运行以下命令（根据实际文件名修改）:" -ForegroundColor Yellow
Write-Host ""
Write-Host ".\setup-cert.ps1 -P12Path `"$env:USERPROFILE\Desktop\6OCIV5_证书文件（密码 1）.p12`" -Password `"1`" -MobileProvisionPath `"$env:USERPROFILE\Desktop\6OCIV5_描述文件.mobileprovision`"" -ForegroundColor Cyan
Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
