class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? id;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.id,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      text: json['content'] ?? '',
      isUser: json['sender'] == 'user',
      timestamp:
          json['createdAt'] != null && json['createdAt']['_seconds'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                (json['createdAt']['_seconds'] * 1000).toInt(),
              )
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
