import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/ticket.dart';

class TicketDialog extends StatefulWidget {
  final Ticket? ticket;
  const TicketDialog({super.key, this.ticket});

  @override
  State<TicketDialog> createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _quantity;
  String _currency = 'USD'; // Default currency

  final List<String> _currencies = ['USD', 'INR', 'QAR']; // Add more as needed

  @override
  void initState() {
    super.initState();
    _name = widget.ticket?.name ?? '';
    _price = widget.ticket?.price ?? 0.0;
    _quantity = widget.ticket?.quantity ?? 0;
    _currency = widget.ticket?.currency ?? 'USD';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.ticket == null ? 'Add Ticket Type' : 'Edit Ticket Type',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Ticket Name'),
              validator: (value) => value!.isEmpty ? 'Name is required' : null,
              onSaved: (value) => _name = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _price.toString(),
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _price = double.tryParse(value!) ?? 0.0,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _currency,
              decoration: const InputDecoration(labelText: 'Currency'),
              items:
                  _currencies.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _currency = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _quantity.toString(),
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _quantity = int.tryParse(value!) ?? 0,
            ),
          ],
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
              Navigator.pop(
                context,
                Ticket(
                  name: _name,
                  price: _price,
                  quantity: _quantity,
                  currency: _currency,
                ),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
