# 构建指南

本指南将帮助你构建 SuperChat 的发布版本。

## 📱 Android APK 构建

### 环境准备

1. 确保已安装 Flutter SDK (>= 3.0.0)
2. 确保已配置 Android SDK 和 Android Studio
3. 接受 Android SDK 许可证：
   ```bash
   flutter doctor --android-licenses
   ```

### 构建调试版本

```bash
cd frontend
flutter build apk --debug
```

输出位置：`frontend/build/app/outputs/flutter-apk/app-debug.apk`

### 构建发布版本

```bash
cd frontend
flutter build apk --release
```

输出位置：`frontend/build/app/outputs/flutter-apk/app-release.apk`

### 构建分架构 APK（可选）

```bash
cd frontend
flutter build apk --split-per-abi
```

这将为不同的 CPU 架构生成多个 APK：
- `app-armeabi-v7a-release.apk` (32 位 ARM)
- `app-arm64-v8a-release.apk` (64 位 ARM)
- `app-x86_64-release.apk` (64 位 x86)

### 签名 APK

1. 生成签名密钥：
   ```bash
   keytool -genkey -v -keystore ~/superchat-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias superchat
   ```

2. 创建 `frontend/android/key.properties`：
   ```properties
   storePassword=<你的密码>
   keyPassword=<你的密码>
   keyAlias=superchat
   storeFile=<keystore 文件路径>
   ```

3. 修改 `frontend/android/app/build.gradle`：
   ```gradle
   android {
       ...
       signingConfigs {
           release {
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
               storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
               storePassword keystoreProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
           }
       }
   }
   ```

## 🍎 iOS IPA 构建

### 环境准备

1. macOS 操作系统
2. 安装 Xcode（最新版本）
3. 安装 Xcode 命令行工具：
   ```bash
   xcode-select --install
   ```
4. Apple Developer 账号（发布需要）

### 配置签名

1. 打开 `frontend/ios/Runner.xcworkspace` in Xcode
2. 选择 Runner 项目
3. 在 "Signing & Capabilities" 中：
   - 选择你的 Team
   - 设置 Bundle Identifier
   - 选择签名证书

### 构建 IPA（手动）

```bash
cd frontend

# 清理构建缓存
flutter clean

# 获取依赖
flutter pub get

# 构建 iOS 发布版本
flutter build ios --release --no-codesign
```

### 创建 IPA 文件

```bash
cd frontend

# 创建 Payload 目录
mkdir -p Payload

# 复制 Runner.app
cp -R build/ios/iphoneos/Runner.app Payload/

# 压缩为 IPA
zip -r SuperChat.ipa Payload

# 清理
rm -rf Payload
```

输出位置：`frontend/SuperChat.ipa`

### 使用 Xcode 归档（推荐）

1. 打开 `frontend/ios/Runner.xcworkspace`
2. 选择 `Product` > `Archive`
3. 在 Organizer 窗口中点击 `Distribute App`
4. 选择分发方式：
   - **Ad Hoc**: 测试设备
   - **App Store**: 提交到 App Store
   - **Development**: 开发测试
5. 按照向导完成签名和导出

## 🌐 Web 构建（计划中）

```bash
cd frontend
flutter build web --release
```

输出位置：`frontend/build/web/`

## 🖥️ 桌面应用构建

### macOS
```bash
cd frontend
flutter build macos --release
```

### Windows
```bash
cd frontend
flutter build windows --release
```

### Linux
```bash
cd frontend
flutter build linux --release
```

## 📊 构建优化

### 减小包体积

1. 移除未使用的依赖
2. 使用图片压缩
3. 按需加载资源
4. 启用代码混淆：
   ```bash
   flutter build apk --obfuscate --split-debug-info=/<project-info>/debug-info
   ```

### 提升性能

1. 启用 Tree Shaking Icons：
   ```yaml
   # pubspec.yaml
   flutter:
     uses-material-design: true
     generate: true
   ```

2. 优化图片格式（使用 WebP）
3. 延迟加载非关键资源

## 🔍 故障排除

### Android 构建失败

**问题**: SDK 版本不匹配
```bash
flutter doctor
```

**解决**: 更新 Android SDK 和构建工具

**问题**: 内存不足
```bash
# 修改 gradle.properties
org.gradle.jvmargs=-Xmx4096m
```

### iOS 构建失败

**问题**: 签名错误
- 检查 Bundle Identifier 是否唯一
- 检查证书是否有效
- 检查设备是否已注册（Ad Hoc）

**问题**: CocoaPods 错误
```bash
cd ios
pod deintegrate
pod install
```

## 📦 自动化构建

### 使用 Fastlane

1. 安装 Fastlane：
   ```bash
   sudo gem install fastlane
   ```

2. 配置 Fastlane：
   ```bash
   cd frontend
   fastlane init
   ```

3. 构建 Android：
   ```bash
   cd frontend
   fastlane android build
   ```

4. 构建 iOS：
   ```bash
   cd frontend
   fastlane ios build
   ```

### GitHub Actions

项目已配置 GitHub Actions，自动构建：
- 推送标签时自动构建（如 `v1.0.0`）
- 手动触发构建
- 自动生成 Release 和上传构建产物

详见 `.github/workflows/` 目录。

## 📱 测试构建

### 安装 Android APK
```bash
flutter install
# 或
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 安装 iOS IPA
- 使用 Xcode
- 使用 TestFlight
- 使用第三方分发平台（蒲公英、fir.im）

## 🎯 发布检查清单

发布前请检查：

- [ ] 所有功能测试通过
- [ ] 性能测试通过
- [ ] 已配置正确的应用图标
- [ ] 已配置启动屏
- [ ] 版本号已更新
- [ ] 已签署发布版本
- [ ] 隐私政策已准备
- [ ] 用户协议已准备
- [ ] 截图和描述已准备

## 📝 版本命名

遵循语义化版本规范：

- **主版本号**: 重大更新，不兼容的 API 修改
- **次版本号**: 新功能，向后兼容
- **修订号**: Bug 修复，向后兼容

示例：`v1.2.3`

---

**祝你构建顺利！** 🚀
