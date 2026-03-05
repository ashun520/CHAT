import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import '../../providers/socket_provider.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late String conversationId;
  late String conversationType;
  late String title;
  late String avatar;
  bool _isTyping = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = Get.arguments as Map<String, dynamic>;
    conversationId = args['conversationId'];
    conversationType = args['conversationType'];
    title = args['title'];
    avatar = args['avatar'];
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    await chatProvider.loadMessages(conversationId);
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);

    // 发送消息
    socketProvider.sendMessage(
      conversationId: conversationId,
      type: MessageType.text,
      content: {'text': text},
      callback: (response) {
        if (response['success']) {
          _messageController.clear();
          _scrollToBottom();
        }
      },
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar.isNotEmpty)
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: ClipOval(
                  child: Image.network(
                    avatar,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        conversationType == 'group' ? Icons.group : Icons.person,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ),
              )
            else
              CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(
                  conversationType == 'group' ? Icons.group : Icons.person,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // TODO: 聊天设置
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 消息列表
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (chatProvider.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '暂无消息',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return _MessageBubble(message: message);
                  },
                );
              },
            ),
          ),

          // 输入区域
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 更多功能按钮
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              _showMoreMenu();
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          // 表情按钮
          IconButton(
            icon: const Icon(Icons.emoji_emotions_outlined),
            onPressed: () {
              // TODO: 显示表情选择器
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          // 输入框
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: '发消息...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onChanged: (text) {
                  setState(() {
                    _isTyping = text.isNotEmpty;
                  });
                },
                onSubmitted: (_) {
                  _sendMessage(_messageController.text);
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 发送按钮
          GestureDetector(
            onTap: _messageController.text.trim().isEmpty
                ? null
                : () => _sendMessage(_messageController.text),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _messageController.text.trim().isEmpty
                    ? Colors.grey[300]
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '发送',
                style: TextStyle(
                  color: _messageController.text.trim().isEmpty
                      ? Colors.grey
                      : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _GridItem(icon: Icons.photo_library, label: '相册'),
            _GridItem(icon: Icons.camera_alt, label: '拍摄'),
            _GridItem(icon: Icons.folder, label: '文件'),
            _GridItem(icon: Icons.videocam, label: '视频'),
            _GridItem(icon: Icons.mic, label: '语音'),
            _GridItem(icon: Icons.location_on, label: '位置'),
            _GridItem(icon: Icons.contact_phone, label: '联系人'),
            _GridItem(icon: Icons.redo, label: '红包'),
          ],
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _GridItem({Key? key, required this.icon, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final dynamic message;

  const _MessageBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMe = message['sender'] == 'me' || message['isSelf'] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: Radius.circular(isMe ? 12 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message['content']?['text'] ?? '',
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(message['createdAt']),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(String? timeString) {
    if (timeString == null) return '';
    try {
      final time = DateTime.parse(timeString).toLocal();
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}
