class MessageModel {
  final String id;
  final String conversationId;
  final String conversationType;
  final String senderId;
  final String? receiverId;
  final String? groupId;
  final String type;
  final MessageContent content;
  final String status;
  final DateTime createdAt;
  final bool isDeleted;
  final String? replyToId;
  final List<String>? mentions;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.conversationType,
    required this.senderId,
    this.receiverId,
    this.groupId,
    required this.type,
    required this.content,
    required this.status,
    required this.createdAt,
    this.isDeleted = false,
    this.replyToId,
    this.mentions,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      conversationType: json['conversationType'] ?? 'private',
      senderId: json['sender']?['_id'] ?? json['sender'] ?? '',
      receiverId: json['receiver']?['_id'] ?? json['receiver'],
      groupId: json['group']?['_id'] ?? json['group'],
      type: json['type'] ?? 'text',
      content: MessageContent.fromJson(json['content'] ?? {}),
      status: json['status'] ?? 'sending',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']).toLocal() 
          : DateTime.now(),
      isDeleted: json['isDeleted'] ?? false,
      replyToId: json['replyTo']?['_id'] ?? json['replyTo'],
      mentions: json['mentions'] != null 
          ? List<String>.from(json['mentions']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'conversationId': conversationId,
      'conversationType': conversationType,
      'sender': senderId,
      'receiver': receiverId,
      'group': groupId,
      'type': type,
      'content': content.toJson(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'isDeleted': isDeleted,
      'replyTo': replyToId,
      'mentions': mentions,
    };
  }
}

class MessageContent {
  final String? text;
  final String? imageUrl;
  final String? videoUrl;
  final String? audioUrl;
  final String? fileName;
  final int? fileSize;
  final String? filePath;
  final String? emojiCode;
  final int? duration;
  final double? latitude;
  final double? longitude;
  final String? locationName;
  final Map<String, dynamic>? contactInfo;

  MessageContent({
    this.text,
    this.imageUrl,
    this.videoUrl,
    this.audioUrl,
    this.fileName,
    this.fileSize,
    this.filePath,
    this.emojiCode,
    this.duration,
    this.latitude,
    this.longitude,
    this.locationName,
    this.contactInfo,
  });

  factory MessageContent.fromJson(Map<String, dynamic> json) {
    return MessageContent(
      text: json['text'],
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      filePath: json['filePath'],
      emojiCode: json['emojiCode'],
      duration: json['duration'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      locationName: json['locationName'],
      contactInfo: json['contactInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'filePath': filePath,
      'emojiCode': emojiCode,
      'duration': duration,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'contactInfo': contactInfo,
    };
  }
}

// 消息类型枚举
class MessageType {
  static const String text = 'text';
  static const String image = 'image';
  static const String video = 'video';
  static const String audio = 'audio';
  static const String file = 'file';
  static const String emoji = 'emoji';
  static const String system = 'system';
  static const String location = 'location';
  static const String contact = 'contact';
  static const String voiceCall = 'voice_call';
  static const String videoCall = 'video_call';
}

// 消息状态枚举
class MessageStatus {
  static const String sending = 'sending';
  static const String sent = 'sent';
  static const String delivered = 'delivered';
  static const String read = 'read';
  static const String failed = 'failed';
}
