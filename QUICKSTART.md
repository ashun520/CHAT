# SuperChat 快速启动指南

本指南将帮助你快速搭建和运行 SuperChat 聊天应用。

## 📋 环境要求

### 后端环境
- **Node.js**: >= 16.0.0
- **MongoDB**: >= 4.4
- **Redis**: >= 6.0
- **npm**: >= 8.0.0

### 前端环境
- **Flutter**: >= 3.0.0
- **Dart**: >= 2.17.0
- **Android Studio** 或 **VS Code**
- **Android 模拟器** 或 **iOS 模拟器**

## 🚀 快速开始

### 1. 安装 MongoDB

#### Windows
1. 下载 MongoDB Community Server: https://www.mongodb.com/try/download/community
2. 安装并启动服务
3. 验证安装：`mongosh`

#### 使用 Docker（推荐）
```bash
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

### 2. 安装 Redis

#### Windows
1. 下载 Redis for Windows: https://github.com/microsoftarchive/redis/releases
2. 解压并运行 `redis-server.exe`

#### 使用 Docker（推荐）
```bash
docker run -d -p 6379:6379 --name redis redis:latest
```

### 3. 配置并启动后端

```bash
# 进入后端目录
cd SuperChat/backend

# 安装依赖
npm install

# 配置环境变量（可选，已有默认配置）
# 编辑 .env 文件，修改数据库连接等配置

# 启动开发服务器
npm run dev
```

如果一切正常，你将看到类似输出：
```
✅ MongoDB 连接成功：localhost
✅ Redis 连接成功
🚀 SuperChat 服务器已启动！

端口：3000
环境：development

API: http://localhost:3000/api
Socket.IO: ws://localhost:3000
健康检查：http://localhost:3000/health
```

### 4. 配置并启动前端

```bash
# 进入前端目录
cd SuperChat/frontend

# 获取 Flutter 依赖
flutter pub get

# 运行应用
flutter run
```

#### Android 模拟器特殊配置
如果你使用 Android 模拟器，需要修改 API 地址：
- 打开 `frontend/lib/config/constants.dart`
- 确认 `baseUrl` 为：`http://10.0.2.2:3000/api`
- 确认 `socketUrl` 为：`http://10.0.2.2:3000`

#### 真机调试
如果你使用真机调试，需要：
1. 确保手机和电脑在同一局域网
2. 修改 `constants.dart` 中的 IP 地址为你的电脑 IP
   ```dart
   static const String baseUrl = 'http://192.168.1.100:3000/api';
   static const String socketUrl = 'http://192.168.1.100:3000';
   ```

## 📱 功能测试

### 1. 注册账号
- 启动应用后，点击"立即注册"
- 填写用户名、邮箱、手机号和密码
- 点击"注册"按钮

### 2. 登录
- 使用注册的账号登录
- 支持手机号/邮箱/用户名登录

### 3. 聊天功能
- 点击右下角"+"按钮创建群聊
- 或从联系人中选择好友发起聊天
- 发送文字消息测试实时通信

### 4. 好友功能
- 点击"联系人" -> "添加朋友"
- 搜索用户并发送好友请求
- 在"新的朋友"中查看和处理请求

## 🔧 常见问题

### 后端启动失败

**问题 1: MongoDB 连接失败**
```
Error: connect ECONNREFUSED 127.0.0.1:27017
```
**解决**: 确保 MongoDB 服务已启动
```bash
# Windows
net start MongoDB

# Docker
docker start mongodb
```

**问题 2: Redis 连接失败**
```
Error: connect ECONNREFUSED 127.0.0.1:6379
```
**解决**: 确保 Redis 服务已启动
```bash
# Windows
redis-server.exe

# Docker
docker start redis
```

**问题 3: 端口被占用**
```
Error: listen EADDRINUSE: address already in use :::3000
```
**解决**: 修改端口
- 编辑 `backend/.env`
- 修改 `PORT=3000` 为其他端口，如 `PORT=3001`
- 同时修改前端的 API 地址

### 前端运行失败

**问题 1: Flutter 依赖获取失败**
```
Running "flutter pub get" in frontend...
```
**解决**: 
```bash
# 清理缓存
flutter clean
flutter pub cache repair
flutter pub get
```

**问题 2: 无法连接后端**
- 检查后端是否启动
- 检查 API 地址配置
- 检查防火墙设置

**问题 3: 模拟器网络问题**
- Android 模拟器使用 `10.0.2.2` 访问宿主机
- iOS 模拟器使用 `localhost` 或 `127.0.0.1`

## 📝 API 测试

使用 Postman 或 curl 测试 API：

### 健康检查
```bash
curl http://localhost:3000/health
```

### 用户注册
```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "phone": "13800138000",
    "password": "123456"
  }'
```

### 用户登录
```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "account": "testuser",
    "password": "123456"
  }'
```

## 🛠️ 开发工具推荐

### 后端开发
- **VS Code** + MongoDB 扩展
- **MongoDB Compass** - 数据库可视化工具
- **Redis Desktop Manager** - Redis 可视化工具
- **Postman** - API 测试工具

### 前端开发
- **Android Studio** - Flutter 开发
- **VS Code** + Flutter 扩展
- **Flutter DevTools** - 性能分析工具

## 📊 项目结构说明

```
SuperChat/
├── backend/              # 后端服务
│   ├── src/
│   │   ├── controllers/  # 控制器（业务逻辑）
│   │   ├── models/       # 数据模型（数据库结构）
│   │   ├── routes/       # API 路由
│   │   ├── middleware/   # 中间件（认证、验证等）
│   │   ├── services/     # 业务服务
│   │   ├── socket/       # Socket.IO 处理器
│   │   ├── config/       # 配置文件
│   │   └── server.js     # 入口文件
│   ├── uploads/          # 上传文件存储
│   ├── .env              # 环境变量配置
│   └── package.json      # 依赖配置
│
├── frontend/             # Flutter 前端
│   ├── lib/
│   │   ├── models/       # 数据模型
│   │   ├── screens/      # 页面
│   │   ├── widgets/      # 组件
│   │   ├── services/     # 服务（API、存储）
│   │   ├── providers/    # 状态管理
│   │   ├── config/       # 配置文件
│   │   └── main.dart     # 入口文件
│   └── pubspec.yaml      # 依赖配置
│
└── README.md             # 项目说明
```

## 🎯 下一步

项目已成功启动！你可以：

1. **测试核心功能**
   - 注册多个账号测试聊天
   - 创建群聊
   - 发送不同类型的消息

2. **自定义功能**
   - 修改主题颜色
   - 添加新的表情
   - 实现更多聊天功能

3. **扩展功能**
   - 添加语音视频通话
   - 实现红包功能
   - 开发小程序平台

4. **部署上线**
   - 配置生产环境
   - 部署到云服务器
   - 发布到应用商店

## 📞 获取帮助

如果遇到问题：
1. 查看控制台错误日志
2. 检查网络连接
3. 确认数据库服务运行
4. 查看本文档的常见问题部分

祝你开发顺利！🎉
