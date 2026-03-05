@echo off
chcp 65001 >nul
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║   推送到 GitHub                                           ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

cd /d %~dp0

set /p GITHUB_USERNAME="请输入你的 GitHub 用户名："
if "%GITHUB_USERNAME%"=="" (
    echo 错误：用户名不能为空
    pause
    exit /b 1
)

echo.
echo 远程仓库：https://github.com/%GITHUB_USERNAME%/SuperChat.git
echo.

REM 检查远程仓库是否已配置
git remote -v | findstr origin
if errorlevel 1 (
    echo 配置远程仓库...
    git remote add origin https://github.com/%GITHUB_USERNAME%/SuperChat.git
)

echo.
echo 正在推送到 GitHub...
echo.

git push -u origin main

if errorlevel 1 (
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo ❌ 推送失败！
    echo.
    echo 请检查:
    echo   1. GitHub 仓库是否已创建
    echo   2. Git 凭证是否已配置
    echo   3. 网络连接是否正常
    echo.
    echo 手动推送命令:
    echo   git push -u origin main
    echo.
) else (
    echo.
    echo ═══════════════════════════════════════════════════════════
    echo.
    echo ✅ 推送成功！
    echo.
    echo 访问仓库：https://github.com/%GITHUB_USERNAME%/SuperChat
    echo.
    echo 下一步:
    echo   1. 查看代码：https://github.com/%GITHUB_USERNAME%/SuperChat
    echo   2. 配置 Actions: https://github.com/%GITHUB_USERNAME%/SuperChat/actions
    echo   3. 创建标签发布：git tag v1.0.0 ^&^& git push origin v1.0.0
    echo.
)

pause
