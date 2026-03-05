import 'package:flutter/material.dart';

class GroupCreateScreen extends StatelessWidget {
  const GroupCreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建群聊'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('选择联系人'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 选择联系人
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('群名称'),
            subtitle: const Text('给群聊起个名字'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 输入群名称
            },
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('群头像'),
            subtitle: const Text('设置群聊头像'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 选择群头像
            },
          ),
          const Divider(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: 创建群聊
                },
                child: const Text('创建'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupInfoScreen extends StatelessWidget {
  const GroupInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('群聊信息'),
      ),
      body: ListView(
        children: [
          // 群头像和名称
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(Icons.group, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '测试群',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '10 人',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 群公告
          ListTile(
            title: const Text('群公告'),
            subtitle: const Text('暂无公告'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(height: 1),
          // 群管理
          ListTile(
            title: const Text('群管理'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(height: 16),
          // 聊天设置
          ListTile(
            title: const Text('消息免打扰'),
            trailing: Switch(value: false, onChanged: (_) {}),
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('置顶聊天'),
            trailing: Switch(value: false, onChanged: (_) {}),
          ),
          const Divider(height: 16),
          // 成员列表
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '群成员 (10)',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          // ... 成员列表
          const Divider(height: 16),
          // 退出群聊
          ListTile(
            title: const Text('退出群聊', style: TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: 退出群聊
            },
          ),
        ],
      ),
    );
  }
}
