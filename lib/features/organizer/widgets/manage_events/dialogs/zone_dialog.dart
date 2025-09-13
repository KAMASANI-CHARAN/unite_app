import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/zone.dart';

class ZoneDialog extends StatefulWidget {
  const ZoneDialog({super.key});

  @override
  ZoneDialogState createState() => ZoneDialogState();
}

class ZoneDialogState extends State<ZoneDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Zone'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: const InputDecoration(labelText: 'Zone Name'),
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
              Navigator.pop(context, Zone(name: _name));
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
