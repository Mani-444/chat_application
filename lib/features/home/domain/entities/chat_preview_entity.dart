import '../../../users/domain/entities/chat_user_entity.dart';

class ChatPreviewEntity {
  final String chatId;
  final ChatUserEntity otherUser;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatPreviewEntity({
    required this.chatId,
    required this.otherUser,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
