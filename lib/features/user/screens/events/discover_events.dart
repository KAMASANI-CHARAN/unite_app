import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/core/utils/error_utils.dart';
import 'package:unite/features/user/services/event_service.dart';
import 'package:unite/features/user/widgets/empty_state.dart';
import 'package:unite/features/user/widgets/events/public_event_card.dart';

class DiscoverEventsTab extends StatelessWidget {
  const DiscoverEventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final eventService = Provider.of<EventService>(context);
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    return StreamBuilder<QuerySnapshot>(
      stream: eventService.getPublicEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorUtils.buildError('Error loading public events');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final events = snapshot.data?.docs ?? [];
        if (events.isEmpty) {
          return const EmptyState(
            title: 'No Public Events',
            subtitle: 'Published events will appear here',
            icon: Icons.public,
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final eventDoc = events[index];

            final event = Event.fromFirestore(eventDoc);

            return PublicEventCard(
              event: event,
              onRegister:
                  () => _registerForEvent(context, event, userId, userEmail),
            );
          },
        );
      },
    );
  }

  void _registerForEvent(
    BuildContext context,
    Event event,
    String? userId,
    String? userEmail,
  ) async {
    if (userId == null || userEmail == null) return;

    final eventService = Provider.of<EventService>(context, listen: false);
    try {
      await eventService.registerForEvent(
        userId: userId,
        userEmail: userEmail,
        eventId: event.id,

        eventName: event.title,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Successfully registered!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Registration failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
