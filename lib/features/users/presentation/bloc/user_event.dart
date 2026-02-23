abstract class UserEvent {}

class LoadUsersEvent extends UserEvent {
  final String currentUserId;

  LoadUsersEvent(this.currentUserId);
}
