import 'package:flutter/material.dart';

class StatusFilter extends StatelessWidget {
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;

  const StatusFilter({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip('all', 'All'),
            const SizedBox(width: 8),
            _buildChip('pending', 'Pending'),
            const SizedBox(width: 8),
            _buildChip('approved', 'Approved'),
            const SizedBox(width: 8),
            _buildChip('rejected', 'Rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String value, String label) {
    final isSelected = selectedStatus == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onStatusChanged(value),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      selectedColor: Colors.blue,
    );
  }
}
