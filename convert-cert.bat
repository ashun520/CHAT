@echo off
chcp 65001 >nul
echo ====================================
echo   iOS 证书转换工具
echo ====================================
echo.

echo [1/3] 转换 P12 证书...
powershell -Command "$p12Bytes = [IO.File]::ReadAllBytes('%USERPROFILE%\Desktop\6OCIV5_证书文件（密码 1）.p12'); $p12Base64 = [Convert]::ToBase64String($p12Bytes); $p12Base64 | Out-File -FilePath 'ios_p12_base64.txt' -Encoding ascii -NoNewline"
if %errorlevel% equ 0 (
    echo   ✓ P12 证书转换成功
) else (
    echo   × P12 证书转换失败
    exit /b 1
)

echo.
echo [2/3] 转换 Provisioning Profile...
powershell -Command "$provBytes = [IO.File]::ReadAllBytes('%USERPROFILE%\Desktop\6OCIV5_描述文件.mobileprovision'); $provBase64 = [Convert]::ToBase64String($provBytes); $provBase64 | Out-File -FilePath 'ios_mobileprovision_base64.txt' -Encoding ascii -NoNewline"
if %errorlevel% equ 0 (
    echo   ✓ Provisioning Profile 转换成功
) else (
    echo   × Provisioning Profile 转换失败
    exit /b 1
)

echo.
echo [3/3] 生成配置指南...
(
echo ====================================
echo   GitHub Secrets 配置指南
echo ====================================
echo.
echo 请访问：https://github.com/ashun520/CHAT/settings/secrets/actions
echo.
echo 添加以下 3 个 Secrets：
echo.
echo 1. IOS_P12_BASE64
echo    值：复制 ios_p12_base64.txt 的全部内容
echo.
echo 2. IOS_P12_PASSWORD
echo    值：1
echo.
echo 3. IOS_MOBILE_PROVISION_BASE64
echo    值：复制 ios_mobileprovision_base64.txt 的全部内容
echo.
echo ====================================
) > github_secrets_guide.txt

echo   ✓ 配置指南已生成
echo.
echo ====================================
echo   转换完成！
echo ====================================
echo.
echo 生成的文件：
echo   - ios_p12_base64.txt
echo   - ios_mobileprovision_base64.txt
echo   - github_secrets_guide.txt
echo.
echo 请打开 github_secrets_guide.txt 查看配置步骤
echo.
pause
