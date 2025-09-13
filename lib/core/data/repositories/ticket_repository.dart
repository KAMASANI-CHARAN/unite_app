import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/core/models/user_ticket.dart';

class TicketRepository {
  final String _baseUrl = 'http://10.0.2.2:3000';

  Future<List<UserTicket>> getUserTickets() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return [];
    }

    final token = await user.getIdToken();
    final uri = Uri.parse('$_baseUrl/api/tickets');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserTicket.fromJson(json, json['id'])).toList();
    } else {
      throw Exception('Failed to load tickets: ${response.body}');
    }
  }
}
