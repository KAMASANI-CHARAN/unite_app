// lib/features/organizer/widgets/manage_events/sections/ticketing_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/organizer/models/ticket.dart';
import 'package:unite/features/organizer/presentation/notifier/manage_event_notifier.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/ticket_dialog.dart';

class TicketingSection extends StatelessWidget {
  final TextEditingController totalSeatsController;

  const TicketingSection({super.key, required this.totalSeatsController});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ManageEventNotifier>();
    final event = notifier.event!;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticketing',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Divider(height: 24, thickness: 1),
            TextFormField(
              controller: totalSeatsController,
              decoration: const InputDecoration(labelText: 'Total Seats'),
              keyboardType: TextInputType.number,
              validator:
                  (v) =>
                      (v == null || v.isEmpty || int.tryParse(v) == null)
                          ? 'Please enter a valid number'
                          : null,
            ),
            const SizedBox(height: 24),
            ...event.ticketTypes.map(
              (ticket) => ListTile(
                title: Text(
                  ticket.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Price: ${ticket.price.toStringAsFixed(2)} ${ticket.currency} | Qty: ${ticket.quantity}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => notifier.removeTicket(ticket),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _addTicket(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Type'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTicket(BuildContext context) async {
    final newTicket = await showDialog<Ticket>(
      context: context,
      builder: (_) => const TicketDialog(),
    );
    if (newTicket != null && context.mounted) {
      context.read<ManageEventNotifier>().addTicket(newTicket);
    }
  }
}
