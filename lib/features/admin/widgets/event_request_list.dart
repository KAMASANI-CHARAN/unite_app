import 'package:flutter/material.dart';
import 'event_request_card.dart';
import '../services/event_request_service.dart';

class EventRequestList extends StatelessWidget {
  final String searchQuery;
  final String selectedStatus;
  final EventRequestService requestService;
  final VoidCallback onUpdateRequest;

  const EventRequestList({
    super.key,
    required this.searchQuery,
    required this.selectedStatus,
    required this.requestService,
    required this.onUpdateRequest,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      key: ValueKey('$searchQuery-$selectedStatus'),
      future: requestService.getEventRequests(
        searchQuery: searchQuery,
        selectedStatus: selectedStatus,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }
        if (snapshot.hasError) {
          return _buildErrorState(context, snapshot.error.toString());
        }
        final docs = snapshot.data ?? [];
        if (docs.isEmpty) {
          return _buildEmptyState(context);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index];
            final docId = data['id'];

            return EventRequestCard(
              data: data,
              docId: docId,
              onStatusChanged: (id, status) async {
                await requestService.updateRequestStatus(id, status);
                onUpdateRequest();
              },
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading events...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Failed to load data: $error',
          textAlign: TextAlign.center,
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message;
    if (searchQuery.isNotEmpty && selectedStatus != 'all') {
      message = 'No $selectedStatus events found for "$searchQuery"';
    } else if (searchQuery.isNotEmpty) {
      message = 'No events found for "$searchQuery"';
    } else if (selectedStatus != 'all') {
      message = 'No $selectedStatus events found';
    } else {
      message = 'No event requests found';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
