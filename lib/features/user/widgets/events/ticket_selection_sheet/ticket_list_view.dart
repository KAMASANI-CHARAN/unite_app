import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/models/ticket.dart';
import 'ticket_quantity_selector.dart';

class TicketListView extends StatelessWidget {
  final Event event;
  final Map<String, int> ticketQuantities;
  final Function(Ticket) onIncrement;
  final Function(Ticket) onDecrement;

  const TicketListView({
    super.key,
    required this.event,
    required this.ticketQuantities,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: event.ticketTypes.length,
        itemBuilder: (context, index) {
          final ticket = event.ticketTypes[index];
          final quantity = ticketQuantities[ticket.name] ?? 0;
          return TicketQuantitySelector(
            ticket: ticket,
            quantity: quantity,
            onIncrement: () => onIncrement(ticket),
            onDecrement: () => onDecrement(ticket),
          );
        },
      ),
    );
  }
}
