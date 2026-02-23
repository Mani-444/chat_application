import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../users/presentation/bloc/user_event.dart';
import '../../data/models/message_model.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  StreamSubscription? _sub;

  ChatBloc(this.repository) : super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<_MessagesUpdated>((event, emit) {
      emit(ChatLoaded(event.messages));
    });
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    _sub?.cancel();
    _sub = repository
        .getMessages(senderId: event.senderId, receiverId: event.receiverId)
        .listen((messages) {
          add(_MessagesUpdated(messages));
        });
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    repository.sendMessage(
      senderId: event.senderId,
      receiverId: event.receiverId,
      text: event.text,
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

class _MessagesUpdated extends ChatEvent {
  final List<MessageModel> messages;

  _MessagesUpdated(this.messages);
}
