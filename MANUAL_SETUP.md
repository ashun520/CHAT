# 手动添加 GitHub Secrets 指南

## 📋 步骤 1：打开 GitHub Secrets 页面

**点击这里访问：** https://github.com/ashun520/CHAT/settings/secrets/actions

---

## 📋 步骤 2：添加第 1 个 Secret

1. 点击 **"New repository secret"** 按钮

2. **Name** 字段输入：`IOS_P12_BASE64`

3. **Value** 字段：
   - 打开文件：`e:\cangku\ruanjian\SuperChat\ios_p12_base64.txt`
   - 按 `Ctrl+A` 全选
   - 按 `Ctrl+C` 复制
   - 粘贴到 Value 字段

4. 点击 **"Add secret"** 按钮

---

## 📋 步骤 3：添加第 2 个 Secret

1. 点击 **"New repository secret"** 按钮

2. **Name** 字段输入：`IOS_P12_PASSWORD`

3. **Value** 字段输入：`1`

4. 点击 **"Add secret"** 按钮

---

## 📋 步骤 4：添加第 3 个 Secret

1. 点击 **"New repository secret"** 按钮

2. **Name** 字段输入：`IOS_MOBILE_PROVISION_BASE64`

3. **Value** 字段：
   - 打开文件：`e:\cangku\ruanjian\SuperChat\ios_mobileprovision_base64.txt`
   - 按 `Ctrl+A` 全选
   - 按 `Ctrl+C` 复制
   - 粘贴到 Value 字段

4. 点击 **"Add secret"** 按钮

---

## ✅ 完成！

现在您应该有 3 个 Secrets：
- ✅ IOS_P12_BASE64
- ✅ IOS_P12_PASSWORD
- ✅ IOS_MOBILE_PROVISION_BASE64

---

## 🚀 下一步：触发构建

1. **访问：** https://github.com/ashun520/CHAT/actions

2. 点击左侧的 **"Build iOS IPA"**

3. 点击右上角的 **"Run workflow"** 按钮

4. **Branch** 选择：`main`

5. 点击 **"Run workflow"**

6. 等待 5-10 分钟，构建完成后会显示绿色 ✓

---

## 📥 下载 IPA

构建成功后：

1. 访问：https://github.com/ashun520/CHAT/releases

2. 下载最新的 IPA 文件

3. 使用爱思助手安装到 iPhone

---

**就这么简单！** 如果有任何问题，请告诉我具体的错误信息。
