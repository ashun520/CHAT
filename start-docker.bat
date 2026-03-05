@echo off
chcp 65001 >nul
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║   SuperChat Docker 服务启动脚本                           ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

echo 正在检查 Docker...
echo.

where docker >nul 2>nul
if errorlevel 1 (
    echo ❌ 未检测到 Docker，请先安装 Docker Desktop
    echo 下载地址：https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)
echo ✅ Docker 已安装

docker --version
echo.

echo 正在启动 MongoDB 和 Redis 服务...
echo.

docker-compose up -d

if errorlevel 1 (
    echo.
    echo ❌ Docker 服务启动失败！
    echo 请检查：
    echo   1. Docker Desktop 是否已启动
    echo   2. docker-compose.yml 文件是否存在
    pause
    exit /b 1
)

echo.
echo ✅ Docker 服务启动成功！
echo.
echo 服务信息:
echo   - MongoDB: localhost:27017
echo   - Redis: localhost:6379
echo.
echo 数据库连接信息:
echo   - MongoDB 用户名：admin
echo   - MongoDB 密码：admin123
echo   - MongoDB 数据库：superchat
echo.
echo 提示:
echo   - 查看日志：docker-compose logs -f
echo   - 停止服务：docker-compose down
echo   - 重启服务：docker-compose restart
echo.

pause
