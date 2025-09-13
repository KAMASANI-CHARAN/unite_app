import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/core/utils/date_utils.dart' as app_date_utils;
import 'package:unite/features/user/screens/events/events_detail_screen.dart';

class HomeEventCard extends StatelessWidget {
  final Event event;

  const HomeEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        event.imageUrl ??
        'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop';

    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailScreen(event: event),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
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
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    context,
                    icon: Icons.person_outline,
                    text:
                        event.organizerContact.isNotEmpty
                            ? 'By ${event.organizerContact}'
                            : 'Unknown Organizer',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    context,
                    icon: Icons.calendar_today_outlined,
                    text:
                        event.startDate != null
                            ? 'Date: ${app_date_utils.DateUtils.formatDate(event.startDate)}'
                            : 'Date: TBD',
                  ),
                  const SizedBox(height: 8),
                  if (event.venue.isNotEmpty)
                    _buildInfoRow(
                      context,
                      icon: Icons.location_on_outlined,
                      text: 'Venue: ${event.venue}',
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EventDetailScreen(event: event),
                          ),
                        );
                      },
                      icon: const Icon(Icons.confirmation_num_outlined),
                      label: const Text('Register Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
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
