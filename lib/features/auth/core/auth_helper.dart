import 'package:flutter/material.dart';
import 'package:unite/features/auth/core/auth_styles.dart';

mixin AuthSnackbarHelper {
  void showSuccessSnackbar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AuthStyles.successColor,
      ),
    );
  }

  void showErrorSnackbar(BuildContext context, String message) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AuthStyles.errorColor),
    );
  }
}
