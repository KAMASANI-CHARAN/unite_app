import 'package:flutter/material.dart';
import 'package:unite/core/models/event_model.dart';

class MyEventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const MyEventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(event.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor,
          child: Icon(
            event.status == 'published' ? Icons.public : Icons.edit,
            color: Colors.white,
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${event.status.toUpperCase()}'),

            if (event.venue.isNotEmpty) Text('Location: ${event.venue}'),
            const SizedBox(height: 4),
            const Row(
              children: [
                Icon(Icons.settings, size: 16, color: Colors.blue),
                SizedBox(width: 4),
                Text(
                  'Tap to manage',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'published':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
