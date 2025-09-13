import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final String _baseUrl = 'http://10.0.2.2:3000';

  Future<String> _getAuthToken() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Not authenticated.');
    }
    return token;
  }

  @override
  Future<Event> fetchEvent(String eventId) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/api/events/$eventId');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return Event.fromJson(responseBody, responseBody['id']);
    } else {
      throw Exception(
        'Failed to fetch event: ${responseBody['error'] ?? response.body}',
      );
    }
  }

  @override
  Future<void> updateEvent(Event event) async {
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/api/events/${event.id}');

    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(event.toFirestore()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update event: ${response.body}');
    }
  }

  @override
  Future<List<Event>> fetchPublicEventsByIds(List<String> eventIds) async {
    if (eventIds.isEmpty) {
      return [];
    }
    final token = await _getAuthToken();
    final uri = Uri.parse('$_baseUrl/api/events/batch-fetch-public');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'eventIds': eventIds}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Event.fromJson(json, json['id'])).toList();
    } else {
      throw Exception('Failed to fetch registered events: ${response.body}');
    }
  }
}
