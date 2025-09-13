import 'package:cloud_firestore/cloud_firestore.dart';

class EventService {
  final FirebaseFirestore _firestore;

  EventService(this._firestore);

  Stream<QuerySnapshot> getApprovedEvents(String userEmail) {
    return _firestore
        .collection('event_requests')
        .where('status', isEqualTo: 'approved')
        .where('userEmail', isEqualTo: userEmail)
        .snapshots();
  }

  Stream<QuerySnapshot> getPublicEvents() {
    return _firestore
        .collection('events')
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> registerForEvent({
    required String userId,
    required String userEmail,
    required String eventId,
    required String eventName,
  }) async {
    await _firestore.collection('event_registrations').add({
      'userId': userId,
      'userEmail': userEmail,
      'eventId': eventId,
      'eventName': eventName,
      'registeredAt': FieldValue.serverTimestamp(),
      'status': 'active',
    });
  }
}
