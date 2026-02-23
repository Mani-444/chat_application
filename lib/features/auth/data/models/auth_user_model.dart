import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  AuthUserModel({required super.uid, required super.email});

  factory AuthUserModel.fromFirebase(user) {
    return AuthUserModel(uid: user.uid, email: user.email);
  }
}
