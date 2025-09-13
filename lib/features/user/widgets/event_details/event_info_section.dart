import 'package:flutter/material.dart';
import 'package:unite/core/utils/date_utils.dart' as app_date_utils;
import 'package:unite/features/organizer/models/event.dart';

class EventInfoSection extends StatelessWidget {
  final Event event;
  const EventInfoSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          icon: Icons.person_outline,
          text:
              event.organizerContact.isNotEmpty
                  ? 'By ${event.organizerContact}'
                  : 'Unknown Organizer',
        ),
        _buildInfoRow(
          icon: Icons.calendar_today_outlined,
          text: app_date_utils.DateUtils.formatDate(event.startDate),
        ),
        _buildInfoRow(
          icon: Icons.location_on_outlined,
          text: event.venue.isNotEmpty ? event.venue : 'Online Event',
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
