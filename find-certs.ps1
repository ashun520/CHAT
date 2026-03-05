$files = Get-ChildItem -Path "$env:USERPROFILE\Desktop" -Include "*.p12","*.mobileprovision" -Recurse
foreach ($file in $files) {
    Write-Host $file.FullName
}
