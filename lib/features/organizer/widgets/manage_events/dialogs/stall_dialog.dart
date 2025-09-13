import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/stall.dart';

class StallDialog extends StatefulWidget {
  const StallDialog({super.key});

  @override
  StallDialogState createState() => StallDialogState();
}

class StallDialogState extends State<StallDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _boothNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _boothNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Stall'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Stall Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _boothNumberController,
                decoration: const InputDecoration(labelText: 'Booth Number'),
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
            if (_formKey.currentState!.validate()) {
              final newStall = Stall(
                name: _nameController.text,
                boothNumber: _boothNumberController.text,
                assets: [],
              );
              Navigator.pop(context, newStall);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
