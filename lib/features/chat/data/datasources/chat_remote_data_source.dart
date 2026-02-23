import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
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

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl(this.firestore);

  String _chatId(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join("_");
  }

  @override
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final chatId = _chatId(senderId, receiverId);
    final chatRef = firestore.collection('chats').doc(chatId);

    if (!(await chatRef.get()).exists) {
      await chatRef.set({
        'participants': [senderId, receiverId],
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }

    await chatRef.collection('messages').add({
      'senderId': senderId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await chatRef.update({
      'lastMessage': text,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<MessageModel>> getMessages({
    required String senderId,
    required String receiverId,
  }) {
    final chatId = _chatId(senderId, receiverId);

    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => MessageModel.fromMap(d.data())).toList(),
        );
  }
}
