// lib/features/organizer/widgets/manage_events/sections/structure_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/organizer/models/session.dart';
import 'package:unite/features/organizer/models/stall.dart';
import 'package:unite/features/organizer/models/track.dart';
import 'package:unite/features/organizer/models/zone.dart';
import 'package:unite/features/organizer/presentation/notifier/manage_event_notifier.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/session_dialog.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/stall_dialog.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/track_dialog.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/zone_dialog.dart';

class StructureSection extends StatelessWidget {
  const StructureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ManageEventNotifier>();
    final event = notifier.event!;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Structure',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Divider(height: 24, thickness: 1),
            if (event.zones.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    'No zones created yet.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ...event.zones.map((zone) => _buildZoneCard(context, zone)),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Zone'),
                onPressed: () => _addZone(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZoneCard(BuildContext context, Zone zone) {
    final notifier = context.read<ManageEventNotifier>();
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text(
              zone.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => notifier.removeZone(zone),
            ),
          ),
          const Divider(height: 1),
          ...zone.tracks.map((track) => _buildTrackTile(context, zone, track)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Track'),
              onPressed: () => _addTrack(context, zone),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackTile(BuildContext context, Zone zone, Track track) {
    final notifier = context.read<ManageEventNotifier>();
    return ExpansionTile(
      title: Text(
        track.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
        onPressed: () => notifier.removeTrack(zone, track),
      ),
      children: [
        if (track.sessions.isEmpty && track.stalls.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'No sessions or stalls in this track yet.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ...track.sessions.map((s) => _buildSessionTile(context, track, s)),
        ...track.stalls.map((s) => _buildStallTile(context, track, s)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => _addSession(context, track),
              child: const Text('Add Session'),
            ),
            TextButton(
              onPressed: () => _addStall(context, track),
              child: const Text('Add Stall'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSessionTile(BuildContext context, Track track, Session session) {
    final notifier = context.read<ManageEventNotifier>();
    return ListTile(
      title: Text(session.title),
      subtitle: Text('Speaker: ${session.speaker}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => notifier.removeSession(track, session),
      ),
    );
  }

  Widget _buildStallTile(BuildContext context, Track track, Stall stall) {
    final notifier = context.read<ManageEventNotifier>();
    return ListTile(
      title: Text(stall.name),
      subtitle: Text('Booth: ${stall.boothNumber}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => notifier.removeStall(track, stall),
      ),
    );
  }

  void _addZone(BuildContext context) async {
    final newZone = await showDialog<Zone>(
      context: context,
      builder: (_) => const ZoneDialog(),
    );
    if (newZone != null && context.mounted) {
      context.read<ManageEventNotifier>().addZone(newZone);
    }
  }

  void _addTrack(BuildContext context, Zone zone) async {
    final newTrack = await showDialog<Track>(
      context: context,
      builder: (_) => const TrackDialog(),
    );
    if (newTrack != null && context.mounted) {
      context.read<ManageEventNotifier>().addTrack(zone, newTrack);
    }
  }

  void _addSession(BuildContext context, Track track) async {
    final newSession = await showDialog<Session>(
      context: context,
      builder: (_) => const SessionDialog(),
    );
    if (newSession != null && context.mounted) {
      context.read<ManageEventNotifier>().addSession(track, newSession);
    }
  }

  void _addStall(BuildContext context, Track track) async {
    final newStall = await showDialog<Stall>(
      context: context,
      builder: (_) => const StallDialog(),
    );
    if (newStall != null && context.mounted) {
      context.read<ManageEventNotifier>().addStall(track, newStall);
    }
  }
}
