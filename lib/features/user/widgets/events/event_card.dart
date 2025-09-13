import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/core/utils/date_utils.dart' as app_date_utils;

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        event.imageUrl ??
        'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop';

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    icon: Icons.person_outline,
                    text:
                        event.organizerContact.isNotEmpty
                            ? 'By ${event.organizerContact}'
                            : 'Unknown Organizer',
                  ),
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    text:
                        event.startDate != null
                            ? 'Date: ${app_date_utils.DateUtils.formatDate(event.startDate)}'
                            : 'Date: TBD',
                  ),
                  const SizedBox(height: 4),
                  if (event.venue.isNotEmpty)
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      text: 'Venue: ${event.venue}',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
