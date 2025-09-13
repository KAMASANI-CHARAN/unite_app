// lib/features/organizer/screens/manage_event/manage_event_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/organizer/presentation/notifier/manage_event_notifier.dart';
import 'package:unite/core/data/repositories/event_repository_impl.dart';
import 'package:unite/core/data/repositories/user_repository_impl.dart';
import 'manage_event_view.dart';

class ManageEventScreen extends StatelessWidget {
  final String eventId;
  const ManageEventScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => ManageEventNotifier(
            eventRepository: EventRepositoryImpl(),
            userRepository: UserRepositoryImpl(),
          )..loadEvent(eventId),
      child: const ManageEventView(),
    );
  }
}
