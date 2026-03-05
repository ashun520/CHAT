@echo off
chcp 65001 >nul
cd /d %~dp0
echo.
echo 正在推送到 GitHub...
echo.
git push -u origin main
echo.
if errorlevel 1 (
    echo 推送失败，请检查网络连接和 GitHub 凭证
) else (
    echo 推送成功！
    echo.
    echo 访问仓库：https://github.com/ashun520/CHAT
)
pause
