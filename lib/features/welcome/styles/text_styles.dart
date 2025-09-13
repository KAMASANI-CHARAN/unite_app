import 'package:flutter/material.dart';
import 'package:unite/features/welcome/widgets/app_colors.dart';

class TextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const TextStyle tagline = TextStyle(
    fontSize: 20,
    fontStyle: FontStyle.italic,
    color: AppColors.primary,
  );

  static const TextStyle button = TextStyle(
    fontSize: 18,
    color: AppColors.onPrimary,
  );
}
