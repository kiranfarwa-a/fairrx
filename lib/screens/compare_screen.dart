import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';
import 'pick_medicine_screen.dart';

/// Two medicines side by side.
class CompareScreen extends StatefulWidget {
  final Medicine first;
  const CompareScreen({super.key, required this.first});
  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Medicine? _second;

  Future<void> _pick() async {
    final chosen = await Navigator.push<Medicine>(
      context,
      MaterialPageRoute(builder: (_) => const PickMedicineScreen()),
    );
    if (chosen != null) setState(() => _second = chosen);
  }

  String _verdict(Medicine a, Medicine b) {
    final sameForm = a.form == b.form;
    final sameUnit = a.unit == b.unit;
    if (!sameForm || !sameUnit) {
      return 'These two are sold in different forms or pack sizes, so the '
          'prices cannot be compared directly.';
    }
    final diff = a.price - b.price;
    if (diff.abs() < 0.005) return 'Both have the same price.';
    final cheaper = diff > 0 ? b : a;
    final pct = (diff.abs() / (diff > 0 ? a.price : b.price) * 100)
        .toStringAsFixed(0);
    return '${cheaper.brand} is cheaper by Rs ${diff.abs().toStringAsFixed(2)} '
        '(${a.unit}), about $pct% less than the other.';
  }

  Widget _row(String label, String x, String y) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(label,
                style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ),
          Expanded(child: Text(x)),
          const SizedBox(width: 8),
          Expanded(child: Text(y)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.first;
    final b = _second;
    return Scaffold(
      appBar: gradAppBar(title: const Text('Compare')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (b == null) ...[
            SoftCard(
              padding: EdgeInsets.zero,
              child: ListTile(
                title: Text(a.brand),
                subtitle: Text(a.generic),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _pick,
              icon: const Icon(Icons.add),
              label: const Text('Choose a second medicine'),
            ),
          ] else ...[
            SoftCard(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _row('', a.brand, b.brand),
                    const Divider(),
                    _row('Generic', a.generic, b.generic),
                    _row('Strength', a.strength, b.strength),
                    _row('Form', a.form, b.form),
                    _row('Company', a.company, b.company),
                    _row('Pack', a.pack, b.pack),
                    _row('Price', 'Rs ${a.price.toStringAsFixed(2)}\n${a.unit}',
                        'Rs ${b.price.toStringAsFixed(2)}\n${b.unit}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SoftCard(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(_verdict(a, b)),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _pick,
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Change the second medicine'),
            ),
          ],
          const SizedBox(height: 12),
          const DisclaimerBanner(),
        ],
      ),
    );
  }
}
