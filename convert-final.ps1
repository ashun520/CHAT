Set-Location "e:\cangku\ruanjian\SuperChat"

Write-Host "Converting P12 certificate..."
$p12Bytes = [IO.File]::ReadAllBytes("6OCIV5_证书文件（密码 1）.p12")
Write-Host "P12 size: $($p12Bytes.Length) bytes"
$p12Base64 = [Convert]::ToBase64String($p12Bytes)
$p12Base64 | Out-File -FilePath "ios_p12_base64.txt" -Encoding ascii -NoNewline
Write-Host "DONE: P12 converted"

Write-Host ""
Write-Host "Converting Provisioning Profile..."
$provBytes = [IO.File]::ReadAllBytes("6OCIV5_描述文件.mobileprovision")
Write-Host "Provision size: $($provBytes.Length) bytes"
$provBase64 = [Convert]::ToBase64String($provBytes)
$provBase64 | Out-File -FilePath "ios_mobileprovision_base64.txt" -Encoding ascii -NoNewline
Write-Host "DONE: Provision converted"

Write-Host ""
Write-Host "SUCCESS! Files created:"
Write-Host "  - ios_p12_base64.txt"
Write-Host "  - ios_mobileprovision_base64.txt"
