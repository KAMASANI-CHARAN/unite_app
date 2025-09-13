import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketService {
  final FirebaseFirestore _firestore;

  TicketService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<String> _fetchUserFullName(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    return userDoc.data()?['fullName'] ?? 'Unknown User';
  }

  Future<String> createTicket({
    required String eventId,
    required String eventName,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User is not authenticated.');
    }

    final userName = await _fetchUserFullName(user.uid);

    final ticketDoc = await _firestore.collection('user_tickets').add({
      'userId': user.uid,
      'eventId': eventId,
      'ticketName': eventName,
      'userName': userName,
      'userEmail': user.email!,
      'registeredAt': FieldValue.serverTimestamp(),
      'isValidated': false,
    });

    return ticketDoc.id;
  }
}
