import '../entities/chat_user_entity.dart';

abstract class UserRepository {
  Future<List<ChatUserEntity>> getUsers(String currentUserId);
}
