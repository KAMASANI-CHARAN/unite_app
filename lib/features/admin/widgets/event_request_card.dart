import 'package:flutter/material.dart';
import 'package:unite/features/admin/screens/event_details_screen.dart';

class EventRequestCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final Function(String, String) onStatusChanged;

  const EventRequestCard({
    super.key,
    required this.data,
    required this.docId,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final eventName = data['name'] ?? 'Unnamed Event';
    final organizer = data['organizer'] ?? 'Unknown Organizer';
    final status = data['status'] ?? 'pending';
    final location = data['location'] ?? '';
    final type = data['type'] ?? '';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => EventDetailsScreen(
                  eventData: data,
                  docId: docId,
                  onStatusChanged: onStatusChanged,
                ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Organizer: $organizer',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Location: $location',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                    if (type.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Type: $type',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _buildStatusIndicator(status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    Color indicatorColor;
    String statusText;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'approved':
        indicatorColor = Colors.green;
        statusText = 'Approved';
        icon = Icons.check_circle;
        break;
      case 'rejected':
        indicatorColor = Colors.red;
        statusText = 'Rejected';
        icon = Icons.cancel;
        break;
      default:
        indicatorColor = Colors.orange;
        statusText = 'Pending';
        icon = Icons.access_time;
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: indicatorColor.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: indicatorColor, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          statusText,
          style: TextStyle(
            color: indicatorColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
