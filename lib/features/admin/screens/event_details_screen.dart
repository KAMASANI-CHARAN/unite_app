import 'package:flutter/material.dart';
import 'package:unite/features/admin/services/event_request_service.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> eventData;
  final String docId;
  final Function(String, String) onStatusChanged;

  const EventDetailsScreen({
    super.key,
    required this.eventData,
    required this.docId,
    required this.onStatusChanged,
  });

  @override
  EventDetailsScreenState createState() => EventDetailsScreenState();
}

class EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _isProcessing = false;
  String? _localStatus;
  final EventRequestService _requestService = EventRequestService();

  @override
  Widget build(BuildContext context) {
    final eventName = widget.eventData['name'] ?? 'Unnamed Event';
    final organizer = widget.eventData['organizer'] ?? 'Unknown Organizer';
    final status = _localStatus ?? (widget.eventData['status'] ?? 'pending');
    final location = widget.eventData['location'] ?? '';
    final type = widget.eventData['type'] ?? '';
    final description = widget.eventData['description'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Organizer: $organizer',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            if (location.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Location: $location',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
            if (type.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Type: $type',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 20),
            Text(description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            _buildStatusOrActions(status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusOrActions(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return _buildStatusMessage(
          'This event has been approved.',
          Colors.green,
          Icons.check_circle,
        );
      case 'rejected':
        return _buildStatusMessage(
          'This event has been rejected.',
          Colors.red,
          Icons.cancel,
        );
      default:
        return _buildApproveRejectButtons();
    }
  }

  Widget _buildStatusMessage(String message, Color color, IconData icon) {
    return Center(
      child: Column(
        children: [
          Icon(icon, color: color, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildApproveRejectButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isProcessing ? null : () => _handleAction('rejected'),
            icon:
                _isProcessing
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.close, color: Colors.red),
            label: Text(
              _isProcessing ? 'Processing...' : 'Reject',
              style: const TextStyle(color: Colors.red),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isProcessing ? null : () => _handleAction('approved'),
            icon:
                _isProcessing
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(Icons.check, color: Colors.white),
            label: Text(_isProcessing ? 'Processing...' : 'Approve'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAction(String action) async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      await _requestService.updateRequestStatus(widget.docId, action);
      setState(() => _localStatus = action);
      widget.onStatusChanged(widget.docId, action);

      messenger.showSnackBar(
        SnackBar(
          content: Text(
            action == 'approved'
                ? '✅ Event approved! User role upgraded.'
                : '❌ Event rejected.',
          ),
          backgroundColor: action == 'approved' ? Colors.green : Colors.red,
        ),
      );
      navigator.pop();
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
