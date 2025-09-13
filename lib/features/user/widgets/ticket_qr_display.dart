import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQrDisplay extends StatelessWidget {
  final String ticketId;

  const TicketQrDisplay({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QrImageView(data: ticketId, version: QrVersions.auto, size: 200.0),
        const SizedBox(height: 16),
        Text(
          'Scan this QR code to validate your ticket',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
