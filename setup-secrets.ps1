Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  GitHub Secrets Setup" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/4] Checking GitHub CLI..." -ForegroundColor Yellow
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "  Error: GitHub CLI not found" -ForegroundColor Red
    Write-Host "  Install: https://cli.github.com/" -ForegroundColor Yellow
    exit 1
}
Write-Host "  OK" -ForegroundColor Green
Write-Host ""

Write-Host "[2/4] Checking login status..." -ForegroundColor Yellow
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  Not logged in. Starting login..." -ForegroundColor Yellow
    gh auth login -h github.com -w
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Error: Login failed" -ForegroundColor Red
        exit 1
    }
    Write-Host "  OK - Logged in" -ForegroundColor Green
} else {
    Write-Host "  OK - Already logged in" -ForegroundColor Green
}
Write-Host ""

Write-Host "[3/4] Reading certificate files..." -ForegroundColor Yellow
Set-Location "e:\cangku\ruanjian\SuperChat"

if (-not (Test-Path "ios_p12_base64.txt")) {
    Write-Host "  Error: ios_p12_base64.txt not found" -ForegroundColor Red
    exit 1
}
$p12Base64 = Get-Content "ios_p12_base64.txt" -Raw
Write-Host "  P12 certificate loaded" -ForegroundColor Green

if (-not (Test-Path "ios_mobileprovision_base64.txt")) {
    Write-Host "  Error: ios_mobileprovision_base64.txt not found" -ForegroundColor Red
    exit 1
}
$provBase64 = Get-Content "ios_mobileprovision_base64.txt" -Raw
Write-Host "  Provisioning Profile loaded" -ForegroundColor Green
Write-Host ""

Write-Host "[4/4] Adding GitHub Secrets..." -ForegroundColor Yellow

Write-Host "  Adding IOS_P12_BASE64..." -ForegroundColor Cyan
$p12Base64 | gh secret set IOS_P12_BASE64 -R ashun520/CHAT
if ($LASTEXITCODE -eq 0) { Write-Host "    SUCCESS" -ForegroundColor Green } else { Write-Host "    FAILED" -ForegroundColor Red }

Write-Host "  Adding IOS_P12_PASSWORD..." -ForegroundColor Cyan
echo "1" | gh secret set IOS_P12_PASSWORD -R ashun520/CHAT
if ($LASTEXITCODE -eq 0) { Write-Host "    SUCCESS" -ForegroundColor Green } else { Write-Host "    FAILED" -ForegroundColor Red }

Write-Host "  Adding IOS_MOBILE_PROVISION_BASE64..." -ForegroundColor Cyan
$provBase64 | gh secret set IOS_MOBILE_PROVISION_BASE64 -R ashun520/CHAT
if ($LASTEXITCODE -eq 0) { Write-Host "    SUCCESS" -ForegroundColor Green } else { Write-Host "    FAILED" -ForegroundColor Red }

Write-Host ""
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  All Secrets Added!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Visit: https://github.com/ashun520/CHAT/actions" -ForegroundColor White
Write-Host "2. Click 'Build iOS IPA'" -ForegroundColor White
Write-Host "3. Click 'Run workflow'" -ForegroundColor White
Write-Host "4. Select 'main' and run" -ForegroundColor White
Write-Host ""
