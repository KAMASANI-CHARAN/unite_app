import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/models/ticket.dart';
import 'package:unite/features/payment/data/repositories/payment_repository.dart';
import 'package:unite/features/user/screens/tickets/ticket_details_screen.dart';
import 'ticket_selection_sheet/ticket_list_view.dart';
import 'ticket_selection_sheet/ticket_sheet_footer.dart';

class TicketSelectionSheet extends StatefulWidget {
  final Event event;
  const TicketSelectionSheet({super.key, required this.event});

  @override
  State<TicketSelectionSheet> createState() => _TicketSelectionSheetState();
}

class _TicketSelectionSheetState extends State<TicketSelectionSheet> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  late final Map<String, int> _ticketQuantities;
  double _totalAmount = 0.0;
  bool _isProcessing = false;

  final PaymentRepository _paymentRepository = PaymentRepository();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _ticketQuantities = {
      for (var ticket in widget.event.ticketTypes) ticket.name: 0,
    };
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateState() {
    double total = 0;
    for (var ticket in widget.event.ticketTypes) {
      total += (_ticketQuantities[ticket.name] ?? 0) * ticket.price;
    }
    setState(() {
      _totalAmount = total;
    });
  }

  void _increment(Ticket ticket) {
    if ((_ticketQuantities[ticket.name] ?? 0) < ticket.quantity) {
      setState(() {
        _ticketQuantities[ticket.name] =
            (_ticketQuantities[ticket.name] ?? 0) + 1;
      });
      _updateState();
    }
  }

  void _decrement(Ticket ticket) {
    if ((_ticketQuantities[ticket.name] ?? 0) > 0) {
      setState(() {
        _ticketQuantities[ticket.name] =
            (_ticketQuantities[ticket.name] ?? 0) - 1;
      });
      _updateState();
    }
  }

  void _proceedToPayment() async {
    if (!_formKey.currentState!.validate() || _isProcessing) {
      debugPrint('Validation failed or already processing.');
      return;
    }

    setState(() => _isProcessing = true);
    debugPrint('Step 1: Starting payment process...');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in.');

      debugPrint('Step 2: Creating order on backend for amount: $_totalAmount');
      final orderId = await _paymentRepository.createOrder(
        amount: _totalAmount,
        currency: 'INR',
      );
      debugPrint('Step 3: Backend returned Order ID: $orderId');

      var options = {
        'key': 'rzp_test_R6iz7xaar3hcz1',
        'amount': _totalAmount * 100,
        'name': 'Unite Events',
        'order_id': orderId,
        'description': 'Ticket for ${widget.event.title}',
        'prefill': {'contact': _phoneController.text, 'email': user.email},
      };

      debugPrint('Step 4: Opening Razorpay checkout...');
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error during _proceedToPayment: $e');
      _handlePaymentError(PaymentFailureResponse(0, e.toString(), null));
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    debugPrint('Payment Success! Verifying signature with backend...');
    setState(() => _isProcessing = true); // Keep loading indicator
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      final selectedTicket = _ticketQuantities.entries.firstWhere(
        (e) => e.value > 0,
      );
      final ticketId = await _paymentRepository.verifyPaymentSignature(
        razorpayOrderId: response.orderId!,
        razorpayPaymentId: response.paymentId!,
        razorpaySignature: response.signature!,
        eventId: widget.event.id,
        eventName: widget.event.title,
        ticketType: selectedTicket.key,
      );
      debugPrint('Backend verification successful! New Ticket ID: $ticketId');
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('✅ Payment successful! Here is your ticket.'),
          backgroundColor: Colors.green,
        ),
      );
      navigator.push(
        MaterialPageRoute(
          builder: (_) => TicketDetailsScreen(ticketId: ticketId),
        ),
      );
    } catch (e) {
      debugPrint('Error during backend verification: $e');
      messenger.showSnackBar(
        SnackBar(
          content: Text('❌ Verification Failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    debugPrint(
      'Payment Failed! Code: ${response.code}, Message: ${response.message}',
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Payment Failed: ${response.message}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => _isProcessing = false);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('External Wallet: ${response.walletName}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Tickets', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              widget.event.title,
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
            ),
            const Divider(height: 32),
            TicketListView(
              event: widget.event,
              ticketQuantities: _ticketQuantities,
              onIncrement: _increment,
              onDecrement: _decrement,
            ),
            TicketSheetFooter(
              phoneController: _phoneController,
              totalAmount: _totalAmount,
              isProcessing: _isProcessing,
              onProceedToPayment: _proceedToPayment,
            ),
          ],
        ),
      ),
    );
  }
}
