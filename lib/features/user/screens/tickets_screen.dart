import 'package:flutter/material.dart';
import 'package:unite/core/data/repositories/ticket_repository.dart';
import 'package:unite/core/models/user_ticket.dart';
import 'package:unite/features/user/screens/tickets/ticket_details_screen.dart';
import 'package:unite/features/user/widgets/empty_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/features/user/widgets/tickets/ticket_card.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _ticketRepository = TicketRepository();

  late Future<List<UserTicket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = _ticketRepository.getUserTickets();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const EmptyState(
        title: 'Please Log In',
        subtitle: 'You need to be logged in to view your tickets.',
        icon: Icons.person_off,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Tickets')),
      body: FutureBuilder<List<UserTicket>>(
        future: _ticketsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyState(
              title: 'No Tickets Found',
              subtitle: 'Tickets you purchase will appear here.',
              icon: Icons.confirmation_number_outlined,
            );
          }
          final tickets = snapshot.data!;
          return ListView.builder(
            itemCount: tickets.length,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return TicketCard(
                ticket: ticket,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TicketDetailsScreen(ticketId: ticket.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
