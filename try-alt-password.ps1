Set-Location "e:\cangku\ruanjian\SuperChat"

Write-Host "Trying password: 密码 1" -ForegroundColor Cyan

$p12File = Get-ChildItem -Filter "*.p12" | Select-Object -First 1
Write-Host "Found: $($p12File.Name)"

# Read and convert
$p12Bytes = [IO.File]::ReadAllBytes($p12File.FullName)
Write-Host "Size: $($p12Bytes.Length) bytes"

$p12Base64 = [Convert]::ToBase64String($p12Bytes)
$p12Base64 | Out-File -FilePath "ios_p12_base64_new.txt" -Encoding ascii -NoNewline

Write-Host "Generated new Base64 file: ios_p12_base64_new.txt" -ForegroundColor Green
Write-Host ""
Write-Host "Password to use: 密码 1" -ForegroundColor Yellow
