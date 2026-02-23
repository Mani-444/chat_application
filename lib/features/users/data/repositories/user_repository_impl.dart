import '../../domain/entities/chat_user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ChatUserEntity>> getUsers(String currentUserId) async {
    final models = await remoteDataSource.getUsers();
    return models.where((user) => user.uid != currentUserId).toList();
  }
}
