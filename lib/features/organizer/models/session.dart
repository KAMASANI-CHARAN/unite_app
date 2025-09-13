import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  String title;
  String speaker;
  DateTime startTime;
  DateTime endTime;
  String sessionType;
  String description;

  Session({
    required this.title,
    required this.speaker,
    required this.startTime,
    required this.endTime,
    this.sessionType = 'Talk',
    this.description = '',
  });

  static DateTime _parseTimestamp(dynamic timestampData) {
    if (timestampData is Timestamp) {
      return timestampData.toDate();
    }
    if (timestampData is Map) {
      return Timestamp(
        timestampData['_seconds'],
        timestampData['_nanoseconds'],
      ).toDate();
    }
    return DateTime.parse(timestampData as String);
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      title: map['title'] ?? '',
      speaker: map['speaker'] ?? '',
      startTime: _parseTimestamp(map['start_time']),
      endTime: _parseTimestamp(map['end_time']),
      sessionType: map['session_type'] ?? 'Talk',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'speaker': speaker,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'session_type': sessionType,
      'description': description,
    };
  }
}
