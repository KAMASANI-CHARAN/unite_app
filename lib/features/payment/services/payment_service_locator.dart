import 'payment_service_stub.dart'
    if (dart.library.html) 'payment_service_web.dart';

import 'payment_service.dart';
import 'payment_service_mobile.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PaymentServiceLocator {
  static PaymentService getService() {
    if (kIsWeb) {
      return getPaymentService();
    } else {
      return MobilePaymentService();
    }
  }
}
