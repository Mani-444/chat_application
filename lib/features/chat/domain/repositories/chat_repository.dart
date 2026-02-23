import '../../data/models/message_model.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  // Stream<List<MessageEntity>> getMessages(String chatId);
  // Future<void> sendMessage(String chatId, MessageEntity message);

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  });

  Stream<List<MessageModel>> getMessages({
    required String senderId,
    required String receiverId,
  });
}
