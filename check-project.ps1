# SuperChat 项目完整性检查脚本

Write-Host "╔═══════════════════════════════════════════════════════════╗"
Write-Host "║                                                           ║"
Write-Host "║   SuperChat 项目完整性检查                                ║"
Write-Host "║                                                           ║"
Write-Host "╚═══════════════════════════════════════════════════════════╝"
Write-Host ""

# 检查计数
$Total = 0
$Passed = 0
$Failed = 0

# 检查函数
function Check-File {
    param($Path)
    $script:Total++
    if (Test-Path $Path) {
        Write-Host "✓ $Path" -ForegroundColor Green
        $script:Passed++
        return $true
    } else {
        Write-Host "✗ $Path (缺失)" -ForegroundColor Red
        $script:Failed++
        return $false
    }
}

Write-Host "📁 检查项目结构..." -ForegroundColor Cyan
Write-Host ""

Write-Host "后端文件:" -ForegroundColor Yellow
Check-File "backend\package.json"
Check-File "backend\.env"
Check-File "backend\.env.example"
Check-File "backend\src\server.js"
Check-File "backend\src\config\database.js"
Check-File "backend\src\config\redis.js"
Check-File "backend\src\models\User.js"
Check-File "backend\src\models\Message.js"
Check-File "backend\src\models\Conversation.js"
Check-File "backend\src\models\Group.js"
Check-File "backend\src\controllers\authController.js"
Check-File "backend\src\controllers\chatController.js"
Check-File "backend\src\controllers\friendController.js"
Check-File "backend\src\routes\auth.js"
Check-File "backend\src\routes\chat.js"
Check-File "backend\src\routes\friends.js"
Check-File "backend\src\routes\upload.js"
Check-File "backend\src\middleware\auth.js"
Check-File "backend\src\middleware\validators.js"
Check-File "backend\src\socket\socketHandler.js"
Write-Host ""

Write-Host "前端文件:" -ForegroundColor Yellow
Check-File "frontend\pubspec.yaml"
Check-File "frontend\analysis_options.yaml"
Check-File "frontend\lib\main.dart"
Check-File "frontend\lib\config\routes.dart"
Check-File "frontend\lib\config\theme.dart"
Check-File "frontend\lib\config\constants.dart"
Check-File "frontend\lib\models\user_model.dart"
Check-File "frontend\lib\models\message_model.dart"
Check-File "frontend\lib\models\conversation_model.dart"
Check-File "frontend\lib\providers\auth_provider.dart"
Check-File "frontend\lib\providers\socket_provider.dart"
Check-File "frontend\lib\providers\chat_provider.dart"
Check-File "frontend\lib\providers\theme_provider.dart"
Check-File "frontend\lib\services\api_service.dart"
Check-File "frontend\lib\services\storage_service.dart"
Check-File "frontend\lib\screens\splash\splash_screen.dart"
Check-File "frontend\lib\screens\login\login_screen.dart"
Check-File "frontend\lib\screens\register\register_screen.dart"
Check-File "frontend\lib\screens\home\home_screen.dart"
Check-File "frontend\lib\screens\chat\chat_list_screen.dart"
Check-File "frontend\lib\screens\chat\chat_screen.dart"
Check-File "frontend\lib\screens\contact\contact_screen.dart"
Check-File "frontend\lib\screens\discover\discover_screen.dart"
Check-File "frontend\lib\screens\profile\profile_screen.dart"
Check-File "frontend\lib\screens\friend\friend_request_screen.dart"
Check-File "frontend\lib\screens\group\group_create_screen.dart"
Check-File "frontend\lib\screens\group\group_info_screen.dart"
Check-File "frontend\lib\screens\moment\moment_screen.dart"
Write-Host ""

Write-Host "GitHub 配置:" -ForegroundColor Yellow
Check-File ".github\workflows\build-ios.yml"
Check-File ".github\workflows\build-android.yml"
Check-File ".gitignore"
Write-Host ""

Write-Host "文档文件:" -ForegroundColor Yellow
Check-File "README.md"
Check-File "QUICKSTART.md"
Check-File "FEATURES.md"
Check-File "项目总览.md"
Check-File "开始使用.md"
Check-File "LICENSE"
Check-File "docs\BUILD.md"
Check-File "docs\iOS_BUILD.md"
Write-Host ""

Write-Host "启动脚本:" -ForegroundColor Yellow
Check-File "install-dependencies.bat"
Check-File "start-backend.bat"
Check-File "start-frontend.bat"
Check-File "start-docker.bat"
Check-File "docker-compose.yml"
Write-Host ""

Write-Host "╔═══════════════════════════════════════════════════════════╗"
Write-Host "║ 检查结果汇总                                              ║"
Write-Host "╠═══════════════════════════════════════════════════════════╣"
Write-Host ("║ 总计：{0,-5} 通过：{1,-5} 失败：{2,-5}                    ║" -f $Total, $Passed, $Failed)
Write-Host "╚═══════════════════════════════════════════════════════════╝"
Write-Host ""

if ($Failed -eq 0) {
    Write-Host "✅ 所有文件检查通过！" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步操作：" -ForegroundColor Cyan
    Write-Host "1. 初始化 Git 仓库："
    Write-Host "   git init" -ForegroundColor White
    Write-Host ""
    Write-Host "2. 添加所有文件："
    Write-Host "   git add ." -ForegroundColor White
    Write-Host ""
    Write-Host "3. 提交代码："
    Write-Host "   git commit -m 'Initial commit: SuperChat v1.0.0'" -ForegroundColor White
    Write-Host ""
    Write-Host "4. 添加 GitHub 远程仓库："
    Write-Host "   git remote add origin https://github.com/YOUR_USERNAME/SuperChat.git" -ForegroundColor White
    Write-Host ""
    Write-Host "5. 推送到 GitHub："
    Write-Host "   git push -u origin main" -ForegroundColor White
    Write-Host ""
    Write-Host "提示：已创建 check-project.ps1 脚本，运行此脚本可自动检查项目完整性" -ForegroundColor Yellow
} else {
    Write-Host "❌ 部分文件缺失，请检查！" -ForegroundColor Red
    Write-Host ""
    exit 1
}
