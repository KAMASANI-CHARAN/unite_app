import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/auth/core/auth_text_field.dart';
import 'package:unite/features/auth/core/auth_styles.dart';
import 'package:unite/features/auth/core/auth_validation.dart';
import 'package:unite/features/auth/core/auth_helper.dart';
import 'package:unite/features/auth/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with AuthSnackbarHelper {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authService = context.read<AuthService>();

    try {
      await authService.signUp(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        showSuccessSnackbar(context, 'Signup successful! Please log in.');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AuthStyles.formPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildHeader(),
                const SizedBox(height: AuthStyles.elementSpacing * 2),
                _buildFormFields(),
                const SizedBox(height: AuthStyles.elementSpacing * 2),
                _buildSignUpButton(),
                const SizedBox(height: AuthStyles.elementSpacing * 1.5),
                _buildSignInRedirect(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
    title: const Text('Sign Up'),
    backgroundColor: AuthStyles.primaryColor,
  );

  Widget _buildHeader() => const Column(
    children: [
      Text(
        'Create a Unite Account',
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
        controller: _fullNameController,
        label: 'Full Name',
        icon: Icons.person,
        validator: AuthValidator.validateName,
      ),
      const SizedBox(height: AuthStyles.elementSpacing),
      AuthTextField(
        controller: _emailController,
        label: 'Email',
        icon: Icons.email,
        keyboardType: TextInputType.emailAddress,
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

  Widget _buildSignUpButton() =>
      _isLoading
          ? const CircularProgressIndicator()
          : SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: AuthStyles.buttonFontSize,
                  color: Colors.white,
                ),
              ),
              onPressed: _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AuthStyles.primaryColor,
                padding: AuthStyles.buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: AuthStyles.buttonBorderRadius,
                ),
              ),
            ),
          );

  Widget _buildSignInRedirect() => TextButton(
    onPressed: () => Navigator.pop(context),
    child: RichText(
      text: const TextSpan(
        text: 'Already have an account? ',
        style: TextStyle(color: AuthStyles.secondaryText),
        children: [
          TextSpan(
            text: 'Login',
            style: TextStyle(
              color: AuthStyles.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
