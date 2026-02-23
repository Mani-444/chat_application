import '../entities/chat_preview_entity.dart';

abstract class HomeRepository {
  Future<List<ChatPreviewEntity>> getChatPreviews(String currentUserId);
}
