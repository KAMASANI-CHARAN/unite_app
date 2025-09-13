import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unite/features/organizer/models/zone.dart';
import 'package:unite/features/organizer/models/ticket.dart';

class Event {
  final String id;
  String title;
  String description;
  String status;
  String createdBy;

  DateTime? startDate;
  DateTime? endDate;
  String venue;
  String organizerContact;
  String eventType;

  int totalSeats;
  List<Ticket> ticketTypes;

  List<Zone> zones;

  Event({
    required this.id,
    required this.title,
    required this.createdBy,
    this.description = '',
    this.status = 'draft',
    this.startDate,
    this.endDate,
    this.venue = 'Online',
    this.organizerContact = '',
    this.eventType = 'Conference',
    this.totalSeats = 0,
    this.ticketTypes = const [],
    this.zones = const [],
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      createdBy: data['createdBy'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'draft',
      startDate: (data['startDate'] as Timestamp?)?.toDate(),
      endDate: (data['endDate'] as Timestamp?)?.toDate(),
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'createdBy': createdBy,
      'description': description,
      'status': status,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'venue': venue,
      'organizerContact': organizerContact,
      'eventType': eventType,
      'totalSeats': totalSeats,
      'ticketTypes': ticketTypes.map((ticket) => ticket.toMap()).toList(),
      'zones': zones.map((zone) => zone.toMap()).toList(),
    };
  }
}
