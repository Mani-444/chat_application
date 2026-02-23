import 'package:chat_application/features/auth/prsentation/bloc/auth_bloc.dart';
import 'package:chat_application/features/auth/prsentation/pages/signup_page.dart';
import 'package:chat_application/features/home/presentation/bloc/home_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  String? emailError;

  String? passwordError;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<AuthBloc>()),
                        // provide HomeBloc
                        BlocProvider.value(value: context.read<HomeBloc>()),
                      ],
                      child: const HomePage(),
                    ),
              ),
              (route) => false,
            );
          }
          if (state is Authenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder:
                    (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: context.read<AuthBloc>()),
                        // provide HomeBloc
                        BlocProvider.value(value: context.read<HomeBloc>()),
                      ],
                      child: const HomePage(),
                    ),
              ),
              (route) => false,
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    errorText: emailError,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    errorText: passwordError,
                  ),
                ),
                const SizedBox(height: 20),
                state is AuthLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: () {
                        if (validateInputs()) {
                          context.read<AuthBloc>().add(
                            LoginEvent(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            ),
                          );
                        }
                      },
                      child: const Text("Login"),
                    ),
                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => BlocProvider.value(
                              value: context.read<AuthBloc>(),
                              child: SignupPage(),
                            ),
                      ),
                    );
                  },
                  child: const Text(
                    "Don’t have an account? Sign up",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool validateInputs() {
    bool isValid = true;

    setState(() {
      emailError = null;
      passwordError = null;

      if (emailController.text.isEmpty) {
        emailError = "Email is required";
        isValid = false;
      } else if (!emailController.text.contains("@")) {
        emailError = "Enter a valid email";
        isValid = false;
      }

      if (passwordController.text.length < 6) {
        passwordError = "Password must be at least 6 characters";
        isValid = false;
      }
    });

    return isValid;
  }
}
