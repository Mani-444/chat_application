import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) {
    return remoteDataSource.sendMessage(
      senderId: senderId,
      receiverId: receiverId,
      text: text,
    );
  }

  @override
  Stream<List<MessageModel>> getMessages({
    required String senderId,
    required String receiverId,
  }) {
    return remoteDataSource.getMessages(
      senderId: senderId,
      receiverId: receiverId,
    );
  }
}
