import 'package:flutter/material.dart';
import 'package:unite/core/data/repositories/ticket_repository.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/models/ticket.dart';
import 'package:unite/features/user/screens/tickets/ticket_details_screen.dart';
import 'package:unite/features/user/widgets/events/ticket_selection_sheet.dart';

class EventTicketingSection extends StatelessWidget {
  final Event event;
  final bool isRegistered;
  const EventTicketingSection({
    super.key,
    required this.event,
    required this.isRegistered,
  });

  void _showTicketSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => TicketSelectionSheet(event: event),
    );
  }

  void _viewTicket(BuildContext context) async {
    try {
      final userTickets = await TicketRepository().getUserTickets();
      final ticketForThisEvent = userTickets.firstWhere(
        (ticket) => ticket.eventId == event.id,
      );

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => TicketDetailsScreen(ticketId: ticketForThisEvent.id),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Could not find your ticket. $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...event.ticketTypes.map((ticket) => _buildTicketTile(context, ticket)),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,

          child:
              isRegistered
                  ? OutlinedButton.icon(
                    onPressed: () => _viewTicket(context),
                    icon: const Icon(Icons.confirmation_num_outlined),
                    label: const Text('View Your Ticket'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  : ElevatedButton.icon(
                    onPressed: () => _showTicketSelection(context),
                    icon: const Icon(Icons.confirmation_num),
                    label: const Text('Register for Event'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        ),
      ],
    );
  }

  Widget _buildTicketTile(BuildContext context, Ticket ticket) {
    return ListTile(
      title: Text(
        ticket.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Price: ${ticket.price.toStringAsFixed(2)} ${ticket.currency}',
      ),
      trailing: Text('Available: ${ticket.quantity}'),
    );
  }
}
