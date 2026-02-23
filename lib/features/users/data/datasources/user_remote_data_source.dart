import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<ChatUserModel>> getUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ChatUserModel>> getUsers() async {
    final snapshot = await firestore.collection('users').get();

    return snapshot.docs
        .map((doc) => ChatUserModel.fromMap(doc.data()))
        .toList();
  }
}
