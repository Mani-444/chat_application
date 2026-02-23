import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../auth/prsentation/bloc/auth_bloc.dart';
import '../../../auth/prsentation/bloc/auth_event.dart';
import '../../../auth/prsentation/bloc/auth_state.dart';
import '../../../auth/prsentation/pages/login_page.dart';
import '../../../chat/domain/repositories/chat_repository.dart';
import '../../../chat/presentation/blocs/chat_bloc.dart';
import '../../../chat/presentation/blocs/chat_event.dart';
import '../../../home/presentation/bloc/home_bloc.dart';
import '../../../home/presentation/bloc/home_state.dart';
import '../../../users/domain/usecases/get_users_usecase.dart';
import '../../../users/presentation/bloc/user_bloc.dart';
import '../../../users/presentation/bloc/user_event.dart';
import '../../../users/presentation/pages/user_list_page.dart';
import '../../../chat/presentation/pages/chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
            (_) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("We Chat"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(LogoutEvent());
              },
            ),
          ],
        ),

        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeInitial) {
              // context.read<HomeBloc>().add(LoadHomeChatsEvent(uid));
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoaded) {
              if (state.chats.isEmpty) {
                return const Center(
                  child: Text("No chats yet. Start a conversation!"),
                );
              }

              return ListView.builder(
                itemCount: state.chats.length,
                itemBuilder: (_, index) {
                  final chat = state.chats[index];

                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(
                      chat.otherUser.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      "${chat.lastMessageTime.hour}:${chat.lastMessageTime.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider(
                                create:
                                    (context) =>
                                        ChatBloc(context.read<ChatRepository>())
                                          ..add(
                                            LoadMessagesEvent(
                                              uid,
                                              chat.otherUser.uid,
                                            ),
                                          ),
                                child: ChatPage(receiver: chat.otherUser),
                              ),
                        ),
                      );
                    },
                  );
                },
              );
            }

            if (state is HomeError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),

        // ➕ New Chat Button
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.chat),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider(
                      create:
                          (context) =>
                              UserBloc(context.read<GetUsersUseCase>())
                                ..add(LoadUsersEvent(uid)),
                      child: const UserListPage(),
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
