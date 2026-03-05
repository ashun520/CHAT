@echo off
chcp 65001 >nul
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║   SuperChat 依赖安装脚本                                  ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

echo [1/3] 正在安装后端依赖...
echo.
cd backend
call npm install
if errorlevel 1 (
    echo.
    echo ❌ 后端依赖安装失败！
    echo 请检查：
    echo   1. Node.js 是否已安装
    echo   2. 网络连接是否正常
    echo   3. npm 是否可用
    pause
    exit /b 1
)
echo ✅ 后端依赖安装完成！
echo.

cd ..\frontend
echo [2/3] 正在安装前端依赖...
echo.
call flutter pub get
if errorlevel 1 (
    echo.
    echo ❌ 前端依赖安装失败！
    echo 请检查：
    echo   1. Flutter 是否已安装
    echo   2. 网络连接是否正常
    echo   3. Flutter SDK 版本是否 >= 3.0.0
    pause
    exit /b 1
)
echo ✅ 前端依赖安装完成！
echo.

echo [3/3] 创建必要的目录...
if not exist "backend\uploads" mkdir "backend\uploads"
if not exist "frontend\assets\images" mkdir "frontend\assets\images"
if not exist "frontend\assets\icons" mkdir "frontend\assets\icons"
if not exist "frontend\assets\emoji" mkdir "frontend\assets\emoji"
if not exist "frontend\assets\sounds" mkdir "frontend\assets\sounds"
if not exist "frontend\assets\fonts" mkdir "frontend\assets\fonts"
echo ✅ 目录创建完成！
echo.

echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║   ✅ 所有依赖安装完成！                                    ║
echo ║                                                           ║
echo ║   下一步：                                                ║
echo ║   1. 确保 MongoDB 和 Redis 已安装并启动                    ║
echo ║   2. 运行后端：cd backend ^&^& npm run dev                 ║
echo ║   3. 运行前端：cd frontend ^&^& flutter run                 ║
echo ║                                                           ║
echo ║   详细说明请查看：QUICKSTART.md                           ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
pause
