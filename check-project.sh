#!/bin/bash

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║   SuperChat 项目完整性检查                                ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查计数
TOTAL=0
PASSED=0
FAILED=0

# 检查函数
check_file() {
    TOTAL=$((TOTAL + 1))
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $1 (缺失)"
        FAILED=$((FAILED + 1))
        return 1
    fi
}

check_dir() {
    TOTAL=$((TOTAL + 1))
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}✗${NC} $1 (缺失)"
        FAILED=$((FAILED + 1))
        return 1
    fi
}

echo "📁 检查项目结构..."
echo ""

echo "后端文件:"
check_file "backend/package.json"
check_file "backend/.env"
check_file "backend/.env.example"
check_file "backend/src/server.js"
check_file "backend/src/config/database.js"
check_file "backend/src/config/redis.js"
check_file "backend/src/models/User.js"
check_file "backend/src/models/Message.js"
check_file "backend/src/models/Conversation.js"
check_file "backend/src/models/Group.js"
check_file "backend/src/controllers/authController.js"
check_file "backend/src/controllers/chatController.js"
check_file "backend/src/controllers/friendController.js"
check_file "backend/src/routes/auth.js"
check_file "backend/src/routes/chat.js"
check_file "backend/src/routes/friends.js"
check_file "backend/src/routes/upload.js"
check_file "backend/src/middleware/auth.js"
check_file "backend/src/middleware/validators.js"
check_file "backend/src/socket/socketHandler.js"
echo ""

echo "前端文件:"
check_file "frontend/pubspec.yaml"
check_file "frontend/analysis_options.yaml"
check_file "frontend/lib/main.dart"
check_file "frontend/lib/config/routes.dart"
check_file "frontend/lib/config/theme.dart"
check_file "frontend/lib/config/constants.dart"
check_file "frontend/lib/models/user_model.dart"
check_file "frontend/lib/models/message_model.dart"
check_file "frontend/lib/models/conversation_model.dart"
check_file "frontend/lib/providers/auth_provider.dart"
check_file "frontend/lib/providers/socket_provider.dart"
check_file "frontend/lib/providers/chat_provider.dart"
check_file "frontend/lib/providers/theme_provider.dart"
check_file "frontend/lib/services/api_service.dart"
check_file "frontend/lib/services/storage_service.dart"
check_file "frontend/lib/screens/splash/splash_screen.dart"
check_file "frontend/lib/screens/login/login_screen.dart"
check_file "frontend/lib/screens/register/register_screen.dart"
check_file "frontend/lib/screens/home/home_screen.dart"
check_file "frontend/lib/screens/chat/chat_list_screen.dart"
check_file "frontend/lib/screens/chat/chat_screen.dart"
check_file "frontend/lib/screens/contact/contact_screen.dart"
check_file "frontend/lib/screens/discover/discover_screen.dart"
check_file "frontend/lib/screens/profile/profile_screen.dart"
check_file "frontend/lib/screens/friend/friend_request_screen.dart"
check_file "frontend/lib/screens/group/group_create_screen.dart"
check_file "frontend/lib/screens/group/group_info_screen.dart"
check_file "frontend/lib/screens/moment/moment_screen.dart"
echo ""

echo "GitHub 配置:"
check_file ".github/workflows/build-ios.yml"
check_file ".github/workflows/build-android.yml"
check_file ".gitignore"
echo ""

echo "文档文件:"
check_file "README.md"
check_file "QUICKSTART.md"
check_file "FEATURES.md"
check_file "项目总览.md"
check_file "开始使用.md"
check_file "LICENSE"
check_file "docs/BUILD.md"
check_file "docs/iOS_BUILD.md"
echo ""

echo "启动脚本:"
check_file "install-dependencies.bat"
check_file "start-backend.bat"
check_file "start-frontend.bat"
check_file "start-docker.bat"
check_file "docker-compose.yml"
echo ""

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║ 检查结果汇总                                              ║"
echo "╠═══════════════════════════════════════════════════════════╣"
printf "║ 总计：%-5d 通过：%-5d 失败：%-5d                    ║\n" $TOTAL $PASSED $FAILED
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ 所有文件检查通过！${NC}"
    echo ""
    echo "下一步操作："
    echo "1. 初始化 Git 仓库："
    echo "   git init"
    echo ""
    echo "2. 添加所有文件："
    echo "   git add ."
    echo ""
    echo "3. 提交代码："
    echo "   git commit -m 'Initial commit: SuperChat v1.0.0'"
    echo ""
    echo "4. 添加 GitHub 远程仓库："
    echo "   git remote add origin https://github.com/YOUR_USERNAME/SuperChat.git"
    echo ""
    echo "5. 推送到 GitHub："
    echo "   git push -u origin main"
    echo ""
    exit 0
else
    echo -e "${RED}❌ 部分文件缺失，请检查！${NC}"
    echo ""
    exit 1
fi
