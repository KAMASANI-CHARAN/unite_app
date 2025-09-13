abstract class PaymentService {
  void init();
  void openCheckout({
    required double amount,
    required String eventName,
    required String userEmail,
    required String userPhone,
    required Function(String) onSuccess,
    required Function(String) onError,
  });
  void dispose();
}
