import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unite/features/organizer/models/zone.dart';
import 'package:unite/features/organizer/models/ticket.dart';

class Event {
  final String id;
  String title;
  String description;
  String status;
  final String createdBy;
  String? imageUrl;

  DateTime? startDate;
  DateTime? endDate;
  String venue;
  String organizerContact;
  String eventType;

  int totalSeats;
  List<Ticket> ticketTypes;
  List<Zone> zones;

  List<String> moderatorUids;
  final List<String> managerUids;

  Event({
    required this.id,
    required this.title,
    required this.createdBy,
    this.description = '',
    this.status = 'draft',
    this.imageUrl,
    this.startDate,
    this.endDate,
    this.venue = 'Online',
    this.organizerContact = '',
    this.eventType = 'Conference',
    this.totalSeats = 0,
    this.ticketTypes = const [],
    this.zones = const [],
    this.moderatorUids = const [],
    this.managerUids = const [],
  });

  bool isOrganizer(String userId) => createdBy == userId;
  bool isModerator(String userId) => moderatorUids.contains(userId);

  static DateTime? _parseTimestamp(dynamic timestampData) {
    if (timestampData == null) return null;
    if (timestampData is Timestamp) return timestampData.toDate();
    if (timestampData is Map) {
      return Timestamp(
        timestampData['_seconds'],
        timestampData['_nanoseconds'],
      ).toDate();
    }
    if (timestampData is String) return DateTime.tryParse(timestampData);
    return null;
  }

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event.fromJson(data, doc.id);
  }

  factory Event.fromJson(Map<String, dynamic> data, String id) {
    return Event(
      id: id,
      title: data['title'] ?? '',
      createdBy: data['createdBy'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'draft',
      imageUrl: data['imageUrl'],
      startDate: _parseTimestamp(data['startDate']),
      endDate: _parseTimestamp(data['endDate']),
      venue: data['venue'] ?? 'Online',
      organizerContact: data['organizerContact'] ?? '',
      eventType: data['eventType'] ?? 'Conference',
      totalSeats: data['totalSeats'] ?? 0,
      ticketTypes:
          (data['ticketTypes'] as List<dynamic>? ?? [])
              .map((ticketData) => Ticket.fromMap(ticketData))
              .toList(),
      zones:
          (data['zones'] as List<dynamic>? ?? [])
              .map((zoneData) => Zone.fromMap(zoneData))
              .toList(),
      moderatorUids: List<String>.from(data['moderatorUids'] ?? []),
      managerUids: List<String>.from(data['managerUids'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'createdBy': createdBy,
      'description': description,
      'status': status,
      'imageUrl': imageUrl,

      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'venue': venue,
      'organizerContact': organizerContact,
      'eventType': eventType,
      'totalSeats': totalSeats,
      'ticketTypes': ticketTypes.map((ticket) => ticket.toMap()).toList(),
      'zones': zones.map((zone) => zone.toMap()).toList(),
      'moderatorUids': moderatorUids,
      'managerUids': managerUids,
    };
  }
}
