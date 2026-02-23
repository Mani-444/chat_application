import '../../domain/entities/chat_user_entity.dart';

class ChatUserModel extends ChatUserEntity {
  ChatUserModel({
    required super.uid,
    required super.email,
    required super.name,
  });

  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
