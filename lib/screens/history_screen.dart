import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final items = store.history;
        if (items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No history yet. Scan a prescription to start.',
                  textAlign: TextAlign.center),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            if (!store.premium)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Free plan keeps your last 10 scans.',
                    style: TextStyle(color: Colors.black54)),
              ),
            for (final h in items)
              SoftCard(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  leading: Icon(h.source == 'scan'
                      ? Icons.document_scanner
                      : Icons.search),
                  title: Text(formatDate(h.date)),
                  subtitle: Text('${h.medicineIds.length} medicine(s)'),
                  children: [
                    for (final id in h.medicineIds)
                      if (store.byId(id) != null)
                        ListTile(
                          title: Text(store.byId(id)!.brand),
                          subtitle: Text(store.byId(id)!.generic),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    DetailScreen(med: store.byId(id)!)),
                          ),
                        ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => store.clearHistory(),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Clear history'),
            ),
            if (!store.premium) const AdBanner(),
          ],
        );
      },
    );
  }
}
