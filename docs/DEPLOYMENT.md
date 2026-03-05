# GitHub 部署指南

本指南将帮助你将 SuperChat 部署到 GitHub，并配置自动构建 IPA。

## 📋 前置要求

1. **GitHub 账号** - 已注册 GitHub
2. **Git** - 已安装 Git
3. **macOS** - 构建 iOS IPA 需要 macOS 系统（或使用 GitHub Actions）

## 🚀 部署步骤

### 步骤 1：创建 GitHub 仓库

1. 登录 GitHub
2. 点击右上角 "+" > "New repository"
3. 填写信息：
   - Repository name: `SuperChat`
   - Description: "一个功能强大的跨平台聊天应用"
   - 选择 **Public** 或 **Private**
   - **不要** 勾选 "Initialize this repository with a README"
4. 点击 "Create repository"

### 步骤 2：初始化本地仓库

在项目根目录执行：

```bash
cd e:\cangku\ruanjian\SuperChat

# 初始化 Git 仓库
git init

# 添加所有文件
git add .

# 提交
git commit -m "Initial commit: SuperChat v1.0.0

- 完整的聊天应用后端（Node.js + Express + Socket.IO）
- Flutter 跨平台前端（iOS & Android）
- 用户系统、聊天、好友、群聊功能
- 朋友圈、文件传输、实时消息推送
- GitHub Actions 自动构建配置"
```

### 步骤 3：关联远程仓库

```bash
# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/SuperChat.git

# 重命名分支为 main
git branch -M main

# 推送到 GitHub
git push -u origin main
```

### 步骤 4：验证推送

1. 打开 GitHub 仓库页面
2. 确认所有文件已上传
3. 检查 README.md 是否正确显示

### 步骤 5：配置 GitHub Secrets（可选）

如果需要自动发布到 App Store，需要配置 Secrets：

1. 进入仓库 Settings
2. 选择 "Secrets and variables" > "Actions"
3. 点击 "New repository secret"
4. 添加以下 Secrets：

```
# Apple Developer 账号（用于签名）
APPLE_DEVELOPER_EMAIL=your-email@example.com
APPLE_APP_SPECIFIC_PASSWORD=your-app-specific-password
APPLE_TEAM_ID=your-team-id
```

### 步骤 6：触发自动构建

#### 方式一：推送标签触发

```bash
# 创建版本标签
git tag v1.0.0

# 推送标签
git push origin v1.0.0
```

#### 方式二：手动触发

1. 进入仓库 Actions 标签
2. 选择 "Build iOS IPA" 或 "Build Android APK"
3. 点击 "Run workflow"
4. 选择分支
5. 点击 "Run workflow"

### 步骤 7：下载构建产物

构建完成后：

1. 进入 Actions 标签
2. 选择已完成的 workflow
3. 在 "Artifacts" 部分下载 IPA 或 APK
4. 如果配置了 Release，会在 Releases 页面下载

## 📱 iOS IPA 构建说明

### 使用 GitHub Actions 构建（推荐）

项目已配置自动构建工作流：

**文件**: `.github/workflows/build-ios.yml`

**触发条件**:
- 推送标签（如 `v1.0.0`）
- 手动触发

**构建产物**:
- IPA 文件（30 天有效期）
- 自动创建 GitHub Release

### 本地构建 IPA（需要 macOS）

如果你在 macOS 上，可以本地构建：

```bash
cd frontend

# 清理
flutter clean

# 获取依赖
flutter pub get

# 构建
flutter build ios --release

# 创建 IPA
mkdir -p Payload
cp -R build/ios/iphoneos/Runner.app Payload/
zip -r SuperChat.ipa Payload
```

### 签名和分发

构建的 IPA 需要签名才能安装到设备：

#### 方式一：Xcode 签名

1. 打开 `frontend/ios/Runner.xcworkspace`
2. 配置签名证书
3. Product > Archive
4. Distribute App
5. 选择分发方式

#### 方式二：使用第三方签名工具

- [signipa](https://github.com/abner/signipa)
- [ios-app-signer](https://github.com/DanTheMan827/ios-app-signer)

#### 方式三：企业分发

使用企业证书签名后，可以直接分发 IPA。

## 🤖 Android APK 构建

### GitHub Actions 构建

工作流文件：`.github/workflows/build-android.yml`

### 本地构建

```bash
cd frontend

# 构建 APK
flutter build apk --release

# 或构建分架构 APK
flutter build apk --split-per-abi
```

构建产物：
- `build/app/outputs/flutter-apk/app-release.apk`

## 🔍 故障排除

### 问题：Git 推送失败

**错误**: `remote: Repository not found`

**解决**:
```bash
# 检查远程仓库 URL
git remote -v

# 如果错误，删除并重新添加
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/SuperChat.git
```

### 问题：GitHub Actions 失败

**检查**:
1. Actions 是否已启用
2. 工作流文件语法是否正确
3. 查看日志了解具体错误

**常见错误**:
- Flutter 版本不匹配
- 依赖安装失败
- 构建配置错误

### 问题：IPA 无法安装

**原因**:
- 未签名或签名无效
- 设备未注册（Ad Hoc）
- 证书过期

**解决**:
1. 检查签名配置
2. 使用 TestFlight 分发
3. 重新签名 IPA

### 问题：构建时间过长

**优化**:
1. 启用 GitHub Actions 缓存
2. 减少不必要的依赖
3. 使用预构建镜像

## 📊 GitHub Actions 配置说明

### iOS 构建工作流

```yaml
name: Build iOS IPA

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build ios --release
      - uses: actions/upload-artifact@v3
```

### Android 构建工作流

```yaml
name: Build Android APK

on:
  push:
    tags:
      - 'v*'
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
```

## 🎯 最佳实践

### 1. 版本管理

- 使用语义化版本（SemVer）
- 每次发布创建标签
- 编写详细的 Release Notes

### 2. 分支策略

- `main`: 生产环境代码
- `develop`: 开发分支
- `feature/*`: 功能分支
- `release/*`: 发布分支

### 3. CI/CD 流程

```
开发 → 测试 → 预发布 → 生产
  ↓      ↓       ↓       ↓
feature → develop → release → main
                      ↓
                  自动构建
                      ↓
                  自动发布
```

### 4. 代码质量

- 启用 GitHub Code Review
- 配置 Branch Protection
- 要求 PR 审核
- 运行自动化测试

## 📝 发布清单

发布新版本前检查：

- [ ] 所有功能测试通过
- [ ] 版本号已更新（pubspec.yaml 和 package.json）
- [ ] CHANGELOG.md 已更新
- [ ] README.md 已更新
- [ ] 创建 Git 标签
- [ ] 推送标签触发构建
- [ ] 下载并测试 IPA/APK
- [ ] 创建 GitHub Release
- [ ] 更新文档

## 🔗 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Flutter 部署指南](https://flutter.dev/docs/deployment)
- [iOS 发布指南](https://developer.apple.com/distribute/)
- [Google Play 发布指南](https://developer.android.com/distribute)

## 📞 获取帮助

- GitHub Issues: 报告问题
- GitHub Discussions: 讨论和交流
- 文档：查看项目文档

---

**祝你部署顺利！** 🚀
