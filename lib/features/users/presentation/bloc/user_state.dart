
import '../../domain/entities/chat_user_entity.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<ChatUserEntity> users;
  UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}