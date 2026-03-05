import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../config/routes.dart';
import '../../providers/chat_provider.dart';
import '../../models/conversation_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('聊天'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showCreateMenu();
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (chatProvider.conversations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无聊天',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '开始新的聊天吧',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadConversations,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8),
              itemCount: chatProvider.conversations.length,
              itemBuilder: (context, index) {
                final conversation = chatProvider.conversations[index];
                return _ConversationTile(conversation: conversation);
              },
            ),
          );
        },
      ),
    );
  }

  void _showCreateMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('发起聊天'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 选择联系人
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_add),
              title: const Text('创建群聊'),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed(Routes.groupCreate);
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('扫一扫'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 扫码
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;

  const _ConversationTile({Key? key, required this.conversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: conversation.avatar.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      conversation.avatar,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          conversation.isGroup ? Icons.group : Icons.person,
                          color: Theme.of(context).primaryColor,
                        );
                      },
                    ),
                  )
                : Icon(
                    conversation.isGroup ? Icons.group : Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
          ),
          if (conversation.unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  conversation.unreadCount > 99 ? '99+' : '${conversation.unreadCount}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      title: Text(
        conversation.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: conversation.unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        conversation.lastMessageText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: conversation.unreadCount > 0 
              ? Theme.of(context).primaryColor 
              : Colors.grey[600],
          fontWeight: conversation.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: Text(
        conversation.lastMessageTimeText,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      onTap: () {
        Get.toNamed(
          Routes.chat,
          arguments: {
            'conversationId': conversation.id,
            'conversationType': conversation.type,
            'title': conversation.title,
            'avatar': conversation.avatar,
          },
        );
      },
      onLongPress: () {
        _showMenu(context);
      },
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_off),
              title: const Text('置顶聊天'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 置顶聊天
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off),
              title: const Text('消息免打扰'),
              onTap: () {
                Navigator.pop(context);
                // TODO: 免打扰
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('删除聊天', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // TODO: 删除聊天
              },
            ),
          ],
        ),
      ),
    );
  }
}
