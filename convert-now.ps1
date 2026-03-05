Set-Location "e:\cangku\ruanjian\SuperChat"

Write-Host "正在转换 P12 证书..."
$p12Bytes = [IO.File]::ReadAllBytes("6OCIV5_证书文件（密码 1）.p12")
Write-Host "P12 文件大小：$($p12Bytes.Length) bytes"
$p12Base64 = [Convert]::ToBase64String($p12Bytes)
$p12Base64 | Out-File -FilePath "ios_p12_base64.txt" -Encoding ascii -NoNewline
Write-Host "✓ P12 证书转换完成"

Write-Host ""
Write-Host "正在转换 Provisioning Profile..."
$provBytes = [IO.File]::ReadAllBytes("6OCIV5_描述文件.mobileprovision")
Write-Host "Provisioning Profile 大小：$($provBytes.Length) bytes"
$provBase64 = [Convert]::ToBase64String($provBytes)
$provBase64 | Out-File -FilePath "ios_mobileprovision_base64.txt" -Encoding ascii -NoNewline
Write-Host "✓ Provisioning Profile 转换完成"

Write-Host ""
Write-Host "===================================="
Write-Host "  转换完成！"
Write-Host "===================================="
Write-Host ""
Write-Host "生成的文件："
Write-Host "  - ios_p12_base64.txt"
Write-Host "  - ios_mobileprovision_base64.txt"
Write-Host ""
Write-Host "请打开这两个文件复制内容，然后添加到 GitHub Secrets"
