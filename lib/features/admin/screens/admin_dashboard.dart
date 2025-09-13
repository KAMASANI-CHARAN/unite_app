import 'package:flutter/material.dart';
import 'package:unite/features/admin/widgets/admin_app_bar.dart';
import 'package:unite/features/admin/widgets/admin_search_bar.dart';
import 'package:unite/features/admin/widgets/event_request_list.dart';
import 'package:unite/features/admin/widgets/status_filter.dart';
import 'package:unite/features/admin/services/event_request_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final EventRequestService _requestService = EventRequestService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';

  void _refreshList() {
    setState(() {});
  }

  void _onSearchChanged(String query) {
    setState(() {});
  }

  void _onStatusChanged(String status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Admin Dashboard',
        onSearchChanged: (query) {
          _onSearchChanged(query);
        },
      ),
      body: Column(
        children: [
          AdminSearchBar(
            controller: _searchController,
            onClear: () {
              _searchController.clear();
              _onSearchChanged('');
            },
            onChanged: _onSearchChanged,
          ),
          StatusFilter(
            selectedStatus: _selectedStatus,
            onStatusChanged: _onStatusChanged,
          ),
          Expanded(
            child: EventRequestList(
              searchQuery: _searchController.text,
              selectedStatus: _selectedStatus,
              requestService: _requestService,
              onUpdateRequest: _refreshList,
            ),
          ),
        ],
      ),
    );
  }
}
