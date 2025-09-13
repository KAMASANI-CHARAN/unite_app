import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/user/widgets/event_details/event_sliver_app_bar.dart';
import 'package:unite/features/user/widgets/event_details/event_info_section.dart';
import 'package:unite/features/user/widgets/event_details/event_structure_section.dart';
import 'package:unite/features/user/widgets/event_details/event_ticketing_section.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;
  final bool isRegistered;

  const EventDetailScreen({
    super.key,
    required this.event,
    this.isRegistered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          EventSliverAppBar(event: event),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventInfoSection(event: event),
                    const SizedBox(height: 24),
                    _buildSectionTitle(context, 'About the Event'),
                    Text(
                      event.description.isNotEmpty
                          ? event.description
                          : 'No description provided.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    if (event.zones.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Event Structure'),
                      EventStructureSection(zones: event.zones),
                      const SizedBox(height: 24),
                    ],
                    if (event.ticketTypes.isNotEmpty) ...[
                      _buildSectionTitle(context, 'Ticket Information'),
                      EventTicketingSection(
                        event: event,
                        isRegistered: isRegistered,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
