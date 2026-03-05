import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: ListView(
        children: [
          // 用户信息头部
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: user?.avatar?.isNotEmpty == true
                      ? ClipOval(
                          child: Image.network(
                            user!.avatar!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 40,
                                color: Theme.of(context).primaryColor,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.nickname ?? user?.username ?? '用户',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (user?.gender == 'male')
                            const Icon(Icons.male, color: Colors.blue, size: 16)
                          else if (user?.gender == 'female')
                            const Icon(Icons.female, color: Colors.pink, size: 16),
                          if (user?.gender != null && user!.gender.isNotEmpty)
                            const SizedBox(width: 8),
                          Text(
                            'ID: ${user?.id.substring(0, 8) ?? ''}...',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.qr_code),
                  onPressed: () {
                    // TODO: 显示二维码
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // TODO: 设置页面
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 朋友圈
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.photo_library,
                color: Colors.green,
              ),
            ),
            title: const Text('朋友圈'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed(Routes.moment);
            },
          ),
          const Divider(height: 1),
          // 收藏
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bookmark_outline,
                color: Colors.orange,
              ),
            ),
            title: const Text('收藏'),
            trailing: const Icon(Icons.chevron_right),
          ),
          // 文件
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.folder,
                color: Colors.blue,
              ),
            ),
            title: const Text('文件'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(height: 1),
          // 钱包
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: Colors.green,
              ),
            ),
            title: const Text('钱包'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(height: 16),
          // 设置
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Colors.grey,
              ),
            ),
            title: const Text('设置'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 设置页面
            },
          ),
          const Divider(height: 16),
          // 退出登录
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog(context, authProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '退出登录',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              if (context.mounted) {
                Get.offAllNamed(Routes.login);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );
  }
}
