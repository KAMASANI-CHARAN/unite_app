import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/auth/presentation/provider/auth_provider.dart';
import 'package:unite/features/user/screens/home.dart';
import 'package:unite/features/welcome/welcome_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    switch (authProvider.status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.authenticated:
        return const Home();
      case AuthStatus.unauthenticated:
        return const WelcomeScreen();
    }
  }
}
