import 'package:cloud_firestore/cloud_firestore.dart';

class UserTicket {
  final String id;
  final String userId;
  final String eventId;
  final String ticketName;
  final String userName;
  final String userEmail;
  final DateTime registeredAt;
  bool isValidated;

  UserTicket({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.ticketName,
    required this.userName,
    required this.userEmail,
    required this.registeredAt,
    this.isValidated = false,
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

  factory UserTicket.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserTicket.fromJson(data, doc.id);
  }

  factory UserTicket.fromJson(Map<String, dynamic> data, String id) {
    return UserTicket(
      id: id,
      userId: data['userId'] ?? '',
      eventId: data['eventId'] ?? '',
      ticketName: data['ticketName'] ?? '',
      userName: data['userName'] ?? '',
      userEmail: data['userEmail'] ?? '',
      registeredAt: _parseTimestamp(data['registeredAt']),
      isValidated: data['isValidated'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'eventId': eventId,
      'ticketName': ticketName,
      'userName': userName,
      'userEmail': userEmail,
      'registeredAt': Timestamp.fromDate(registeredAt),
      'isValidated': isValidated,
    };
  }
}
