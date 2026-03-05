# GitHub Secrets 自动配置脚本
# 使用前请确保已经登录 GitHub CLI

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  GitHub Secrets 自动配置工具" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# 检查 GitHub CLI 是否安装
Write-Host "[1/5] 检查 GitHub CLI..." -ForegroundColor Yellow
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "  错误：未找到 GitHub CLI" -ForegroundColor Red
    Write-Host "  请安装：https://cli.github.com/" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✓ GitHub CLI 已安装" -ForegroundColor Green
Write-Host ""

# 检查登录状态
Write-Host "[2/5] 检查 GitHub 登录状态..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  未登录或登录已过期" -ForegroundColor Yellow
    Write-Host "  正在启动登录流程..." -ForegroundColor Yellow
    Write-Host ""
    gh auth login -h github.com -w
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  错误：登录失败" -ForegroundColor Red
        exit 1
    }
    Write-Host "  ✓ 登录成功" -ForegroundColor Green
} else {
    Write-Host "  ✓ 已登录" -ForegroundColor Green
}
Write-Host ""

# 读取证书文件
Write-Host "[3/5] 读取证书文件..." -ForegroundColor Yellow
Set-Location "e:\cangku\ruanjian\SuperChat"

if (-not (Test-Path "ios_p12_base64.txt")) {
    Write-Host "  错误：未找到 ios_p12_base64.txt" -ForegroundColor Red
    exit 1
}
$p12Base64 = Get-Content "ios_p12_base64.txt" -Raw
Write-Host "  ✓ P12 证书已读取 ($($p12Base64.Length) 字符)" -ForegroundColor Green

if (-not (Test-Path "ios_mobileprovision_base64.txt")) {
    Write-Host "  错误：未找到 ios_mobileprovision_base64.txt" -ForegroundColor Red
    exit 1
}
$provBase64 = Get-Content "ios_mobileprovision_base64.txt" -Raw
Write-Host "  ✓ Provisioning Profile 已读取 ($($provBase64.Length) 字符)" -ForegroundColor Green
Write-Host ""

# 添加 Secrets
Write-Host "[4/5] 添加 GitHub Secrets..." -ForegroundColor Yellow

Write-Host "  添加 IOS_P12_BASE64..." -ForegroundColor Cyan
$p12Base64 | gh secret set IOS_P12_BASE64 -R ashun520/CHAT
if ($LASTEXITCODE -eq 0) {
    Write-Host "    ✓ 成功" -ForegroundColor Green
} else {
    Write-Host "    × 失败" -ForegroundColor Red
}

Write-Host "  添加 IOS_P12_PASSWORD..." -ForegroundColor Cyan
echo "1" | gh secret set IOS_P12_PASSWORD -R ashun520/CHAT
if ($LASTEXITCODE -eq 0) {
    Write-Host "    ✓ 成功" -ForegroundColor Green
} else {
    Write-Host "    × 失败" -ForegroundColor Red
}

Write-Host "  添加 IOS_MOBILE_PROVISION_BASE64..." -ForegroundColor Cyan
$provBase64 | gh secret set IOS_MOBILE_PROVISION_BASE64 -R ashun520/CHAT
if ($LASTEXITCODE -eq 0) {
    Write-Host "    ✓ 成功" -ForegroundColor Green
} else {
    Write-Host "    × 失败" -ForegroundColor Red
}

Write-Host ""

# 完成
Write-Host "[5/5] 完成！" -ForegroundColor Yellow
Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  所有 Secrets 已添加！" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步操作：" -ForegroundColor Yellow
Write-Host "1. 访问：https://github.com/ashun520/CHAT/actions" -ForegroundColor White
Write-Host "2. 点击 'Build iOS IPA'" -ForegroundColor White
Write-Host "3. 点击 'Run workflow'" -ForegroundColor White
Write-Host "4. 选择 'main' 分支并运行" -ForegroundColor White
Write-Host ""
Write-Host "构建成功后，IPA 文件将出现在：" -ForegroundColor White
Write-Host "https://github.com/ashun520/CHAT/releases" -ForegroundColor Cyan
Write-Host ""
