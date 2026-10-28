import 'package:flutter/material.dart';
import '../widgets.dart';
import '../models.dart';
import '../store.dart';

class AddReminderScreen extends StatefulWidget {
  final String initialName;
  const AddReminderScreen({super.key, this.initialName = ''});
  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initialName);
  final TextEditingController _note = TextEditingController();
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradAppBar(title: const Text('Add reminder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                  labelText: 'Medicine name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _note,
              decoration: const InputDecoration(
                  labelText: 'Note (for example: after food)',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            ListTile(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black26),
                  borderRadius: BorderRadius.circular(6)),
              leading: const Icon(Icons.access_time),
              title: Text('Time: ${_time.format(context)}'),
              onTap: () async {
                final picked =
                    await showTimePicker(context: context, initialTime: _time);
                if (picked != null) setState(() => _time = picked);
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Reminders are saved on this phone. Follow the dose your '
              'doctor gave you.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  if (_name.text.trim().isEmpty) return;
                  await store.addReminder(Reminder(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    medicineName: _name.text.trim(),
                    hour: _time.hour,
                    minute: _time.minute,
                    note: _note.text.trim(),
                    enabled: true,
                  ));
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Save reminder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
