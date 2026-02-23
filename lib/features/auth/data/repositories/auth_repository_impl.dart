import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthUserEntity> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<AuthUserEntity> signUp(String email, String password) {
    return remoteDataSource.signUp(email, password);
  }

  @override
  AuthUserEntity? getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return AuthUserModel.fromFirebase(user);
  }

  @override
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
