import 'dart:js_interop';
import 'payment_service.dart';

@JS('Razorpay')
extension type _Razorpay(JSObject o) {
  @JS('new')
  external static _Razorpay create(_RazorpayOptions options);

  external void open();
}

@JS()
@anonymous
extension type _RazorpayOptions(JSObject o) {
  external set key(JSString v);
  external set amount(JSNumber v);
  external set name(JSString v);
  external set description(JSString v);

  external set prefill(_Prefill v);
  external set handler(JSFunction v);

  external set modal(_Modal v);
}

@JS()
@anonymous
extension type _Prefill(JSObject o) {
  external set contact(JSString v);
  external set email(JSString v);
}

@JS()
@anonymous
extension type _Modal(JSObject o) {
  external set ondismiss(JSFunction v);
}

@JS()
@anonymous
extension type _PaymentResponse(JSObject o) {
  @JS('razorpay_payment_id')
  external JSString get paymentId;
}

PaymentService getPaymentService() => WebPaymentService();

class WebPaymentService implements PaymentService {
  @override
  void init() {}

  @override
  void openCheckout({
    required double amount,
    required String eventName,
    required String userEmail,
    required String userPhone,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) {
    final prefill = JSObject() as _Prefill;
    prefill.contact = userPhone.toJS;
    prefill.email = userEmail.toJS;

    final modal = JSObject() as _Modal;
    modal.ondismiss =
        () {
          onError('Payment window closed.');
        }.toJS;

    final options = JSObject() as _RazorpayOptions;
    options.key = 'rzp_test_R6iz7xaar3hcz1'.toJS;
    options.amount = (amount * 100).toJS;
    options.name = 'Unite Events'.toJS;
    options.description = 'Ticket for $eventName'.toJS;
    options.prefill = prefill;
    options.modal = modal;
    options.handler =
        (JSAny response) {
          final paymentResponse = response as _PaymentResponse;
          onSuccess(paymentResponse.paymentId.toDart);
        }.toJS;

    _Razorpay.create(options).open();
  }

  @override
  void dispose() {}
}
