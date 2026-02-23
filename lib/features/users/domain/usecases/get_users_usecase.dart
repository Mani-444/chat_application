import '../entities/chat_user_entity.dart';
import '../repositories/user_repository.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<ChatUserEntity>> call(String currentUserId) {
    return repository.getUsers(currentUserId);
  }
}
