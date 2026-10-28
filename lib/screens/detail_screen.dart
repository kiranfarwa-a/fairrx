import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';
import '../widgets.dart';
import 'add_reminder_screen.dart';
import 'compare_screen.dart';

class DetailScreen extends StatelessWidget {
  final Medicine med;
  const DetailScreen({super.key, required this.med});

  @override
  Widget build(BuildContext context) {
    final alts = store.matcher.alternatives(med);
    return Scaffold(
      appBar: AppBar(
        title: Text(med.brand),
        actions: [
          ListenableBuilder(
            listenable: store,
            builder: (context, _) => IconButton(
              tooltip: 'Save',
              icon: Icon(store.isFav(med.id)
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () => store.toggleFav(med.id),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med.brand,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _row('Generic name', med.generic),
                  if (med.strength.isNotEmpty) _row('Strength', med.strength),
                  _row('Form', med.form),
                  _row('Company', med.company),
                  _row('Pack', med.pack),
                  _row('MRP', 'Rs ${med.price.toStringAsFixed(2)} ${med.unit}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Same ingredient and strength',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (alts.isEmpty)
            Text(med.comparable
                ? 'No other option with the same ingredient and strength in '
                    'our list.'
                : 'The strength of this medicine is not clear in the list, so '
                    'we do not compare it.'),
          for (final a in alts) _AltTile(original: med, alt: a),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CompareScreen(first: med)),
            ),
            icon: const Icon(Icons.compare_arrows),
            label: const Text('Compare with another medicine'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AddReminderScreen(initialName: med.brand)),
            ),
            icon: const Icon(Icons.alarm_add),
            label: const Text('Add a reminder'),
          ),
          const SizedBox(height: 16),
          const DisclaimerBanner(),
          const SizedBox(height: 8),
          const Text(kDataSource,
              style: TextStyle(fontSize: 11.5, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 110,
                child: Text(k, style: const TextStyle(color: Colors.black54))),
            Expanded(child: Text(v)),
          ],
        ),
      );
}

class _AltTile extends StatelessWidget {
  final Medicine original;
  final Medicine alt;
  const _AltTile({required this.original, required this.alt});

  @override
  Widget build(BuildContext context) {
    final diff = original.price - alt.price;
    final pct = original.price == 0 ? 0 : (diff / original.price * 100);
    final cheaper = diff > 0;
    return Card(
      child: ListTile(
        title: Text(alt.brand),
        subtitle: Text(cheaper
            ? 'Cheaper by ${pct.toStringAsFixed(0)}% (Rs ${diff.toStringAsFixed(2)} ${alt.unit})'
            : 'Costs more (Rs ${(-diff).toStringAsFixed(2)} ${alt.unit})'),
        trailing: Text('Rs ${alt.price.toStringAsFixed(2)}',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cheaper ? Colors.green.shade700 : Colors.red.shade700)),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => DetailScreen(med: alt))),
      ),
    );
  }
}
