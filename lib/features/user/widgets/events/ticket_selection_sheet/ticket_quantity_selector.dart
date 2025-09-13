import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/ticket.dart';

class TicketQuantitySelector extends StatelessWidget {
  final Ticket ticket;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const TicketQuantitySelector({
    super.key,
    required this.ticket,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticket.name, style: theme.textTheme.titleMedium),
                Text(
                  '₹${ticket.price.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: onDecrement,
                ),
                Text('$quantity', style: theme.textTheme.titleMedium),
                IconButton(icon: const Icon(Icons.add), onPressed: onIncrement),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
