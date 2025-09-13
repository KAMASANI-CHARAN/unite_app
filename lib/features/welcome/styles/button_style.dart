import 'package:flutter/material.dart';
import 'package:unite/features/welcome/styles/app_padding.dart';
import 'package:unite/features/welcome/styles/app_radius.dart';

class ButtonStyles {
  static final ButtonStyle primary = ElevatedButton.styleFrom(
    padding: AppPadding.button,
    backgroundColor: const Color.fromARGB(255, 103, 58, 183),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.medium),
    ),
  );
}
