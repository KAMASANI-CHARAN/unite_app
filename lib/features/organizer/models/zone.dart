import 'track.dart';

class Zone {
  String name;
  String displayName;
  int order;
  List<Track> tracks;

  Zone({
    required this.name,
    this.displayName = '',
    this.order = 0,
    this.tracks = const [],
  });

  factory Zone.fromMap(Map<String, dynamic> map) {
    return Zone(
      name: map['name'] ?? '',
      displayName: map['displayName'] ?? '',
      order: map['order'] ?? 0,
      tracks:
          (map['tracks'] as List<dynamic>? ?? [])
              .map((trackData) => Track.fromMap(trackData))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'order': order,
      'tracks': tracks.map((track) => track.toMap()).toList(),
    };
  }
}
