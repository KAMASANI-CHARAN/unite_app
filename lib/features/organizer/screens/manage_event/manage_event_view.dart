import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:unite/core/models/app_user.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/presentation/notifier/manage_event_notifier.dart';
import 'package:unite/features/organizer/widgets/acess_denied.dart';
import 'package:unite/features/organizer/screens/ticket_validation_screen.dart';
import 'package:unite/features/organizer/widgets/manage_events/dialogs/add_moderator_dialog.dart';
import 'package:unite/features/organizer/widgets/manage_events/moderator_section.dart';

import 'package:unite/features/organizer/screens/manage_event/sections/details_section.dart';
import 'package:unite/features/organizer/screens/manage_event/sections/structure_section.dart';
import 'package:unite/features/organizer/screens/manage_event/sections/ticketing_section.dart';

class ManageEventView extends StatefulWidget {
  const ManageEventView({super.key});

  @override
  State<ManageEventView> createState() => _ManageEventViewState();
}

class _ManageEventViewState extends State<ManageEventView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _organizerController = TextEditingController();
  final _venueController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _totalSeatsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final notifier = context.read<ManageEventNotifier>();
    notifier.addListener(_onNotifierUpdate);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onNotifierUpdate());
  }

  void _onNotifierUpdate() {
    if (!mounted) return;
    final event = context.read<ManageEventNotifier>().event;
    if (event != null) {
      // FIXED: Added curly braces to all if statements
      if (_titleController.text != event.title) {
        _titleController.text = event.title;
      }
      if (_organizerController.text != event.organizerContact) {
        _organizerController.text = event.organizerContact;
      }
      if (_venueController.text != event.venue) {
        _venueController.text = event.venue;
      }
      if (_descriptionController.text != event.description) {
        _descriptionController.text = event.description;
      }
      if (_totalSeatsController.text != event.totalSeats.toString()) {
        _totalSeatsController.text = event.totalSeats.toString();
      }
    }
  }

  @override
  void dispose() {
    context.read<ManageEventNotifier>().removeListener(_onNotifierUpdate);
    _titleController.dispose();
    _organizerController.dispose();
    _venueController.dispose();
    _descriptionController.dispose();
    _totalSeatsController.dispose();
    super.dispose();
  }

  Future<void> _handleSave({bool publish = false}) async {
    final messenger = ScaffoldMessenger.of(context);
    if (!_formKey.currentState!.validate()) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please fix the errors before saving.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final notifier = context.read<ManageEventNotifier>();
    notifier.updateEventDetails(
      title: _titleController.text,
      organizerContact: _organizerController.text,
      venue: _venueController.text,
      description: _descriptionController.text,
      totalSeats: int.tryParse(_totalSeatsController.text) ?? 0,
    );

    await notifier.updateEvent(publish: publish);

    if (mounted) {
      if (notifier.error == null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(publish ? '🎉 Event Published!' : '💾 Draft Saved!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${notifier.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ManageEventNotifier>();
    final event = notifier.event;
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: _buildAppBar(notifier, event, currentUserId),
      body: _buildBody(notifier, event, currentUserId),
    );
  }

  AppBar _buildAppBar(
    ManageEventNotifier notifier,
    Event? event,
    String? currentUserId,
  ) {
    return AppBar(
      title: Text(
        notifier.isLoading ? 'Loading...' : 'Manage: ${event?.title ?? ''}',
      ),
      actions: [
        if (notifier.isSaving)
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ),
          )
        else if (!notifier.isLoading && event != null)
          TextButton(
            onPressed: () => _handleSave(publish: false),
            child: const Text(
              'Save Draft',
              style: TextStyle(color: Colors.white),
            ),
          ),
        if (!notifier.isLoading &&
            event != null &&
            currentUserId != null &&
            (event.isOrganizer(currentUserId) ||
                event.isModerator(currentUserId)))
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TicketValidationScreen(),
                  ),
                ),
            tooltip: 'Validate Tickets',
          ),
      ],
    );
  }

  Widget _buildBody(
    ManageEventNotifier notifier,
    Event? event,
    String? currentUserId,
  ) {
    if (notifier.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (event == null || currentUserId == null) {
      return Center(
        child: Text(
          'Error: ${notifier.error ?? 'Event not found or user not signed in.'}',
        ),
      );
    }
    if (!event.isOrganizer(currentUserId) &&
        !event.isModerator(currentUserId)) {
      return const AccessDenied();
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          DetailsSection(
            titleController: _titleController,
            organizerController: _organizerController,
            venueController: _venueController,
            descriptionController: _descriptionController,
          ),
          const StructureSection(),
          if (event.isOrganizer(currentUserId))
            _buildSectionCard(
              'Moderators',
              const ModeratorSection(),
              action: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add'),
                onPressed: () async {
                  final userToAdd = await showDialog<AppUser>(
                    context: context,
                    builder: (_) => AddModeratorDialog(notifier: notifier),
                  );
                  if (userToAdd != null) {
                    notifier.addModerator(userToAdd);
                  }
                },
              ),
            ),
          TicketingSection(totalSeatsController: _totalSeatsController),
          const SizedBox(height: 24),
          if (event.isOrganizer(currentUserId))
            ElevatedButton.icon(
              onPressed: () => _handleSave(publish: true),
              icon: const Icon(Icons.publish),
              label: const Text('Publish Event'),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget child, {Widget? action}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                if (action != null) action,
              ],
            ),
            const Divider(height: 24, thickness: 1),
            child,
          ],
        ),
      ),
    );
  }
}
