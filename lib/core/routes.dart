import 'package:flutter/material.dart';
import '../features/welcome/welcome_screen.dart';
import '../features/auth/signin_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/admin/screens/admin_dashboard.dart';
import '../features/user/screens/home.dart';
import '../features/organizer/screens/ticket_validation_screen.dart'; // NEW: Import the new screen
import '../features/organizer/screens/qr_scanner_screen.dart'; // NEW: Import the QR scanner screen
import 'not_found_screen.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String admin = '/admin';
  static const String organizer = '/organizer';
  static const String user = '/user';
  static const String validateTicket = '/validate-ticket';
  static const String qrScanner = '/qr-scanner';

  static Map<String, WidgetBuilder> get routes {
    return {
      welcome: (context) => const WelcomeScreen(),
      signin: (context) => const SignInScreen(),
      signup: (context) => const SignupScreen(),
      admin: (context) => const AdminDashboardScreen(),
      organizer: (context) => const Home(),
      user: (context) => const Home(),
      validateTicket: (context) => const TicketValidationScreen(),
      qrScanner: (context) => const QRScannerScreen(),
    };
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const NotFoundScreen());
  }
}
