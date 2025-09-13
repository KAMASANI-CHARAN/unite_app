import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'field.dart';
import 'submit_button.dart';

class EventRequestForm extends StatefulWidget {
  const EventRequestForm({super.key});

  @override
  State<EventRequestForm> createState() => _EventRequestFormState();
}

class _EventRequestFormState extends State<EventRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _organizerController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _organizerController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance.collection('event_requests').add({
        'name': _nameController.text.trim(),
        'type': _typeController.text.trim(),
        'organizer': _organizerController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'status': 'pending',
        'userEmail': user.email,
        'userId': user.uid,

        'createdAt': FieldValue.serverTimestamp(),
        'name_lowercase': _nameController.text.trim().toLowerCase(),
      });
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 48),
                      Text(
                        'Create Event',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildFormFields(),
                  const SizedBox(height: 28),
                  SubmitButton(
                    isLoading: _isSubmitting,
                    onPressed: _submitForm,
                    label: 'Submit',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        EventFormField(controller: _nameController, label: 'Event Name'),
        const SizedBox(height: 16),
        EventFormField(controller: _typeController, label: 'Event Type'),
        const SizedBox(height: 16),
        EventFormField(controller: _organizerController, label: 'Organizer'),
        const SizedBox(height: 16),
        EventFormField(controller: _locationController, label: 'Location'),
        const SizedBox(height: 16),
        EventFormField(
          controller: _descriptionController,
          label: 'Description',
          maxLines: 3,
        ),
      ],
    );
  }
}
