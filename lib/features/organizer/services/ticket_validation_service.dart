import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unite/core/models/user_ticket.dart';

class TicketValidationService {
  final FirebaseFirestore _firestore;

  TicketValidationService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserTicket> getTicket(String ticketId) async {
    try {
      final doc =
          await _firestore.collection('user_tickets').doc(ticketId).get();
      if (!doc.exists) {
        throw Exception('Ticket not found.');
      }
      return UserTicket.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch ticket: $e');
    }
  }

  Future<void> validateTicket(String ticketId) async {
    try {
      await _firestore.collection('user_tickets').doc(ticketId).update({
        'isValidated': true,
        'validatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to validate ticket: $e');
    }
  }
}
