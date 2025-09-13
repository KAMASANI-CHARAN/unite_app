import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/core/models/app_user.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final String _baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Not authenticated.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  @override
  Future<List<AppUser>> searchUsersByName(String nameQuery) async {
    if (nameQuery.isEmpty) {
      return [];
    }

    final headers = await _getAuthHeaders();
    final uri = Uri.parse(
      '$_baseUrl/api/users/search',
    ).replace(queryParameters: {'name': nameQuery});

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AppUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search users: ${response.body}');
    }
  }

  @override
  Future<List<AppUser>> fetchUsersByIds(List<String> uids) async {
    if (uids.isEmpty) {
      return [];
    }

    final headers = await _getAuthHeaders();
    final uri = Uri.parse('$_baseUrl/api/users/batch-fetch');

    final response = await http.post(
      uri,
      headers: headers,
      body: json.encode({'uids': uids}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => AppUser.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch users: ${response.body}');
    }
  }
}
