import 'package:unite/features/organizer/models/event.dart';

abstract class EventRepository {
  Future<Event> fetchEvent(String eventId);
  Future<void> updateEvent(Event event);
  Future<List<Event>> fetchPublicEventsByIds(List<String> eventIds);
}
