import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发现'),
      ),
      body: ListView(
        children: [
          // 朋友圈
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.photo_library,
                color: Colors.green,
                size: 28,
              ),
            ),
            title: const Text('朋友圈'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed(Routes.moment);
            },
          ),
          const Divider(height: 1),
          // 扫一扫
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.blue,
                size: 28,
              ),
            ),
            title: const Text('扫一扫'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 扫码功能
            },
          ),
          // 摇一摇
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.phone_android,
                color: Colors.purple,
                size: 28,
              ),
            ),
            title: const Text('摇一摇'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 摇一摇功能
            },
          ),
          const Divider(height: 16),
          // 附近的人
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.location_on,
                color: Colors.orange,
                size: 28,
              ),
            ),
            title: const Text('附近的人'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 附近的人功能
            },
          ),
          const Divider(height: 16),
          // 小程序
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.apps,
                color: Colors.teal,
                size: 28,
              ),
            ),
            title: const Text('小程序'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 小程序功能
            },
          ),
          const Divider(height: 16),
          // 游戏
          ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.sports_esports,
                color: Colors.red,
                size: 28,
              ),
            ),
            title: const Text('游戏'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 游戏功能
            },
          ),
        ],
      ),
    );
  }
}
