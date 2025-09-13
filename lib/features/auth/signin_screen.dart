import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/auth/core/auth_text_field.dart';
import 'package:unite/features/auth/core/auth_styles.dart';
import 'package:unite/features/auth/core/auth_validation.dart';
import 'package:unite/features/auth/core/auth_helper.dart';
import 'package:unite/features/auth/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with AuthSnackbarHelper {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authService = context.read<AuthService>();

    try {
      final role = await authService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) _redirectBasedOnRole(role);
    } catch (e) {
      if (mounted) showErrorSnackbar(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _redirectBasedOnRole(String role) {
    String route;
    switch (role) {
      case 'admin':
        route = '/admin';
        break;
      case 'organizer':
      case 'user':
      default:
        route = '/user';
        break;
    }

    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(AuthStyles.formPadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(),
              const SizedBox(height: AuthStyles.elementSpacing * 2),
              _buildFormFields(),
              const SizedBox(height: AuthStyles.elementSpacing * 1.5),
              _buildSignInButton(),
              const SizedBox(height: AuthStyles.elementSpacing),
              _buildSignUpRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
    title: const Text('Sign In'),
    backgroundColor: AuthStyles.primaryColor,
  );

  Widget _buildHeader() => const Column(
    children: [
      Text(
        'Login to Unite',
        style: TextStyle(
          fontSize: AuthStyles.headerFontSize,
          fontWeight: FontWeight.bold,
          color: AuthStyles.primaryColor,
        ),
      ),
    ],
  );

  Widget _buildFormFields() => Column(
    children: [
      AuthTextField(
        controller: _emailController,
        label: 'Email',
        icon: Icons.email,
        validator: AuthValidator.validateEmail,
      ),
      const SizedBox(height: AuthStyles.elementSpacing),
      AuthTextField(
        controller: _passwordController,
        label: 'Password',
        icon: Icons.lock,
        obscureText: true,
        validator: AuthValidator.validatePassword,
      ),
    ],
  );

  Widget _buildSignInButton() =>
      _isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
            onPressed: _handleSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: AuthStyles.primaryColor,
              padding: AuthStyles.buttonPadding,
              shape: RoundedRectangleBorder(
                borderRadius: AuthStyles.buttonBorderRadius,
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: AuthStyles.buttonFontSize,
                color: Colors.white,
              ),
            ),
          );

  Widget _buildSignUpRedirect() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have an account? "),
      TextButton(
        onPressed: () => Navigator.pushNamed(context, '/signup'),
        child: const Text(
          'Sign Up',
          style: TextStyle(color: AuthStyles.primaryColor),
        ),
      ),
    ],
  );
}
