import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/user/widgets/empty_state.dart';
import 'package:unite/features/user/widgets/home/home_event_card.dart';
import 'package:unite/features/user/widgets/styles/navbar_color.dart';

class HomeEventList extends StatefulWidget {
  const HomeEventList({super.key});

  @override
  State<HomeEventList> createState() => _HomeEventListState();
}

class _HomeEventListState extends State<HomeEventList>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: _SearchBar(controller: _searchController),
        backgroundColor: AppColors.primary,
        toolbarHeight: 80,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('events')
                .where('status', isEqualTo: 'published')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final allDocs = snapshot.data?.docs ?? [];
          final filteredDocs =
              allDocs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final title = data['title']?.toString().toLowerCase() ?? '';
                final description =
                    data['description']?.toString().toLowerCase() ?? '';
                final searchQueryLower = _searchQuery.toLowerCase();
                return title.contains(searchQueryLower) ||
                    description.contains(searchQueryLower);
              }).toList();

          if (filteredDocs.isEmpty) {
            return const EmptyState(
              title: 'No Events Found',
              subtitle: 'Check back later for exciting new events!',
              icon: Icons.event_busy,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final eventDoc = filteredDocs[index];
              final event = Event.fromFirestore(eventDoc);
              return HomeEventCard(event: event);
            },
          );
        },
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(51),
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Search events...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
