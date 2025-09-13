import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/models/track.dart';
import 'package:unite/features/organizer/models/zone.dart';
import 'package:unite/features/organizer/services/event_services.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/track_dialog.dart';
import 'track_list.dart';

class ZoneList extends StatefulWidget {
  final Event event;
  final VoidCallback onUpdate;

  const ZoneList({super.key, required this.event, required this.onUpdate});

  @override
  ZoneListState createState() => ZoneListState();
}

class ZoneListState extends State<ZoneList> {
  final EventService _eventService = EventService();

  void _addTrack(Zone zone) async {
    if (!mounted) return;
    final newTrack = await showDialog<Track>(
      context: context,
      builder: (context) => const TrackDialog(),
    );

    if (newTrack != null) {
      setState(() {
        zone.tracks.add(newTrack);
      });
      await _eventService.updateEvent(widget.event);
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          widget.event.zones.map((zone) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          zone.name,

                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addTrack(zone),
                        ),
                      ],
                    ),
                    TrackList(
                      zone: zone,
                      event: widget.event,
                      onUpdate: widget.onUpdate,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
