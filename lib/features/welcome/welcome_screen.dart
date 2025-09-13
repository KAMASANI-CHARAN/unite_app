import 'package:flutter/material.dart';
import 'package:unite/core/routes.dart';
import 'widgets/app_title.dart';
import 'widgets/app_tagline.dart';
import 'widgets/app_colors.dart';
import 'styles/app_padding.dart';
import 'styles/app_spacing.dart';
import 'styles/text_styles.dart';
import 'styles/button_style.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: AppPadding.screen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppTitle(),
              SizedBox(height: AppSpacing.medium),
              const AppTagline(),
              SizedBox(height: AppSpacing.xxLarge),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signin);
                },
                style: ButtonStyles.primary,
                child: const Text('Get Started', style: TextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
