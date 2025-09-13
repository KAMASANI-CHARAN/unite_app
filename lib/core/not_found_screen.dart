import 'package:flutter/material.dart';

//displays this screen when a route is not found
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: const Center(
        child: Text('404 - Page Not Found', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
