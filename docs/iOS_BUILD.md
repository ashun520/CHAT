# iOS 构建配置指南

## 📋 前置要求

1. **macOS 电脑** - 必须是 macOS 系统
2. **Xcode** - 从 App Store 安装最新版本
3. **Apple Developer 账号** - 免费或付费账号
4. **Flutter SDK** - 已安装并配置

## 🔧 配置步骤

### 1. 安装 Xcode 和命令行工具

```bash
# 安装 Xcode（从 App Store）
# 然后安装命令行工具
xcode-select --install
```

### 2. 配置 Xcode

打开 Xcode，同意许可协议：
```bash
sudo xcodebuild -license accept
```

### 3. 验证 Flutter iOS 配置

```bash
cd frontend
flutter doctor
```

确保看到：
```
[✓] iOS toolchain - develop for iOS devices
```

### 4. 安装 CocoaPods

```bash
sudo gem install cocoapods
cd frontend/ios
pod setup
```

### 5. 配置签名证书

#### 方法一：自动签名（推荐）

1. 打开 `frontend/ios/Runner.xcworkspace`
2. 选择左侧 Runner 项目
3. 选择 TARGETS > Runner
4. 切换到 "Signing & Capabilities" 标签
5. 勾选 "Automatically manage signing"
6. 选择你的 Team（需要登录 Apple ID）

#### 方法二：手动签名

1. 登录 [Apple Developer](https://developer.apple.com)
2. 创建证书：
   - Certificates, IDs & Profiles
   - Certificates > + > iOS Distribution
3. 下载并双击安装证书
4. 创建 App ID
5. 创建 Provisioning Profile
6. 下载并双击安装 Profile

### 6. 修改 Bundle ID

在 `frontend/ios/Runner.xcworkspace` 中：
1. 选择 Runner 项目
2. 选择 TARGETS > Runner
3. 修改 "Bundle Identifier"
4. 确保与 Apple Developer 后台的 App ID 一致

### 7. 配置能力（Capabilities）

根据需要添加：
- Push Notifications（推送通知）
- Background Modes（后台模式）
- Associated Domains（通用链接）

## 🏗️ 构建 IPA

### 方法一：使用 Flutter 命令

```bash
cd frontend

# 清理
flutter clean

# 获取依赖
flutter pub get

# 构建
flutter build ios --release
```

构建产物在：`build/ios/iphoneos/Runner.app`

### 方法二：使用 Xcode 归档

1. 打开 `frontend/ios/Runner.xcworkspace`
2. 选择 "Any iOS Device (arm64)" 或真机
3. 菜单：Product > Archive
4. 等待归档完成
5. 在 Organizer 窗口中选择归档
6. 点击 "Distribute App"
7. 选择分发方式：
   - **App Store Connect**: 提交审核
   - **Ad Hoc**: 测试设备
   - **Development**: 开发测试
8. 按照向导完成
9. 导出 IPA 文件

## 📱 分发方式

### 1. App Store

要求：
- 付费开发者账号（$99/年）
- App Store Connect 配置
- 应用审核

步骤：
1. 在 App Store Connect 创建应用
2. 填写应用信息
3. 上传 IPA（使用 Xcode 或 Transporter）
4. 提交审核
5. 发布

### 2. TestFlight

要求：
- 付费开发者账号
- TestFlight 配置

步骤：
1. 在 App Store Connect 配置 TestFlight
2. 上传构建版本
3. 添加内部/外部测试员
4. 发送邀请

### 3. Ad Hoc

要求：
- 付费开发者账号
- 注册测试设备 UDID

步骤：
1. 在 Apple Developer 注册设备 UDID
2. 创建 Ad Hoc Provisioning Profile
3. 使用 Ad Hoc Profile 构建 IPA
4. 分发 IPA 和 Profile
5. 用户通过 iTunes 或第三方工具安装

### 4. Enterprise（企业分发）

要求：
- 企业开发者账号（$299/年）

步骤：
1. 创建 Enterprise Certificate
2. 创建 Enterprise Provisioning Profile
3. 构建 IPA
4. 自行分发

### 5. 第三方分发平台

- **蒲公英**: https://www.pgyer.com
- **fir.im**: https://fir.im
- **TestFlight**: Apple 官方

## 🔍 故障排除

### 问题：No provisioning profiles found

**解决**：
1. 打开 Xcode > Preferences > Accounts
2. 选择账号，点击 "Download Manual Profiles"
3. 或重新创建 Provisioning Profile

### 问题：Code signing failed

**解决**：
1. 检查 Bundle ID 是否正确
2. 检查证书是否有效
3. 检查 Provisioning Profile 是否匹配
4. 清理并重新构建：
   ```bash
   flutter clean
   flutter pub get
   cd ios
   pod deintegrate
   pod install
   ```

### 问题：Unable to find matching provisioning profiles

**解决**：
1. 在 Apple Developer 后台检查设备 UDID 是否已注册
2. 重新下载并安装 Provisioning Profile
3. 在 Xcode 中重新选择 Profile

### 问题：Flutter build ios 失败

**解决**：
```bash
# 检查 Xcode 配置
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 清除 CocoaPods 缓存
pod cache clean --all

# 重新安装 Pods
cd ios
pod deintegrate
pod install
```

## 📊 构建优化

### 减小 IPA 体积

1. 移除未使用的架构：
   ```bash
   # 只构建 arm64
   flutter build ios --release --target-platform=ios-arm64
   ```

2. 压缩图片资源
3. 使用 App Thinning
4. 移除未使用的代码和资源

### 提升启动速度

1. 延迟初始化
2. 减少主线程工作
3. 使用异步加载
4. 优化首屏渲染

## 🎯 发布前检查

- [ ] 应用名称正确
- [ ] 版本号已更新
- [ ] 图标已更新
- [ ] 启动屏已配置
- [ ] 权限描述已添加
- [ ] 隐私政策已准备
- [ ] 测试通过
- [ ] 性能优化完成

## 📝 权限配置

在 `frontend/ios/Runner/Info.plist` 中添加：

```xml
<!-- 相机权限 -->
<key>NSCameraUsageDescription</key>
<string>需要使用相机拍摄照片和视频</string>

<!-- 相册权限 -->
<key>NSPhotoLibraryUsageDescription</key>
<string>需要访问相册选择照片</string>

<!-- 麦克风权限 -->
<key>NSMicrophoneUsageDescription</key>
<string>需要使用麦克风录制音频</string>

<!-- 位置权限 -->
<key>NSLocationWhenInUseUsageDescription</key>
<string>需要获取位置信息</string>

<!-- 通知权限 -->
<key>NSUserNotificationsUsageDescription</key>
<string>需要发送通知消息</string>
```

## 🔐 安全建议

1. **启用 ATS**（App Transport Security）
2. **使用 HTTPS** 进行网络请求
3. **加密敏感数据**
4. **代码混淆**
5. **越狱检测**（可选）

## 📚 相关资源

- [Flutter iOS 部署文档](https://flutter.dev/docs/deployment/ios)
- [Apple Developer 文档](https://developer.apple.com/documentation)
- [App Store 审核指南](https://developer.apple.com/app-store/review/guidelines/)
- [TestFlight 使用指南](https://developer.apple.com/testflight/)

---

**祝你发布顺利！** 🚀
