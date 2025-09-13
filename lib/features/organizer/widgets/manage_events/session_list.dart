import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/models/track.dart';

class SessionList extends StatelessWidget {
  final Track track;
  final Event event;
  final VoidCallback onUpdate;

  const SessionList({
    super.key,
    required this.track,
    required this.event,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          track.sessions.map((session) {
            return ListTile(
              title: Text(session.title),
              subtitle: Text(session.sessionType),
            );
          }).toList(),
    );
  }
}
