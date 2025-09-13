import 'package:flutter/material.dart';
import 'package:unite/features/welcome/styles/text_styles.dart';

class AppTagline extends StatelessWidget {
  const AppTagline({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Find, Create, Celebrate',
      style: TextStyles.tagline,
    ); //app tagline
  }
}
