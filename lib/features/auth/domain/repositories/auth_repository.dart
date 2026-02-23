import '../entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<AuthUserEntity> login(String email, String password);

  Future<AuthUserEntity> signUp(String email, String password);

  AuthUserEntity? getCurrentUser();

  Future<void> logout();
}
