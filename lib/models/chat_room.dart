class ChatRoom {
  final String id;
  final String name;
  final String description;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final int participantsCount;
  final String category;
  final String? imageUrl;

  ChatRoom({
    required this.id,
    required this.name,
    required this.description,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.participantsCount,
    required this.category,
    this.imageUrl,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: DateTime.parse(json['last_message_time']),
      unreadCount: json['unread_count'] ?? 0,
      participantsCount: json['participants_count'] ?? 0,
      category: json['category'] ?? 'Общий',
      imageUrl: json['image_url'],
    );
  }
}

class ChatMessage {
  final String id;
  final String chatId;
  final String userId;
  final String userName;
  final String message;
  final DateTime timestamp;
  final bool isOwn;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.message,
    required this.timestamp,
    required this.isOwn,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      chatId: json['chat_id'],
      userId: json['user_id'],
      userName: json['user_name'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      isOwn: json['is_own'] ?? false,
    );
  }
}
