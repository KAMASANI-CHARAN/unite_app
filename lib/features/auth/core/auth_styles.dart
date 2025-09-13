import 'package:flutter/material.dart';

class AuthStyles {
  static const Color primaryColor = Colors.deepPurple;
  static const Color secondaryText = Colors.black;
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const double headerFontSize = 28;
  static const double buttonFontSize = 18;
  static const double formPadding = 24.0;
  static const double elementSpacing = 16.0;

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    vertical: 16,
    horizontal: 40,
  );

  static const BorderRadius buttonBorderRadius = BorderRadius.all(
    Radius.circular(12),
  );

  static InputDecoration textFieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}
