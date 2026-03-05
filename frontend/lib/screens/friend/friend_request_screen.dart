import 'package:flutter/material.dart';

class FriendRequestScreen extends StatelessWidget {
  const FriendRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新的朋友'),
      ),
      body: ListView(
        children: [
          // 新的朋友请求
          ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
            title: const Text('张三'),
            subtitle: const Text('我想加你为好友'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    // 接受
                  },
                  child: const Text('接受'),
                ),
                OutlinedButton(
                  onPressed: () {
                    // 拒绝
                  },
                  child: const Text('拒绝'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 更多请求...
        ],
      ),
    );
  }
}

class FriendAddScreen extends StatefulWidget {
  const FriendAddScreen({Key? key}) : super(key: key);

  @override
  State<FriendAddScreen> createState() => _FriendAddScreenState();
}

class _FriendAddScreenState extends State<FriendAddScreen> {
  final _searchController = TextEditingController();
  String _searchType = 'all'; // all, username, email, phone

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加朋友'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '搜索账号/昵称/手机号',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onSubmitted: (_) {
                      // TODO: 搜索用户
                    },
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  initialValue: _searchType,
                  onSelected: (value) {
                    setState(() {
                      _searchType = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'all', child: Text('全部')),
                    const PopupMenuItem(value: 'username', child: Text('用户名')),
                    const PopupMenuItem(value: 'email', child: Text('邮箱')),
                    const PopupMenuItem(value: 'phone', child: Text('手机号')),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                // 搜索历史
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('搜索历史'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      // 清除历史
                    },
                  ),
                ),
                const Divider(height: 1),
                // 推荐好友
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('推荐好友'),
                  trailing: const Icon(Icons.chevron_right),
                ),
                const Divider(height: 1),
                // 手机联系人
                ListTile(
                  leading: const Icon(Icons.contacts),
                  title: const Text('手机联系人'),
                  trailing: const Icon(Icons.chevron_right),
                ),
                const Divider(height: 1),
                // 公众号
                ListTile(
                  leading: const Icon(Icons.campaign),
                  title: const Text('公众号'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
