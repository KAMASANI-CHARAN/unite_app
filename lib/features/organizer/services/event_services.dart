import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  final CollectionReference _eventsCollection = FirebaseFirestore.instance
      .collection('events');

  Future<Event> fetchEvent(String eventId) async {
    final doc = await _eventsCollection.doc(eventId).get();
    if (!doc.exists) {
      throw Exception('Event not found');
    }
    return Event.fromFirestore(doc);
  }

  Future<void> updateEvent(Event event) async {
    await _eventsCollection.doc(event.id).update(event.toFirestore());
  }

  Future<void> createEvent(Event event) async {
    await _eventsCollection.doc(event.id).set(event.toFirestore());
  }

  Future<void> publishEvent(Event event) async {
    await _eventsCollection.doc(event.id).update({'status': 'published'});
  }
}
