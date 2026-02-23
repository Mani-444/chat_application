import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_chat_previews_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetChatPreviewsUseCase getChats;

  HomeBloc(this.getChats, String? uid) : super(HomeInitial()) {
    on<LoadHomeChatsEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final chats = await getChats(event.currentUserId);
        emit(HomeLoaded(chats));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
    if (uid != null) {
      add(LoadHomeChatsEvent(uid));
    }
  }

  Future<void> _onLoadHomeChats(
    LoadHomeChatsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final chats = await getChats(event.currentUserId);
      emit(HomeLoaded(chats));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
