class MessageEntity {
  final String senderId;
  final String text;
  final DateTime timestamp;

  MessageEntity({
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}
