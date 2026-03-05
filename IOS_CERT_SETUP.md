# iOS 证书配置指南

## 需要准备的文件

1. **P12 证书文件**（.p12 或 .pfx）
2. **Provisioning Profile 文件**（.mobileprovision）
3. **证书密码**（P12 文件的导出密码）

## 步骤 1：转换文件为 Base64

### Windows PowerShell 命令

```powershell
# 转换 P12 证书
$certPath = "C:\path\to\your\certificate.p12"
$certBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($certPath))
$certBase64 | Out-File -FilePath "ios_p12_base64.txt" -Encoding ascii -NoNewline

# 转换 Provisioning Profile
$provPath = "C:\path\to\your\profile.mobileprovision"
$provBase64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($provPath))
$provBase64 | Out-File -FilePath "ios_mobileprovision_base64.txt" -Encoding ascii -NoNewline
```

## 步骤 2：添加到 GitHub Secrets

访问：https://github.com/ashun520/CHAT/settings/secrets/actions

添加以下 3 个 secrets：

### 1. IOS_P12_BASE64
- **名称**: `IOS_P12_BASE64`
- **值**: 复制 `ios_p12_base64.txt` 文件的全部内容

### 2. IOS_P12_PASSWORD
- **名称**: `IOS_P12_PASSWORD`
- **值**: 您的 P12 证书密码

### 3. IOS_MOBILE_PROVISION_BASE64
- **名称**: `IOS_MOBILE_PROVISION_BASE64`
- **值**: 复制 `ios_mobileprovision_base64.txt` 文件的全部内容

## 步骤 3：获取 Team ID（可选）

如果您需要配置 Bundle ID：

1. 打开 Apple Developer 账号：https://developer.apple.com/account
2. 点击右上角的会员资格
3. Team ID 会显示在页面顶部

## 验证配置

推送代码后，GitHub Actions 会自动：
1. 导入 P12 证书
2. 安装 Provisioning Profile
3. 签名并打包 IPA
4. 上传到 Release

## 注意事项

- ✅ P12 证书必须是**Distribution Certificate**（分发证书）
- ✅ Provisioning Profile 必须是**Ad Hoc**或**App Store**类型
- ✅ 确保 Provisioning Profile 包含您要安装的设备 UDID（Ad Hoc 模式）
- ✅ Bundle ID 必须与 Xcode 项目中的配置一致

## 获取设备 UDID

如果要安装到真机，需要设备 UDID：

1. 连接 iPhone 到电脑
2. 打开 iTunes（或 Finder on macOS）
3. 点击设备图标
4. 点击序列号区域，会显示 UDID
5. 复制 UDID 并添加到 Apple Developer 账号的设备列表

## 测试安装

构建成功后，下载 IPA 文件，使用以下方式安装：

### 方法 1：Xcode
1. 打开 Xcode
2. Window → Devices and Simulators
3. 选择设备
4. 拖入 IPA 文件

### 方法 2：AltStore（推荐）
1. 下载 AltStore：https://altstore.io
2. 安装 AltStore 到 iPhone
3. 使用 AltStore 打开 IPA 文件

### 方法 3：爱思助手
1. 下载爱思助手
2. 连接 iPhone
3. 导入 IPA 文件

## 常见问题

### Q: 证书导入失败？
A: 确保 P12 文件是正确的导出格式，密码正确。

### Q: 签名后仍然无法安装？
A: 检查 Provisioning Profile 是否包含设备 UDID。

### Q: 如何查看构建日志？
A: 访问 https://github.com/ashun520/CHAT/actions 查看详细日志。
