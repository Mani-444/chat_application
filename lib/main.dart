import 'package:chat_application/features/auth/prsentation/pages/login_page.dart';
import 'package:chat_application/features/auth/prsentation/pages/signup_page.dart';
import 'package:chat_application/features/home/data/datasources/home_remote_data_source.dart';
import 'package:chat_application/features/home/data/repositories/home_repository_impl.dart';
import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/screens/auth/login_screen.dart';
import 'package:chat_application/screens/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/prsentation/bloc/auth_bloc.dart';
import 'features/auth/prsentation/bloc/auth_event.dart';
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/home/domain/usecases/get_chat_previews_usecase.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/users/data/datasources/user_remote_data_source.dart';
import 'features/users/data/repositories/user_repository_impl.dart';
import 'features/users/domain/usecases/get_users_usecase.dart';

void main() async {
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔥 1. External dependency
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // 🔥 2. Data source
  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    firebaseAuth,
    firestore,
  );
  final userRemoteDataSource = UserRemoteDataSourceImpl(firestore);
  final chatRemoteDataSource = ChatRemoteDataSourceImpl(firestore);
  final homeRemoteDataSource = HomeRemoteDataSourceImpl(firestore);

  // 🔥 3. Repository
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final userRepository = UserRepositoryImpl(userRemoteDataSource);
  final chatRepository = ChatRepositoryImpl(chatRemoteDataSource);
  final homeRepository = HomeRepositoryImpl(homeRemoteDataSource);

  // 🔥 4. Use cases
  final loginUseCase = LoginUseCase(authRepository);
  final signUpUseCase = SignUpUseCase(authRepository);
  final getUsersUseCase = GetUsersUseCase(userRepository);
  final getChatPreviousUseCase = GetChatPreviewsUseCase(homeRepository);

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: loginUseCase),
        RepositoryProvider.value(value: signUpUseCase),
        RepositoryProvider.value(value: getUsersUseCase),
        RepositoryProvider<ChatRepository>.value(value: chatRepository),
        RepositoryProvider.value(value: getChatPreviousUseCase),
      ],

      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (_) => AuthBloc(
                  loginUseCase: loginUseCase,
                  signUpUseCase: signUpUseCase,
                ),
          ),
          BlocProvider(
            create:
                (context) => HomeBloc(
                  context.read<GetChatPreviewsUseCase>(),
                  FirebaseAuth.instance.currentUser?.uid,
                ),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'We Chat',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: LoginPage(),
    );
  }
}
