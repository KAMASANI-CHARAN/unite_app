import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/session.dart';
import 'package:intl/intl.dart';

class SessionDialog extends StatefulWidget {
  const SessionDialog({super.key});

  @override
  SessionDialogState createState() => SessionDialogState();
}

class SessionDialogState extends State<SessionDialog> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _speakerController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  final String _sessionType = 'Talk';

  @override
  void dispose() {
    _titleController.dispose();
    _speakerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Session'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Session Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _speakerController,
                decoration: const InputDecoration(labelText: 'Speaker'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a speaker name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startTime == null
                        ? 'No Start Time'
                        : DateFormat.yMd().add_jm().format(_startTime!),
                  ),
                  ElevatedButton(
                    child: const Text('Select'),
                    onPressed: () async {
                      final time = await _showDateTimePicker();
                      if (time != null) setState(() => _startTime = time);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _endTime == null
                        ? 'No End Time'
                        : DateFormat.yMd().add_jm().format(_endTime!),
                  ),
                  ElevatedButton(
                    child: const Text('Select'),
                    onPressed: () async {
                      final time = await _showDateTimePicker();
                      if (time != null) setState(() => _endTime = time);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final messenger = ScaffoldMessenger.of(context);

            if (_formKey.currentState!.validate()) {
              if (_startTime == null || _endTime == null) {
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Please select start and end times.'),
                  ),
                );
                return;
              }
              final newSession = Session(
                title: _titleController.text,
                speaker: _speakerController.text,
                startTime: _startTime!,
                endTime: _endTime!,
                sessionType: _sessionType,
                description: _descriptionController.text,
              );
              Navigator.pop(context, newSession);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<DateTime?> _showDateTimePicker() async {
    if (!mounted) return null;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
