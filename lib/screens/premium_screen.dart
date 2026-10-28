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
        appBar: gradAppBar(title: const Text('FairRx Premium')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: kGradient,
                borderRadius: BorderRadius.circular(26),
                boxShadow: kSoftShadow,
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium,
                      size: 64, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text('Go Premium',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(store.premium ? 'Premium is active' : 'Rs 199 per month',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70)),
                  const SizedBox(height: 4),
                  const Text('Example price - not final',
                      style: TextStyle(fontSize: 12, color: Colors.white54)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SoftCard(
              child: Column(
                children: [
                  _bullet('No ads'),
                  _bullet('Unlimited scan history (free keeps 10)'),
                  _bullet('Family profiles (planned)'),
                  _bullet('Price drop alerts (planned)'),
                ],
              ),
            ),
            SoftCard(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Premium (demo switch)',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text(
                    'For class demo only. A real app would use Google Play '
                    'Billing here.'),
                value: store.premium,
                onChanged: (v) => store.setPremium(v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(children: [
          const Icon(Icons.check_circle, color: kGradStart),
          const SizedBox(width: 12),
          Expanded(child: Text(t, style: const TextStyle(fontSize: 15))),
        ]),
      );
}
