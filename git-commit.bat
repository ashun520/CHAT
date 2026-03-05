@echo off
chcp 65001 >nul
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                                                           ║
echo ║   Git 提交和推送脚本                                      ║
echo ║                                                           ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

cd /d %~dp0

echo 正在检查 Git 状态...
echo.

git status

echo.
echo ═══════════════════════════════════════════════════════════
echo.

set /p GITHUB_USERNAME="请输入你的 GitHub 用户名："
if "%GITHUB_USERNAME%"=="" (
    echo 错误：用户名不能为空
    pause
    exit /b 1
)

echo.
echo 1. 初始化 Git 仓库（如果已初始化则跳过）
git init

echo.
echo 2. 添加所有文件
git add .

echo.
echo 3. 提交代码
git commit -m "Initial commit: SuperChat v1.0.0 - Full featured chat application"

echo.
echo 4. 重命名分支为 main
git branch -M main

echo.
echo 5. 添加远程仓库
git remote remove origin 2>nul
git remote add origin https://github.com/%GITHUB_USERNAME%/SuperChat.git

echo.
echo ═══════════════════════════════════════════════════════════
echo.
echo ✅ Git 仓库配置完成！
echo.
echo 远程仓库地址：https://github.com/%GITHUB_USERNAME%/SuperChat.git
echo.
echo 下一步操作：
echo.
echo   1. 在 GitHub 上创建仓库（如果还没有创建）
echo      访问：https://github.com/new
echo      仓库名：SuperChat
echo.
echo   2. 推送到 GitHub：
echo      git push -u origin main
echo.
echo   3. 推送标签（发布版本时）：
echo      git tag v1.0.0
echo      git push origin v1.0.0
echo.
echo   4. 查看自动构建：
echo      访问：https://github.com/%GITHUB_USERNAME%/SuperChat/actions
echo.
echo ═══════════════════════════════════════════════════════════
echo.
set /p PUSH_NOW="是否现在推送到 GitHub? (Y/N): "
if /i "%PUSH_NOW%"=="Y" (
    echo.
    echo 正在推送...
    git push -u origin main
    
    if errorlevel 1 (
        echo.
        echo ❌ 推送失败！
        echo.
        echo 可能原因:
        echo   1. GitHub 仓库不存在 - 请先在 GitHub 创建仓库
        echo   2. 认证失败 - 请配置 Git 凭证
        echo   3. 网络问题 - 请检查网络连接
        echo.
    ) else (
        echo.
        echo ✅ 推送成功！
        echo.
        echo 访问你的仓库：https://github.com/%GITHUB_USERNAME%/SuperChat
        echo.
    )
)

echo.
pause
