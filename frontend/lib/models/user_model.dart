class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final String? avatar;
  final String nickname;
  final String gender;
  final String? signature;
  final String status;
  final DateTime? lastSeen;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    this.avatar,
    required this.nickname,
    required this.gender,
    this.signature,
    required this.status,
    this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      nickname: json['nickname'] ?? json['username'] ?? '',
      gender: json['gender'] ?? 'other',
      signature: json['signature'],
      status: json['status'] ?? 'offline',
      lastSeen: json['lastSeen'] != null 
          ? DateTime.parse(json['lastSeen']).toLocal() 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'nickname': nickname,
      'gender': gender,
      'signature': signature,
      'status': status,
      'lastSeen': lastSeen?.toIso8601String(),
    };
  }

  // 获取显示名称
  String get displayName => nickname.isNotEmpty ? nickname : username;

  // 获取头像 URL
  String get avatarUrl => avatar ?? '';

  // 是否在线
  bool get isOnline => status == 'online';

  // 最后在线时间文本
  String get lastSeenText {
    if (isOnline) return '在线';
    if (lastSeen == null) return '';
    
    final now = DateTime.now();
    final diff = now.difference(lastSeen!);
    
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    
    return '${lastSeen!.month}-${lastSeen!.day}';
  }
}
