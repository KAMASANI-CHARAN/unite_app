import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/track.dart';

class TrackDialog extends StatefulWidget {
  const TrackDialog({super.key});

  @override
  TrackDialogState createState() => TrackDialogState();
}

class TrackDialogState extends State<TrackDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Track'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'Track Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
          onSaved: (value) {
            _name = value!;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.pop(context, Track(name: _name));
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
