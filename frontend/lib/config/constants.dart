class ApiConstants {
  // API 基础 URL - 开发环境
  static const String baseUrl = 'http://10.0.2.2:3000/api'; // Android 模拟器
  
  // 生产环境请改为实际 IP 或域名
  // static const String baseUrl = 'https://your-domain.com/api';
  
  // API 端点
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String userInfo = '/auth/me';
  static const String updateUserInfo = '/auth/me';
  static const String changePassword = '/auth/password';
  
  // 聊天相关
  static const String conversations = '/chat/conversations';
  static const String messages = '/chat/messages';
  static const String markAsRead = '/chat/read';
  static const String deleteMessage = '/chat/messages';
  
  // 好友相关
  static const String friends = '/friends/friends';
  static const String searchUsers = '/friends/search';
  static const String sendFriendRequest = '/friends/requests/send';
  static const String getFriendRequests = '/friends/requests';
  static const String handleFriendRequest = '/friends/requests/handle';
  static const String removeFriend = '/friends/friends';
  static const String blacklist = '/friends/blacklist';
  
  // 文件上传
  static const String upload = '/upload';
  
  // Socket.IO URL
  static const String socketUrl = 'http://10.0.2.2:3000';
}

// 错误消息映射
class ErrorMessages {
  static const Map<int, String> messages = {
    400: '请求参数错误',
    401: '未授权，请重新登录',
    403: '无权限访问',
    404: '资源不存在',
    409: '资源冲突',
    500: '服务器内部错误',
    502: '网关错误',
    503: '服务不可用',
    504: '网关超时',
  };
  
  static String getMessage(int code) {
    return messages[code] ?? '未知错误';
  }
}
