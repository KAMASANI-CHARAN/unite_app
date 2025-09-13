import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/core/data/repositories/ticket_repository.dart';
import 'package:unite/features/user/widgets/empty_state.dart';
import 'package:unite/core/data/repositories/event_repository_impl.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/user/screens/events/events_detail_screen.dart';
import 'package:unite/features/user/widgets/events/event_card.dart';

class RegisteredEventsTab extends StatefulWidget {
  const RegisteredEventsTab({super.key});

  @override
  State<RegisteredEventsTab> createState() => _RegisteredEventsTabState();
}

class _RegisteredEventsTabState extends State<RegisteredEventsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _ticketRepository = TicketRepository();
  final _eventRepository = EventRepositoryImpl();

  late Future<List<Event>> _registeredEventsFuture;

  @override
  void initState() {
    super.initState();
    _registeredEventsFuture = _fetchRegisteredEvents();
  }

  Future<List<Event>> _fetchRegisteredEvents() async {
    final tickets = await _ticketRepository.getUserTickets();
    if (tickets.isEmpty) {
      return [];
    }
    final eventIds = tickets.map((t) => t.eventId).toSet().toList();
    return _eventRepository.fetchPublicEventsByIds(eventIds);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const EmptyState(
        title: 'Please Log In',
        subtitle: 'You need to be logged in to view your registered events.',
        icon: Icons.person_off,
      );
    }

    return FutureBuilder<List<Event>>(
      future: _registeredEventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final events = snapshot.data ?? [];

        if (events.isEmpty) {
          return const EmptyState(
            title: 'No Registered Events',
            subtitle: 'Events you register for will appear here.',
            icon: Icons.event_available,
          );
        }

        return ListView.builder(
          itemCount: events.length,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemBuilder: (context, index) {
            final event = events[index];
            return EventCard(
              event: event,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) =>
                            EventDetailScreen(event: event, isRegistered: true),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
