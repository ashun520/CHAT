@echo off
chcp 65001 >nul
echo ====================================
echo   一键添加 GitHub Secrets
echo ====================================
echo.
echo 正在打开 GitHub Secrets 页面...
echo.
echo 请在浏览器中:
echo 1. 登录您的 GitHub 账号
echo 2. 依次添加以下 3 个 Secrets
echo.
echo ====================================
echo Secret 1:
echo   名称：IOS_P12_BASE64
echo   值：打开 ios_p12_base64.txt 复制全部内容
echo.
echo Secret 2:
echo   名称：IOS_P12_PASSWORD  
echo   值：1
echo.
echo Secret 3:
echo   名称：IOS_MOBILE_PROVISION_BASE64
echo   值：打开 ios_mobileprovision_base64.txt 复制全部内容
echo ====================================
echo.
start https://github.com/ashun520/CHAT/settings/secrets/actions
echo.
echo 已为您打开浏览器!
echo.
echo 添加完成后，按任意键继续...
pause >nul
echo.
echo 正在检查是否添加成功...
timeout /t 3 >nul
start https://github.com/ashun520/CHAT/actions
echo.
echo ====================================
echo   完成！
echo ====================================
echo.
echo 已打开 Actions 页面
echo 点击 "Run workflow" 即可开始构建
echo.
pause
