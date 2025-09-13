import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/features/organizer/screens/manage_event/manage_event_screen.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/user/widgets/empty_state.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  late final Stream<List<Event>> _managedEventsStream;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _managedEventsStream = _getManagedEventsStream(currentUser.uid);
    } else {
      _managedEventsStream = Stream.value([]);
    }
  }

  Stream<List<Event>> _getManagedEventsStream(String uid) {
    return FirebaseFirestore.instance
        .collection('events')
        .where('managerUids', arrayContains: uid)
        .snapshots()
        .map((snapshot) {
          debugPrint('--- MyEvents Stream Update ---');
          for (var doc in snapshot.docs) {
            debugPrint('Received Document ID: ${doc.id}');
            debugPrint('Document Data: ${doc.data()}');
          }
          debugPrint('Total documents received: ${snapshot.docs.length}');
          debugPrint('------------------------------');

          if (snapshot.docs.isEmpty) {
            return [];
          }
          final events =
              snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
          events.sort(
            (a, b) => (b.startDate ?? DateTime(0)).compareTo(
              a.startDate ?? DateTime(0),
            ),
          );
          return events;
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: _managedEventsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const EmptyState(
            title: 'No Events to Manage',
            subtitle: 'Events you create or moderate will appear here.',
            icon: Icons.event_note,
          );
        }

        final events = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Status: ${event.status.toUpperCase()}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ManageEventScreen(eventId: event.id),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
