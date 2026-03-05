import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationModel {
  final String id;
  final String type; // 'private' or 'group'
  final String title;
  final String avatar;
  final String lastMessageText;
  final String lastMessageTimeText;
  final int unreadCount;
  final DateTime lastMessageTime;

  ConversationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.avatar,
    required this.lastMessageText,
    required this.lastMessageTimeText,
    required this.unreadCount,
    required this.lastMessageTime,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'private',
      title: _extractTitle(json),
      avatar: _extractAvatar(json),
      lastMessageText: _extractLastMessageText(json),
      lastMessageTimeText: _formatTime(json['lastMessageAt']),
      unreadCount: _extractUnreadCount(json),
      lastMessageTime: json['lastMessageAt'] != null 
          ? DateTime.parse(json['lastMessageAt']).toLocal() 
          : DateTime.now(),
    );
  }

  static String _extractTitle(Map<String, dynamic> json) {
    if (json['type'] == 'group') {
      return json['group']?['name'] ?? '群聊';
    } else {
      // 私聊 - 获取对方名称
      final participants = json['participants'] as List?;
      if (participants != null && participants.length > 1) {
        // 排除自己，获取对方名称
        // 这里简化处理，实际应该根据当前用户 ID 过滤
        return participants.first['nickname'] ?? 
               participants.first['username'] ?? 
               '未知用户';
      }
      return '未知会话';
    }
  }

  static String _extractAvatar(Map<String, dynamic> json) {
    if (json['type'] == 'group') {
      return json['group']?['avatar'] ?? '';
    } else {
      final participants = json['participants'] as List?;
      if (participants != null && participants.length > 1) {
        return participants.first['avatar'] ?? '';
      }
      return '';
    }
  }

  static String _extractLastMessageText(Map<String, dynamic> json) {
    final lastMessage = json['lastMessage'];
    if (lastMessage == null) return '暂无消息';
    
    switch (lastMessage['type']) {
      case 'text':
        return lastMessage['content']?['text'] ?? '[文本消息]';
      case 'image':
        return '[图片]';
      case 'video':
        return '[视频]';
      case 'audio':
        return '[语音]';
      case 'file':
        return '[文件]';
      case 'emoji':
        return '[表情]';
      default:
        return '[消息]';
    }
  }

  static int _extractUnreadCount(Map<String, dynamic> json) {
    final unreadCount = json['unreadCount'];
    if (unreadCount == null) return 0;
    return unreadCount is int ? unreadCount : 0;
  }

  static String _formatTime(String? timeString) {
    if (timeString == null) return '';
    
    try {
      final time = DateTime.parse(timeString).toLocal();
      final now = DateTime.now();
      final diff = now.difference(time);
      
      if (diff.inMinutes < 1) {
        return '刚刚';
      } else if (diff.inMinutes < 60) {
        return '${diff.inMinutes}分钟前';
      } else if (diff.inHours < 24) {
        return '${diff.inHours}小时前';
      } else if (diff.inDays < 7) {
        return '${diff.inDays}天前';
      } else {
        return '${time.month}-${time.day}';
      }
    } catch (e) {
      return '';
    }
  }

  bool get isGroup => type == 'group';
}
