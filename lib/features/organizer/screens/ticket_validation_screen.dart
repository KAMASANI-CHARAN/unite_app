import 'package:flutter/material.dart';
import 'package:unite/features/organizer/services/ticket_validation_service.dart';
import 'package:unite/core/models/user_ticket.dart';
import 'qr_scanner_screen.dart';

class TicketValidationScreen extends StatefulWidget {
  const TicketValidationScreen({super.key});

  @override
  State<TicketValidationScreen> createState() => _TicketValidationScreenState();
}

class _TicketValidationScreenState extends State<TicketValidationScreen> {
  final _ticketIdController = TextEditingController();
  final _validationService = TicketValidationService();

  UserTicket? _currentTicket;
  String? _statusMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _ticketIdController.dispose();
    super.dispose();
  }

  Future<void> _fetchAndValidateTicket({String? ticketId}) async {
    final idToValidate = ticketId ?? _ticketIdController.text.trim();
    if (idToValidate.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter or scan a ticket ID.';
        _currentTicket = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
      _currentTicket = null;
    });

    try {
      final ticket = await _validationService.getTicket(idToValidate);

      setState(() {
        _currentTicket = ticket;
        if (ticket.isValidated) {
          _statusMessage = 'Ticket has already been validated.';
        } else {
          _statusMessage = 'Ticket found. Ready to validate.';
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: Ticket not found or an error occurred.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _validateCurrentTicket() async {
    if (_currentTicket == null || _currentTicket!.isValidated) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _validationService.validateTicket(_currentTicket!.id);

      setState(() {
        _currentTicket!.isValidated = true;
        _statusMessage = 'Ticket successfully validated!';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket validated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: Failed to validate ticket.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _scanQrCode() async {
    final scannedId = await Navigator.push<String?>(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (scannedId != null) {
      _ticketIdController.text = scannedId;
      await _fetchAndValidateTicket(ticketId: scannedId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Validation'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ticketIdController,
              decoration: const InputDecoration(
                labelText: 'Enter Ticket ID',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _fetchAndValidateTicket(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        _isLoading ? null : () => _fetchAndValidateTicket(),
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _scanQrCode,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Scan QR Code'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            if (_statusMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  _statusMessage!,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            if (_currentTicket != null) _buildTicketDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketDetailsCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                'Ticket: ${_currentTicket!.ticketName}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'User: ${_currentTicket!.userName} (${_currentTicket!.userEmail})',
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child:
                  _currentTicket!.isValidated
                      ? Text(
                        'This ticket has been validated.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.red),
                      )
                      : ElevatedButton.icon(
                        onPressed: _validateCurrentTicket,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Validate Ticket'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
