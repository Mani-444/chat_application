import '../entities/chat_preview_entity.dart';
import '../repositories/home_repository.dart';

class GetChatPreviewsUseCase {
  final HomeRepository repository;

  GetChatPreviewsUseCase(this.repository);

  Future<List<ChatPreviewEntity>> call(String currentUserId) {
    return repository.getChatPreviews(currentUserId);
  }
}
