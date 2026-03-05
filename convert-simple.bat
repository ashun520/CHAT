@echo off
chcp 65001 >nul
echo ====================================
echo   iOS 证书转换工具
echo ====================================
echo.
echo 请将桌面上的两个证书文件复制到此文件夹：
echo   e:\cangku\ruanjian\SuperChat\
echo.
echo 文件名称：
echo   - 6OCIV5_证书文件（密码 1）.p12
echo   - 6OCIV5_描述文件.mobileprovision
echo.
echo 复制完成后，按任意键继续...
pause >nul
echo.
echo 正在查找文件...
if exist "6OCIV5_证书文件（密码 1）.p12" (
    echo   ✓ 找到 P12 证书文件
) else (
    echo   × 未找到 P12 证书文件
    pause
    exit /b 1
)

if exist "6OCIV5_描述文件.mobileprovision" (
    echo   ✓ 找到 Provisioning Profile 文件
) else (
    echo   × 未找到 Provisioning Profile 文件
    pause
    exit /b 1
)

echo.
echo 正在转换...
powershell -Command "$p12Bytes = [IO.File]::ReadAllBytes('6OCIV5_证书文件（密码 1）.p12'); $p12Base64 = [Convert]::ToBase64String($p12Bytes); $p12Base64 | Out-File -FilePath 'ios_p12_base64.txt' -Encoding ascii -NoNewline"
echo   ✓ P12 证书已转换

powershell -Command "$provBytes = [IO.File]::ReadAllBytes('6OCIV5_描述文件.mobileprovision'); $provBase64 = [Convert]::ToBase64String($provBytes); $provBase64 | Out-File -FilePath 'ios_mobileprovision_base64.txt' -Encoding ascii -NoNewline"
echo   ✓ Provisioning Profile 已转换

echo.
echo ====================================
echo   转换完成！
echo ====================================
echo.
echo 生成的文件：
echo   - ios_p12_base64.txt
echo   - ios_mobileprovision_base64.txt
echo.
echo 请打开这两个文件复制内容，然后查看：
echo   github_secrets_guide.txt
echo.
pause
