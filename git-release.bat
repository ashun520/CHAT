@echo off
chcp 65001 >nul
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║   创建版本标签并发布（触发自动构建 IPA）                  ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

cd /d %~dp0

echo 当前版本：v1.0.0
echo.

set /p VERSION="请输入版本号 (默认 v1.0.0): "
if "%VERSION%"=="" set VERSION=v1.0.0

echo.
echo 即将创建标签：%VERSION%
echo.
echo 此操作将会:
echo   1. 创建 Git 标签
echo   2. 推送到 GitHub
echo   3. 触发 GitHub Actions 自动构建 IPA 和 APK
echo.

set /p CONFIRM="确认发布？(Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo 已取消
    pause
    exit /b 0
)

echo.
echo 创建标签...
git tag %VERSION%

echo.
echo 推送标签到 GitHub...
git push origin %VERSION%

if errorlevel 1 (
    echo.
    echo ❌ 推送失败！
    echo 请检查网络连接和 GitHub 仓库权限
    echo.
    pause
    exit /b 1
)

echo.
echo ═══════════════════════════════════════════════════════════
echo.
echo ✅ 发布成功！
echo.
echo 标签 %VERSION% 已推送到 GitHub
echo.
echo 自动构建已触发，请等待完成:
echo   https://github.com/YOUR_USERNAME/SuperChat/actions
echo.
echo 构建完成后可以下载:
echo   - iOS IPA 文件
echo   - Android APK 文件
echo.
echo 查看 Release 页面:
echo   https://github.com/YOUR_USERNAME/SuperChat/releases/tag/%VERSION%
echo.
echo ═══════════════════════════════════════════════════════════
echo.

pause
