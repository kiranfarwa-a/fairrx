import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';

/// Demo screen of the revenue model. No real payment is connected.
class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('FairRx Premium')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(Icons.workspace_premium, size: 64, color: kBrand),
            const SizedBox(height: 8),
            const Text('Go Premium',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _bullet('No ads'),
            _bullet('Unlimited scan history (free keeps 10)'),
            _bullet('Family profiles (planned)'),
            _bullet('Price drop alerts (planned)'),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Monthly'),
                subtitle: const Text('Example price - not final'),
                trailing: Text(store.premium ? 'Active' : 'Rs 199'),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Premium (demo switch)'),
              subtitle: const Text(
                  'For class demo only. A real app would use Google Play '
                  'Billing here.'),
              value: store.premium,
              onChanged: (v) => store.setPremium(v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          const Icon(Icons.check_circle, color: kBrand),
          const SizedBox(width: 10),
          Expanded(child: Text(t)),
        ]),
      );
}
