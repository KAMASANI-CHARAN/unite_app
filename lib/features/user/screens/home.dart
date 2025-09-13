import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/auth/presentation/provider/auth_provider.dart';
import 'events_screen.dart';
import 'tickets_screen.dart';
import 'account_screen.dart';
import '../widgets/home/home_event_list.dart';
import '../widgets/styles/navbar_color.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userRole = context.watch<AuthProvider>().userRole;

    final screens = [
      const HomeEventList(),
      EventsScreen(userRole: userRole),
      const TicketsScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.primary,
        selectedItemColor: Colors.amber,
        unselectedItemColor: AppColors.onPrimary.withAlpha(220),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_rounded),
            label: 'My Events',
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
      ),
    );
  }
}
