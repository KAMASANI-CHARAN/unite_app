import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class PaymentRepository {
  final String _baseUrl = 'http://10.0.2.2:3000';

  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Authentication token not found. Please log in.');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<String> createOrder({
    required double amount,
    required String currency,
  }) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$_baseUrl/api/payments/create-order');

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({'amount': amount, 'currency': currency}),
    );

    if (response.headers['content-type']?.contains('application/json') !=
        true) {
      throw FormatException(
        "Server returned a non-JSON response. Check server logs for a 404 or other error.",
      );
    }

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseBody['id'];
    } else {
      throw Exception('Failed to create order: ${responseBody['error']}');
    }
  }

  Future<String> verifyPaymentSignature({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required String eventId,
    required String eventName,
    required String ticketType,
  }) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$_baseUrl/api/payments/verify-signature');

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
        'eventId': eventId,
        'eventName': eventName,
        'ticketType': ticketType,
      }),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseBody['ticketId'];
    } else {
      throw Exception('Payment verification failed: ${responseBody['error']}');
    }
  }
}
