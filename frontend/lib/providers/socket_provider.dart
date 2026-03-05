import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import '../config/constants.dart';
import '../services/storage_service.dart';

class SocketProvider extends ChangeNotifier {
  IO.Socket? _socket;
  bool _isConnected = false;
  bool _isConnecting = false;

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;

  // 连接 Socket.IO
  Future<void> connect() async {
    if (_isConnected || _isConnecting) return;

    try {
      _isConnecting = true;
      notifyListeners();

      final token = StorageService.getToken();
      if (token == null) {
        throw Exception('未登录');
      }

      _socket = IO.io(
        ApiConstants.socketUrl,
        IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
      );

      // 添加认证 token
      _socket!.auth = {'token': token};

      // 连接事件
      _socket!.onConnect((_) {
        debugPrint('Socket 连接成功');
        _isConnected = true;
        _isConnecting = false;
        notifyListeners();
      });

      // 断开连接事件
      _socket!.onDisconnect((_) {
        debugPrint('Socket 断开连接');
        _isConnected = false;
        _isConnecting = false;
        notifyListeners();
      });

      // 连接错误
      _socket!.onConnectError((error) {
        debugPrint('Socket 连接错误：$error');
        _isConnecting = false;
        notifyListeners();
      });

      // 新用户消息
      _socket!.on('message:new', (data) {
        debugPrint('收到新消息：$data');
        // TODO: 更新消息列表
      });

      // 消息已读
      _socket!.on('message:read', (data) {
        debugPrint('消息已读：$data');
        // TODO: 更新消息状态
      });

      // 用户上线
      _socket!.on('user:online', (data) {
        debugPrint('用户上线：${data['username']}');
        // TODO: 更新好友状态
      });

      // 用户下线
      _socket!.on('user:offline', (data) {
        debugPrint('用户下线：${data['username']}');
        // TODO: 更新好友状态
      });

      // 输入状态
      _socket!.on('typing:update', (data) {
        debugPrint('输入状态更新：$data');
        // TODO: 显示输入提示
      });

      // 群聊邀请
      _socket!.on('group:invite', (data) {
        debugPrint('收到群聊邀请');
        // TODO: 显示群聊邀请
      });

      // 建立连接
      _socket!.connect();
    } catch (e) {
      debugPrint('Socket 连接失败：$e');
      _isConnecting = false;
      notifyListeners();
    }
  }

  // 断开连接
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
      _isConnected = false;
      _isConnecting = false;
      notifyListeners();
    }
  }

  // 发送消息
  void sendMessage({
    required String conversationId,
    required String type,
    required Map<String, dynamic> content,
    String? receiverId,
    String? groupId,
    String? replyTo,
    List<String>? mentions,
    Function(dynamic)? callback,
  }) {
    if (!_isConnected || _socket == null) {
      debugPrint('Socket 未连接');
      return;
    }

    _socket!.emit('message:send', {
      'conversationId': conversationId,
      'type': type,
      'content': content,
      'receiverId': receiverId,
      'groupId': groupId,
      'replyTo': replyTo,
      'mentions': mentions,
    }, (response) {
      if (callback != null) {
        callback(response);
      }
    });
  }

  // 标记消息已读
  void markAsRead(String conversationId) {
    if (!_isConnected || _socket == null) return;

    _socket!.emit('message:read', {
      'conversationId': conversationId,
    });
  }

  // 开始输入
  void startTyping(String conversationId, {String? receiverId, String? groupId}) {
    if (!_isConnected || _socket == null) return;

    _socket!.emit('typing:start', {
      'conversationId': conversationId,
      'receiverId': receiverId,
      'groupId': groupId,
    });
  }

  // 结束输入
  void endTyping(String conversationId, {String? receiverId, String? groupId}) {
    if (!_isConnected || _socket == null) return;

    _socket!.emit('typing:end', {
      'conversationId': conversationId,
      'receiverId': receiverId,
      'groupId': groupId,
    });
  }

  // 创建群聊
  void createGroup({
    required String name,
    String? avatar,
    required List<String> memberIds,
    Function(dynamic)? callback,
  }) {
    if (!_isConnected || _socket == null) return;

    _socket!.emit('group:create', {
      'name': name,
      'avatar': avatar,
      'memberIds': memberIds,
    }, (response) {
      if (callback != null) {
        callback(response);
      }
    });
  }

  // 重连
  void reconnect() {
    disconnect();
    Future.delayed(const Duration(seconds: 1), () {
      connect();
    });
  }
}
