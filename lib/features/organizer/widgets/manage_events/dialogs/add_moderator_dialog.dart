import 'package:flutter/material.dart';
import 'package:unite/core/models/app_user.dart';
import 'package:unite/features/organizer/presentation/notifier/manage_event_notifier.dart';

class AddModeratorDialog extends StatefulWidget {
  final ManageEventNotifier notifier;
  const AddModeratorDialog({super.key, required this.notifier});

  @override
  State<AddModeratorDialog> createState() => _AddModeratorDialogState();
}

class _AddModeratorDialogState extends State<AddModeratorDialog> {
  List<AppUser> _searchResults = [];
  bool _isSearching = false;

  Future<void> _search(String query) async {
    setState(() => _isSearching = true);
    try {
      final results = await widget.notifier.searchUsers(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching users: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Moderator'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: _search,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Search by name...',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            if (_isSearching)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return ListTile(
                      title: Text(user.fullName),
                      subtitle: Text(user.email),
                      onTap: () => Navigator.of(context).pop(user),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
