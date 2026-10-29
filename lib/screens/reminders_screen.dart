import 'package:flutter/material.dart';
import '../store.dart';
import '../notifications.dart';
import '../widgets.dart';
import 'add_reminder_screen.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  String _time(int h, int m) {
    final hh = h % 12 == 0 ? 12 : h % 12;
    return '$hh:${m.toString().padLeft(2, '0')} ${h >= 12 ? 'PM' : 'AM'}';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final addButton = Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddReminderScreen()),
              ),
              icon: const Icon(Icons.add_alarm),
              label: const Text('Add reminder'),
            ),
          ),
        );
        final testButton = Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: TextButton.icon(
            onPressed: () => Notifier.showTest(),
            icon: const Icon(Icons.notifications_active),
            label: const Text('Send a test alert now'),
          ),
        );
        if (store.reminders.isEmpty) {
          return Column(
            children: [
              addButton,
              testButton,
              const Expanded(
                child: Center(child: Text('No reminders yet.')),
              ),
            ],
          );
        }
        return ListView(
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            addButton,
            testButton,
            for (final r in store.reminders)
              SoftCard(
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: SwitchListTile(
                  title: Text('${r.medicineName} - ${_time(r.hour, r.minute)}'),
                  subtitle: Text(r.note.isEmpty ? 'Daily' : r.note),
                  value: r.enabled,
                  onChanged: (v) => store.toggleReminder(r.id, v),
                  secondary: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => store.deleteReminder(r.id),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
