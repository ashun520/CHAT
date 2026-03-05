@echo off
chcp 65001 >nul
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║   SuperChat 后端服务器启动脚本                            ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

echo 正在检查环境...
echo.

REM 检查 Node.js
where node >nul 2>nul
if errorlevel 1 (
    echo ❌ 未检测到 Node.js，请先安装 Node.js
    echo 下载地址：https://nodejs.org/
    pause
    exit /b 1
)
echo ✅ Node.js 已安装

REM 检查 MongoDB
where mongosh >nul 2>nul
if errorlevel 1 (
    where mongo >nul 2>nul
    if errorlevel 1 (
        echo ⚠️  未检测到 MongoDB Shell
        echo 请确保 MongoDB 服务已启动
    ) else (
        echo ✅ MongoDB 已安装
    )
) else (
    echo ✅ MongoDB 已安装
)

REM 检查 Redis
where redis-cli >nul 2>nul
if errorlevel 1 (
    echo ⚠️  未检测到 Redis CLI
    echo 请确保 Redis 服务已启动
) else (
    echo ✅ Redis 已安装
)

echo.
echo 正在启动后端服务器...
echo.

cd backend
call npm run dev

if errorlevel 1 (
    echo.
    echo ❌ 服务器启动失败！
    echo 请检查：
    echo   1. MongoDB 服务是否已启动
    echo   2. Redis 服务是否已启动
    echo   3. 端口 3000 是否被占用
    echo   4. 查看上面的错误信息
    pause
    exit /b 1
)

pause
