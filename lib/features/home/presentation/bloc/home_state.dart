import '../../domain/entities/chat_preview_entity.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ChatPreviewEntity> chats;

  HomeLoaded(this.chats);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
