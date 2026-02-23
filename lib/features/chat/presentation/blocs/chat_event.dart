abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String text;

  SendMessageEvent(this.senderId, this.receiverId, this.text);
}

class LoadMessagesEvent extends ChatEvent {
  final String senderId;
  final String receiverId;

  LoadMessagesEvent(this.senderId, this.receiverId);
}
