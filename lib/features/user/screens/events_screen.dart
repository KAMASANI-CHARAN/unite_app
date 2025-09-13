import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/user/screens/events/discover_events.dart';
import 'package:unite/features/user/screens/events/registered_events.dart';
import 'package:unite/features/user/screens/events/my_events.dart';
import 'package:unite/features/user/services/event_service.dart';
import 'package:unite/features/user/widgets/event_form/event_request_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventsScreen extends StatefulWidget {
  final String userRole;
  const EventsScreen({super.key, required this.userRole});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  final List<Tab> _tabs = [];
  final List<Widget> _tabViews = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _buildTabsForRole(widget.userRole);
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  void _buildTabsForRole(String role) {
    _tabs.clear();
    _tabViews.clear();

    if (role == 'organizer') {
      _tabs.addAll(const [
        Tab(text: 'My Events'),
        Tab(text: 'Registered'),
        Tab(text: 'Discover'),
      ]);
      _tabViews.addAll(const [
        MyEvents(),
        RegisteredEventsTab(),
        DiscoverEventsTab(),
      ]);
    } else {
      _tabs.addAll(const [Tab(text: 'Registered'), Tab(text: 'Discover')]);
      _tabViews.addAll(const [RegisteredEventsTab(), DiscoverEventsTab()]);
    }
  }

  @override
  void didUpdateWidget(covariant EventsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userRole != oldWidget.userRole) {
      _buildTabsForRole(widget.userRole);
      _tabController = TabController(length: _tabs.length, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showEventRequestForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const EventRequestForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isRegularUser = widget.userRole == 'user';
    final isMyEventsTab = _tabController.index == 0;

    return Provider(
      create: (_) => EventService(FirebaseFirestore.instance),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
          bottom: TabBar(
            controller: _tabController,
            tabs: _tabs,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(controller: _tabController, children: _tabViews),
        floatingActionButton:
            isRegularUser && isMyEventsTab
                ? FloatingActionButton.extended(
                  onPressed: _showEventRequestForm,
                  label: const Text('Create Event Request'),
                  icon: const Icon(Icons.add),
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                )
                : widget.userRole == 'organizer' && isMyEventsTab
                ? FloatingActionButton.extended(
                  onPressed: _showEventRequestForm,
                  label: const Text('Create Event'),
                  icon: const Icon(Icons.add),
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                )
                : null,
      ),
    );
  }
}
