import '../../domain/entities/chat_preview_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ChatPreviewEntity>> getChatPreviews(String currentUserId) {
    return remoteDataSource.getChatPreviews(currentUserId);
  }
}
