# iOS 证书自动配置脚本
# 使用方法：.\setup-cert.ps1 -P12Path "证书路径.p12" -Password "证书密码" -MobileProvisionPath "配置文件.mobileprovision"

param(
    [Parameter(Mandatory=$true)]
    [string]$P12Path,
    
    [Parameter(Mandatory=$true)]
    [string]$Password,
    
    [Parameter(Mandatory=$true)]
    [string]$MobileProvisionPath
)

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  iOS 证书自动配置工具" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# 验证文件是否存在
Write-Host "[1/4] 验证文件..." -ForegroundColor Yellow

if (-not (Test-Path $P12Path)) {
    Write-Host "错误：P12 证书文件不存在：$P12Path" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $MobileProvisionPath)) {
    Write-Host "错误：Provisioning Profile 文件不存在：$MobileProvisionPath" -ForegroundColor Red
    exit 1
}

Write-Host "  ✓ P12 证书文件存在" -ForegroundColor Green
Write-Host "  ✓ Provisioning Profile 文件存在" -ForegroundColor Green
Write-Host ""

# 转换 P12 证书为 Base64
Write-Host "[2/4] 转换 P12 证书..." -ForegroundColor Yellow
try {
    $p12Bytes = [IO.File]::ReadAllBytes($P12Path)
    $p12Base64 = [Convert]::ToBase64String($p12Bytes)
    $p12Base64 | Out-File -FilePath "ios_p12_base64.txt" -Encoding ascii -NoNewline
    Write-Host "  ✓ P12 证书已转换并保存到 ios_p12_base64.txt" -ForegroundColor Green
} catch {
    Write-Host "  错误：转换 P12 证书失败" -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 转换 Provisioning Profile 为 Base64
Write-Host "[3/4] 转换 Provisioning Profile..." -ForegroundColor Yellow
try {
    $provBytes = [IO.File]::ReadAllBytes($MobileProvisionPath)
    $provBase64 = [Convert]::ToBase64String($provBytes)
    $provBase64 | Out-File -FilePath "ios_mobileprovision_base64.txt" -Encoding ascii -NoNewline
    Write-Host "  ✓ Provisioning Profile 已转换并保存到 ios_mobileprovision_base64.txt" -ForegroundColor Green
} catch {
    Write-Host "  错误：转换 Provisioning Profile 失败" -ForegroundColor Red
    Write-Host "  $_" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 解析 Provisioning Profile 信息
Write-Host "[4/4] 解析配置文件信息..." -ForegroundColor Yellow
try {
    $provContent = [System.Text.Encoding]::UTF8.GetString($provBytes)
    
    # 尝试读取 UUID
    if ($provContent -match 'UUID\s*=\s*([A-F0-9-]+)') {
        $uuid = $matches[1]
        Write-Host "  ✓ Profile UUID: $uuid" -ForegroundColor Green
    }
    
    # 尝试读取 Name
    if ($provContent -match 'Name\s*=\s*"([^"]+)"') {
        $name = $matches[1]
        Write-Host "  ✓ Profile Name: $name" -ForegroundColor Green
    }
    
    # 尝试读取 TeamIdentifier
    if ($provContent -match 'TeamIdentifier\s*=\s*"([^"]+)"') {
        $teamId = $matches[1]
        Write-Host "  ✓ Team ID: $teamId" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠ 无法解析配置文件信息（不影响使用）" -ForegroundColor Yellow
}
Write-Host ""

# 显示下一步操作指南
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  下一步操作" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "请按照以下步骤添加 GitHub Secrets：" -ForegroundColor White
Write-Host ""
Write-Host "1. 访问 GitHub Secrets 页面：" -ForegroundColor Yellow
Write-Host "   https://github.com/ashun520/CHAT/settings/secrets/actions" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. 添加以下 3 个 Secrets：" -ForegroundColor Yellow
Write-Host ""
Write-Host "   Secret 名称：" -ForegroundColor White
Write-Host "   IOS_P12_BASE64" -ForegroundColor Cyan
Write-Host "   Secret 值：" -ForegroundColor White
Write-Host "   复制 'ios_p12_base64.txt' 文件的全部内容" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Secret 名称：" -ForegroundColor White
Write-Host "   IOS_P12_PASSWORD" -ForegroundColor Cyan
Write-Host "   Secret 值：" -ForegroundColor White
Write-Host "   $Password" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Secret 名称：" -ForegroundColor White
Write-Host "   IOS_MOBILE_PROVISION_BASE64" -ForegroundColor Cyan
Write-Host "   Secret 值：" -ForegroundColor White
Write-Host "   复制 'ios_mobileprovision_base64.txt' 文件的全部内容" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. 添加完成后，GitHub Actions 会自动签名并打包 IPA" -ForegroundColor Yellow
Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  配置完成！" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
