import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitEventRequest({
    required String name,
    required String type,
    required String organizer,
    required String location,
    required String description,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;

    await _firestore.collection('event_requests').add({
      'name': name,
      'type': type,
      'organizer': organizer,
      'location': location,
      'description': description,
      'status': 'pending',
      'userId': user.uid,
      'userEmail': user.email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
