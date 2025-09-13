import 'package:flutter/material.dart';
import 'package:unite/features/user/widgets/styles/navbar_color.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.primary,
      selectedItemColor: AppColors.onPrimary,
      unselectedItemColor: AppColors.onPrimary.withAlpha((0.6 * 255).toInt()),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_rounded),
          label: 'Events',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number_rounded),
          label: 'Tickets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Account',
        ),
      ],
    );
  }
}
