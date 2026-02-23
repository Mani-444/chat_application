import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/chat_id.dart';
import '../../../users/domain/entities/chat_user_entity.dart';
import '../../domain/entities/chat_preview_entity.dart';

abstract class HomeRemoteDataSource {
  Future<List<ChatPreviewEntity>> getChatPreviews(String currentUserId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ChatPreviewEntity>> getChatPreviews(String currentUserId) async {
    final usersSnapshot = await firestore.collection('users').get();
    final previews = <ChatPreviewEntity>[];

    for (final doc in usersSnapshot.docs) {
      if (doc.id == currentUserId) continue;

      final otherUserId = doc.id;
      final otherUserName = doc['name'];

      final chatId = getChatId(currentUserId, otherUserId);

      final messagesSnapshot =
          await firestore
              .collection('chats')
              .doc(chatId)
              .collection('messages')
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

      if (messagesSnapshot.docs.isEmpty) continue;

      final lastMsg = messagesSnapshot.docs.first;

      previews.add(
        ChatPreviewEntity(
          chatId: chatId,
          otherUser: ChatUserEntity(
            uid: otherUserId,
            name: otherUserName,
            email: doc['email'],
          ),
          lastMessage: lastMsg['text'],
          lastMessageTime: (lastMsg['timestamp'] as Timestamp).toDate(),
        ),
      );
    }

    return previews;
  }
}
