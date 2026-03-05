# SuperChat - 超级聊天应用

一个功能强大的跨平台即时通讯应用，支持微信和 QQ 级别的功能。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)](https://nodejs.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-4.4+-brightgreen.svg)](https://mongodb.com)

## 🌟 特性

- 💬 **实时聊天** - 支持文字、图片、语音、视频、表情等多种消息类型
- 👥 **好友系统** - 完整的好友管理、好友请求、黑名单功能
- 👨‍👩‍👧‍👦 **群聊功能** - 群聊、群公告、群管理、@功能
- 📱 **跨平台** - iOS 和 Android 一套代码全支持
- 🚀 **高性能** - WebSocket 实时通信，消息秒达
- 🎨 **美观 UI** - 类似微信的现代化界面设计
- 📦 **完整功能** - 朋友圈、文件传输、语音视频通话（开发中）

## 📱 应用预览

| 登录注册 | 聊天列表 | 聊天对话 |
|:---:|:---:|:---:|
| ![Login](docs/screenshots/login.png) | ![Chat List](docs/screenshots/chat_list.png) | ![Chat](docs/screenshots/chat.png) |

| 联系人 | 发现 | 我的 |
|:---:|:---:|:---:|
| ![Contact](docs/screenshots/contact.png) | ![Discover](docs/screenshots/discover.png) | ![Profile](docs/screenshots/profile.png) |

## 🏗️ 技术架构

### 后端技术栈
- **Node.js** + **Express** - 高性能 Web 服务器
- **Socket.IO** - WebSocket 实时双向通信
- **MongoDB** - NoSQL 数据库
- **Redis** - 内存缓存和消息队列
- **JWT** - 用户认证和授权

### 前端技术栈
- **Flutter** - 跨平台移动应用框架
- **Provider** - 状态管理
- **Dio** - HTTP 网络请求
- **Socket.IO Client** - WebSocket 客户端
- **SharedPreferences** - 本地存储

## 🚀 快速开始

### 环境要求

- Node.js >= 16.0.0
- MongoDB >= 4.4
- Redis >= 6.0
- Flutter >= 3.0.0
- Dart >= 2.17.0

### 1. 克隆项目

```bash
git clone https://github.com/YOUR_USERNAME/SuperChat.git
cd SuperChat
```

### 2. 安装依赖

#### Windows 用户（推荐）
```bash
# 双击运行安装脚本
install-dependencies.bat
```

#### macOS/Linux 用户
```bash
# 安装后端依赖
cd backend
npm install

# 安装前端依赖
cd ../frontend
flutter pub get
```

### 3. 配置数据库

#### 使用 Docker（推荐）
```bash
# Windows/macOS/Linux
docker-compose up -d
```

#### 或本地安装
- MongoDB: https://www.mongodb.com/try/download/community
- Redis: https://redis.io/download

### 4. 配置环境变量

编辑 `backend/.env` 文件：
```bash
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/superchat
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRE=7d
```

### 5. 启动服务

#### 方式一：使用脚本（Windows）
```bash
# 启动后端
start-backend.bat

# 启动前端（新窗口）
start-frontend.bat
```

#### 方式二：手动启动
```bash
# 启动后端
cd backend
npm run dev

# 启动前端（新终端）
cd frontend
flutter run
```

## 📖 文档

- [📘 快速启动指南](QUICKSTART.md) - 详细的安装和启动说明
- [📗 功能清单](FEATURES.md) - 完整的功能列表和开发计划
- [📙 项目总览](项目总览.md) - 架构设计和技术详解
- [📕 使用手册](开始使用.md) - 用户使用指南

## 🎯 功能特性

### 已实现 ✅

#### 用户系统
- ✅ 用户注册（用户名、邮箱、手机号）
- ✅ 用户登录（支持多种账号类型）
- ✅ JWT Token 认证
- ✅ 用户信息管理
- ✅ 在线状态管理

#### 聊天功能
- ✅ 一对一私聊
- ✅ 群聊功能
- ✅ 文字消息
- ✅ 表情消息
- ✅ 图片/文件传输
- ✅ 消息已读状态
- ✅ 输入状态提示
- ✅ 实时消息推送

#### 好友系统
- ✅ 搜索用户
- ✅ 发送好友请求
- ✅ 处理好友请求
- ✅ 好友列表
- ✅ 删除好友
- ✅ 黑名单功能

#### 群聊管理
- ✅ 创建群聊
- ✅ 群聊信息
- ✅ 群成员管理
- ✅ 群角色（群主、管理员、成员）
- ✅ 群公告

#### UI 界面
- ✅ 启动页
- ✅ 登录/注册页
- ✅ 主页面（底部导航）
- ✅ 聊天列表页
- ✅ 聊天对话页
- ✅ 联系人页面
- ✅ 发现页面
- ✅ 个人中心页
- ✅ 朋友圈页面

### 开发中 �

- 🔄 语音视频通话
- 🔄 消息撤回
- 🔄 消息回复（@功能）
- 🔄 语音消息
- 🔄 视频消息
- 🔄 朋友圈增强

### 计划中 📝

- 📝 红包功能
- 📝 支付系统
- 📝 公众号
- 📝 小程序平台
- 📝 游戏中心

## 📱 平台支持

| 平台 | 状态 | 最低版本 |
|------|------|----------|
| iOS | ✅ 支持 | iOS 9.0+ |
| Android | ✅ 支持 | Android 5.0+ |
| Web | 🔄 计划中 | - |
| Windows | 🔄 计划中 | - |
| macOS | 🔄 计划中 | - |

## 🛠️ 开发指南

### 项目结构

```
SuperChat/
├── backend/              # 后端服务
│   ├── src/
│   │   ├── controllers/  # 控制器
│   │   ├── models/       # 数据模型
│   │   ├── routes/       # API 路由
│   │   ├── middleware/   # 中间件
│   │   ├── socket/       # Socket.IO 处理器
│   │   └── config/       # 配置
│   └── .env              # 环境变量
│
├── frontend/             # Flutter 前端
│   └── lib/
│       ├── models/       # 数据模型
│       ├── screens/      # 页面
│       ├── providers/    # 状态管理
│       ├── services/     # 服务
│       └── config/       # 配置
│
└── docs/                 # 文档
```

### 常见问题

#### 后端启动失败
确保 MongoDB 和 Redis 服务已启动：
```bash
# 检查 MongoDB
mongosh

# 检查 Redis
redis-cli ping
```

#### 前端无法连接后端
- 检查后端是否启动（访问 http://localhost:3000/health）
- Android 模拟器使用 `10.0.2.2:3000` 访问宿主机
- 真机调试需要修改为电脑 IP 地址

#### 端口被占用
修改 `backend/.env` 中的 `PORT` 值

### 测试

```bash
# 后端测试
cd backend
npm test

# 前端测试
cd frontend
flutter test
```

## 📦 构建发布版本

### Android APK
```bash
cd frontend
flutter build apk --release
```

### iOS IPA
```bash
cd frontend
flutter build ios --release
```

详细构建说明请查看 [构建指南](docs/BUILD.md)

## 🤝 贡献

欢迎贡献代码！请遵循以下步骤：

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

## 📄 开源协议

本项目采用 [MIT 协议](LICENSE) 开源。

## 📞 联系方式

- 📧 Email: your-email@example.com
- 💬 Issues: [GitHub Issues](https://github.com/YOUR_USERNAME/SuperChat/issues)
- 🌐 Website: https://your-website.com

## 🙏 致谢

感谢以下开源项目：

- [Flutter](https://flutter.dev)
- [Node.js](https://nodejs.org)
- [Socket.IO](https://socket.io)
- [MongoDB](https://mongodb.com)
- [Redis](https://redis.io)

---

**如果这个项目对你有帮助，请给一个 ⭐️ Star 支持！**

[![Star History Chart](https://api.star-history.com/svg?repos=YOUR_USERNAME/SuperChat&type=Date)](https://star-history.com/#YOUR_USERNAME/SuperChat&Date)
