import 'session.dart';
import 'stall.dart';

class Track {
  String name;
  String displayName;
  int order;
  List<Session> sessions;
  List<Stall> stalls;

  Track({
    required this.name,
    this.displayName = '',
    this.order = 0,
    this.sessions = const [],
    this.stalls = const [],
  });

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      name: map['name'] ?? '',
      displayName: map['displayName'] ?? '',
      order: map['order'] ?? 0,
      sessions:
          (map['sessions'] as List<dynamic>? ?? [])
              .map((sessionData) => Session.fromMap(sessionData))
              .toList(),
      stalls:
          (map['stalls'] as List<dynamic>? ?? [])
              .map((stallData) => Stall.fromMap(stallData))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'displayName': displayName,
      'order': order,
      'sessions': sessions.map((session) => session.toMap()).toList(),
      'stalls': stalls.map((stall) => stall.toMap()).toList(),
    };
  }
}
