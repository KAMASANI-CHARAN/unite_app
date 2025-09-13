import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'payment_service.dart';

class MobilePaymentService implements PaymentService {
  late Razorpay _razorpay;

  late Function(String) _onSuccess;
  late Function(String) _onError;

  @override
  void init() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void openCheckout({
    required double amount,
    required String eventName,
    required String userEmail,
    required String userPhone,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    _onSuccess = onSuccess;
    _onError = onError;

    var options = {
      'key': 'rzp_test_R6iz7xaar3hcz1',
      'amount': amount * 100,
      'name': 'Unite Events',
      'description': 'Ticket for $eventName',
      'prefill': {'contact': userPhone, 'email': userEmail},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onSuccess(response.paymentId!);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _onError('Code: ${response.code} - ${response.message}');
  }

  @override
  void dispose() {
    _razorpay.clear();
  }
}
