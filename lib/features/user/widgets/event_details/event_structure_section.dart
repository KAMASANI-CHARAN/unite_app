import 'package:flutter/material.dart';
import 'package:unite/core/utils/date_utils.dart' as app_date_utils;
import 'package:unite/features/organizer/models/zone.dart';
import 'package:unite/features/organizer/models/track.dart';
import 'package:unite/features/organizer/models/session.dart';
import 'package:unite/features/organizer/models/stall.dart';

class EventStructureSection extends StatelessWidget {
  final List<Zone> zones;
  const EventStructureSection({super.key, required this.zones});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: zones.map((zone) => _buildZoneDetails(context, zone)).toList(),
    );
  }

  Widget _buildZoneDetails(BuildContext context, Zone zone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4.0),
          child: Text(
            zone.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        ...zone.tracks.map((track) => _buildTrackDetails(context, track)),
        const Divider(height: 16, color: Colors.grey),
      ],
    );
  }

  Widget _buildTrackDetails(BuildContext context, Track track) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 4.0, bottom: 2.0),
          child: Text(
            track.name,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        ...track.sessions.map((session) => _buildSessionTile(session)),
        ...track.stalls.map((stall) => _buildStallTile(stall)),
      ],
    );
  }

  Widget _buildSessionTile(Session session) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.mic, size: 18, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${session.speaker} | ${app_date_utils.DateUtils.formatDate(session.startTime)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStallTile(Stall stall) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.store, color: Colors.brown),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stall.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Booth: ${stall.boothNumber}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
