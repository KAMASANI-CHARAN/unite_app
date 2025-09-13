// lib/features/organizer/widgets/manage_events/sections/details_section.dart
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/organizer/models/event.dart';
import 'package:unite/features/organizer/presentation/notifier/manage_event_notifier.dart';

class DetailsSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController organizerController;
  final TextEditingController venueController;
  final TextEditingController descriptionController;

  const DetailsSection({
    super.key,
    required this.titleController,
    required this.organizerController,
    required this.venueController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    final event = context.watch<ManageEventNotifier>().event!;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Details',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Divider(height: 24, thickness: 1),
            _EventImagePicker(event: event),
            const SizedBox(height: 24),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
              validator: (value) => value!.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: organizerController,
              decoration: const InputDecoration(labelText: 'Organizer Contact'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: venueController,
              decoration: const InputDecoration(labelText: 'Venue / Location'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateTimePicker(
                    label: 'Start Date',
                    initialDate: event.startDate,
                    onDateChanged:
                        (date) => context.read<ManageEventNotifier>().setDates(
                          start: date,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTimePicker(
                    label: 'End Date',
                    initialDate: event.endDate,
                    onDateChanged:
                        (date) => context.read<ManageEventNotifier>().setDates(
                          end: date,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EventImagePicker extends StatelessWidget {
  final Event event;
  const _EventImagePicker({required this.event});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && context.mounted) {
      context.read<ManageEventNotifier>().setPickedImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ManageEventNotifier>();
    ImageProvider? imageProvider;
    if (notifier.pickedImage != null) {
      if (kIsWeb) {
        imageProvider = NetworkImage(notifier.pickedImage!.path);
      } else {
        imageProvider = FileImage(notifier.pickedImage!);
      }
    } else if (event.imageUrl != null && event.imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(event.imageUrl!);
    }

    return InkWell(
      onTap: () => _pickImage(context),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          image:
              imageProvider != null
                  ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                  : null,
        ),
        child:
            imageProvider == null
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Tap to add event image',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
                : null,
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? initialDate;
  final Function(DateTime) onDateChanged;

  const _DateTimePicker({
    required this.label,
    this.initialDate,
    required this.onDateChanged,
  });

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate == null) return;
    if (!context.mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
    );
    if (pickedTime != null) {
      onDateChanged(
        DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(initialDate),
      initialValue:
          initialDate != null
              ? DateFormat.yMd().add_jm().format(initialDate!)
              : '',
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }
}
