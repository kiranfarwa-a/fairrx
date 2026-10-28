import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';
import '../widgets.dart';

/// List of medicines the user saved with the heart button.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final meds = store.favorites
            .map((id) => store.byId(id))
            .whereType<Medicine>()
            .toList();
        if (meds.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'No saved medicines yet. Open a medicine and tap the heart.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [for (final m in meds) MedicineTile(med: m)],
        );
      },
    );
  }
}
