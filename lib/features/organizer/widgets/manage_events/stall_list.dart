import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/models/track.dart';

class StallList extends StatelessWidget {
  final Track track;
  final Event event;
  final VoidCallback onUpdate;

  const StallList({
    super.key,
    required this.track,
    required this.event,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          track.stalls.map((stall) {
            return ListTile(
              title: Text(stall.name),
              subtitle: Text('Booth: ${stall.boothNumber}'),
            );
          }).toList(),
    );
  }
}
