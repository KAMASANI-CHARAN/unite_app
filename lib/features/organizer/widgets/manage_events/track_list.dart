import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/models/track.dart';
import 'package:unite/features/organizer/models/zone.dart';
import 'package:unite/features/organizer/models/session.dart';
import 'package:unite/features/organizer/models/stall.dart';
import 'package:unite/features/organizer/services/event_services.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/session_dialog.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/stall_dialog.dart';
import 'session_list.dart';
import 'stall_list.dart';

class TrackList extends StatefulWidget {
  final Zone zone;
  final Event event;
  final VoidCallback onUpdate;

  const TrackList({
    super.key,
    required this.zone,
    required this.event,
    required this.onUpdate,
  });

  @override
  TrackListState createState() => TrackListState();
}

class TrackListState extends State<TrackList> {
  final EventService _eventService = EventService();

  void _addSession(Track track) async {
    if (!mounted) return;
    final newSession = await showDialog<Session>(
      context: context,
      builder: (context) => SessionDialog(),
    );

    if (newSession != null) {
      setState(() {
        track.sessions.add(newSession);
      });
      await _eventService.updateEvent(widget.event);
      widget.onUpdate();
    }
  }

  void _addStall(Track track) async {
    if (!mounted) return;
    final newStall = await showDialog<Stall>(
      context: context,
      builder: (context) => StallDialog(),
    );

    if (newStall != null) {
      setState(() {
        track.stalls.add(newStall);
      });
      await _eventService.updateEvent(widget.event);
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          widget.zone.tracks.map((track) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,

                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),

                  // Sessions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sessions'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addSession(track),
                      ),
                    ],
                  ),
                  SessionList(
                    track: track,
                    event: widget.event,
                    onUpdate: widget.onUpdate,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Stalls'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _addStall(track),
                      ),
                    ],
                  ),
                  StallList(
                    track: track,
                    event: widget.event,
                    onUpdate: widget.onUpdate,
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
