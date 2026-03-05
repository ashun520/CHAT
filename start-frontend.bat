@echo off
chcp 65001 >nul
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║   SuperChat 前端应用启动脚本                              ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

echo 正在检查环境...
echo.

REM 检查 Flutter
where flutter >nul 2>nul
if errorlevel 1 (
    echo ❌ 未检测到 Flutter，请先安装 Flutter SDK
    echo 下载地址：https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)
echo ✅ Flutter 已安装

REM 检查 Flutter 版本
for /f "tokens=2" %%i in ('flutter --version --machine 2^>nul ^| findstr /c:"flutterVersion"') do set FLUTTER_VERSION=%%i
echo Flutter 版本：%FLUTTER_VERSION%

echo.
echo 正在检查设备...
echo.

call flutter devices

echo.
echo 提示:
echo   - 确保至少有一个设备（模拟器或真机）已连接
echo   - 如果没有设备，请先启动 Android 模拟器
echo.

echo 正在启动应用...
echo.

cd frontend
call flutter run

if errorlevel 1 (
    echo.
    echo ❌ 应用启动失败！
    echo 请检查：
    echo   1. 是否有设备连接
    echo   2. Flutter 依赖是否已安装（运行 flutter pub get）
    echo   3. 查看上面的错误信息
    pause
    exit /b 1
)

pause
