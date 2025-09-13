import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unite/features/organizer/presentation/notifier/manage_event_notifier.dart';

class ModeratorSection extends StatelessWidget {
  const ModeratorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ManageEventNotifier>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notifier.moderators.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: Text('No moderators added yet.')),
          )
        else
          ...notifier.moderators.map(
            (user) => ListTile(
              title: Text(user.fullName),
              subtitle: Text(user.email),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed:
                    () => context.read<ManageEventNotifier>().removeModerator(
                      user.uid,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}
