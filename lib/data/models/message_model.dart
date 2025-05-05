class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['\$id'],
      chatId: map['chatId'],
      senderId: map['senderId'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
