import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/core/routes.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function(String)? onSearchChanged;

  const AdminAppBar({super.key, required this.title, this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.signin,
                (route) => false,
              );
            }
          },
          tooltip: 'Logout',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
