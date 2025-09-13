import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class EventRequestService {
  final String _baseUrl = 'http://10.0.2.2:3000';

  Future<List<Map<String, dynamic>>> getEventRequests({
    required String searchQuery,
    required String selectedStatus,
  }) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Authentication token not found.');
    }

    final uri = Uri.parse('$_baseUrl/api/event-requests').replace(
      queryParameters: {'search': searchQuery, 'status': selectedStatus},
    );

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load event requests: ${response.body}');
    }
  }

  Future<void> updateRequestStatus(String docId, String status) async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Not authenticated.');
    }

    final uri = Uri.parse('$_baseUrl/api/event-requests/$docId');
    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'status': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update status: ${response.body}');
    }
  }
}
