import 'package:flutter/material.dart';
import 'package:unite/features/welcome/styles/text_styles.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Unite', style: TextStyles.title); //app title
  }
}
