import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';

class ChatProvider extends ChangeNotifier {
  List<dynamic> _conversations = [];
  List<dynamic> _messages = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;

  List<dynamic> get conversations => _conversations;
  List<dynamic> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  // 加载会话列表
  Future<void> loadConversations() async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: 调用 API 加载会话
      // final response = await ApiService.get(ApiConstants.conversations);
      
      // 模拟数据
      await Future.delayed(const Duration(seconds: 1));
      _conversations = [
        {
          '_id': '1',
          'type': 'private',
          'participants': [
            {'nickname': '张三', 'avatar': ''}
          ],
          'lastMessage': {
            'type': 'text',
            'content': {'text': '你好'}
          },
          'lastMessageAt': DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
          'unreadCount': 2,
        },
        {
          '_id': '2',
          'type': 'group',
          'group': {'name': '测试群', 'avatar': ''},
          'lastMessage': {
            'type': 'text',
            'content': {'text': '大家好'}
          },
          'lastMessageAt': DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
          'unreadCount': 0,
        },
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('加载会话失败：$e');
    }
  }

  // 加载聊天记录
  Future<void> loadMessages(String conversationId) async {
    try {
      _isLoading = true;
      _currentPage = 1;
      _hasMore = true;
      notifyListeners();

      // TODO: 调用 API 加载消息
      await Future.delayed(const Duration(seconds: 1));
      _messages = [];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('加载消息失败：$e');
    }
  }

  // 加载更多消息
  Future<void> loadMoreMessages(String conversationId) async {
    if (_isLoadingMore || !_hasMore) return;

    try {
      _isLoadingMore = true;
      _currentPage++;
      notifyListeners();

      // TODO: 调用 API 加载更多消息

      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
      debugPrint('加载更多消息失败：$e');
    }
  }

  // 发送消息
  Future<void> sendMessage({
    required String conversationId,
    required String type,
    required Map<String, dynamic> content,
    String? receiverId,
    String? groupId,
  }) async {
    try {
      // TODO: 通过 Socket 发送消息
      debugPrint('发送消息：$content');
      
      // 添加到本地消息列表
      final message = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'conversationId': conversationId,
        'type': type,
        'content': content,
        'sender': 'me',
        'createdAt': DateTime.now().toIso8601String(),
        'status': 'sent',
      };
      
      _messages.add(message);
      notifyListeners();
    } catch (e) {
      debugPrint('发送消息失败：$e');
    }
  }

  // 标记为已读
  Future<void> markAsRead(String conversationId) async {
    try {
      // TODO: 调用 API 标记已读
      debugPrint('标记已读：$conversationId');
    } catch (e) {
      debugPrint('标记已读失败：$e');
    }
  }

  // 清空消息列表
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}
