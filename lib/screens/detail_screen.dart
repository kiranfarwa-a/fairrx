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
      appBar: gradAppBar(
        title: Text(med.core.isEmpty ? med.brand : med.core),
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: kSoftShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.brand,
                    style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                const SizedBox(height: 6),
                Text(
                    '${med.generic}${med.strength.isEmpty ? '' : ' - ${med.strength}'}',
                    style:
                        const TextStyle(fontSize: 14.5, color: Colors.white70)),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Rs ${med.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(med.unit,
                          style: const TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Generic name', med.generic),
                if (med.strength.isNotEmpty) _row('Strength', med.strength),
                _row('Form', med.form),
                _row('Company', med.company),
                _row('Pack', med.pack),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text('Same ingredient and strength',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          if (alts.isEmpty)
            SoftCard(
              child: Text(med.comparable
                  ? 'No other option with the same ingredient and strength in our list.'
                  : 'The strength of this medicine is not clear in the list, so we do not compare it.'),
            ),
          for (final a in alts) _AltTile(original: med, alt: a),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CompareScreen(first: med)),
            ),
            icon: const Icon(Icons.compare_arrows),
            label: const Text('Compare with another medicine'),
          ),
          const SizedBox(height: 10),
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
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 110,
                child: Text(k, style: const TextStyle(color: Colors.black54))),
            Expanded(
                child: Text(v,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
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
    final color = cheaper ? Colors.green.shade700 : Colors.red.shade700;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: kSoftShadow,
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => DetailScreen(med: alt))),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alt.brand,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 3),
                      Text(
                          cheaper
                              ? 'Cheaper by ${pct.toStringAsFixed(0)}% (Rs ${diff.toStringAsFixed(2)} ${alt.unit})'
                              : 'Costs more (Rs ${(-diff).toStringAsFixed(2)} ${alt.unit})',
                          style: TextStyle(fontSize: 12.5, color: color)),
                    ],
                  ),
                ),
                Text('Rs ${alt.price.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: color)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
