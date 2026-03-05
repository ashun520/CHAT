import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('联系人'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Get.toNamed(Routes.friendAdd);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '好友'),
            Tab(text: '群聊'),
            Tab(text: '公众号'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendList(),
          _buildGroupList(),
          _buildOfficialList(),
        ],
      ),
    );
  }

  Widget _buildFriendList() {
    return Column(
      children: [
        // 新的朋友
        ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_add,
              color: Colors.orange,
            ),
          ),
          title: const Text('新的朋友'),
          trailing: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          onTap: () {
            Get.toNamed(Routes.friendRequest);
          },
        ),
        const Divider(height: 1),
        // 群聊
        ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.group,
              color: Colors.green,
            ),
          ),
          title: const Text('群聊'),
          onTap: () {
            _tabController.animateTo(1);
          },
        ),
        const Divider(height: 1),
        // 标签
        ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.label_outline,
              color: Colors.blue,
            ),
          ),
          title: const Text('标签'),
        ),
        const Divider(height: 1),
        // 公众号
        ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.campaign_outlined,
              color: Colors.purple,
            ),
          ),
          title: const Text('公众号'),
          onTap: () {
            _tabController.animateTo(2);
          },
        ),
        const Divider(height: 1),
        // 好友列表
        Expanded(
          child: ListView.builder(
            itemCount: 10, // 模拟数据
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.grey[600]),
                ),
                title: Text('好友${index + 1}'),
                subtitle: Text('个性签名${index + 1}'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGroupList() {
    return ListView.builder(
      itemCount: 5, // 模拟数据
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(Icons.group, color: Theme.of(context).primaryColor),
          ),
          title: Text('测试群${index + 1}'),
          subtitle: Text('${(index + 1) * 10}人'),
        );
      },
    );
  }

  Widget _buildOfficialList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '暂无公众号',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
