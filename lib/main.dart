import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/routes.dart';
import 'core/app_theme.dart';
import 'features/auth/presentation/provider/auth_provider.dart';
import 'features/auth/presentation/screens/auth_wrapper.dart';
import 'features/auth/services/auth_service.dart'; // Import AuthService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const UniteApp());
}

class UniteApp extends StatelessWidget {
  const UniteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<AuthProvider>(
          create:
              (context) =>
                  AuthProvider(authService: context.read<AuthService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Unite',
        theme: AppTheme.build(),
        home: const AuthWrapper(),
        routes: AppRoutes.routes,
        onUnknownRoute: AppRoutes.unknownRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
