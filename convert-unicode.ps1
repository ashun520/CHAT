Set-Location "e:\cangku\ruanjian\SuperChat"

# Find P12 file
$p12File = Get-ChildItem -Filter "*.p12" | Select-Object -First 1
if ($p12File) {
    Write-Host "Found P12: $($p12File.Name)"
    $p12Bytes = [IO.File]::ReadAllBytes($p12File.FullName)
    Write-Host "Size: $($p12Bytes.Length) bytes"
    $p12Base64 = [Convert]::ToBase64String($p12Bytes)
    $p12Base64 | Out-File -FilePath "ios_p12_base64.txt" -Encoding ascii -NoNewline
    Write-Host "SUCCESS: P12 converted"
} else {
    Write-Host "ERROR: P12 file not found"
}

Write-Host ""

# Find mobileprovision file
$provFile = Get-ChildItem -Filter "*.mobileprovision" | Select-Object -First 1
if ($provFile) {
    Write-Host "Found Provision: $($provFile.Name)"
    $provBytes = [IO.File]::ReadAllBytes($provFile.FullName)
    Write-Host "Size: $($provBytes.Length) bytes"
    $provBase64 = [Convert]::ToBase64String($provBytes)
    $provBase64 | Out-File -FilePath "ios_mobileprovision_base64.txt" -Encoding ascii -NoNewline
    Write-Host "SUCCESS: Provision converted"
} else {
    Write-Host "ERROR: Provision file not found"
}

Write-Host ""
Write-Host "DONE! Check files:"
Write-Host "  - ios_p12_base64.txt"
Write-Host "  - ios_mobileprovision_base64.txt"
