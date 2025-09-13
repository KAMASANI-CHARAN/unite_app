import 'package:flutter/material.dart';

class TicketSheetFooter extends StatelessWidget {
  final TextEditingController phoneController;
  final double totalAmount;
  final bool isProcessing;
  final VoidCallback onProceedToPayment;

  const TicketSheetFooter({
    super.key,
    required this.phoneController,
    required this.totalAmount,
    required this.isProcessing,
    required this.onProceedToPayment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        TextFormField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length != 10) {
              return 'Please enter a valid 10-digit phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        const Divider(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total:', style: theme.textTheme.titleLarge),
            Text(
              '₹${totalAmount.toStringAsFixed(2)}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                (totalAmount > 0 && !isProcessing) ? onProceedToPayment : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child:
                isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Proceed to Pay'),
          ),
        ),
      ],
    );
  }
}
