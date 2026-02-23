abstract class HomeEvent {}

class LoadHomeChatsEvent extends HomeEvent {
  final String currentUserId;

  LoadHomeChatsEvent(this.currentUserId);
}
