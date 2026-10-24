import 'package:flutter/material.dart';
import '../store.dart';
import 'home_screen.dart';

/// Shown once on first launch. Also reused from Settings (viewOnly = true).
class DisclaimerScreen extends StatelessWidget {
  final bool viewOnly;
  const DisclaimerScreen({super.key, this.viewOnly = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Important notice')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please read',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            const Text(
              '- FairRx gives information only. It is not medical advice.\n\n'
              '- Never change or stop a medicine without asking your doctor '
              'or pharmacist.\n\n'
              '- A cheaper medicine with the same ingredient may still not '
              'be right for you. Allergies, dose and other medicines matter.\n\n'
              '- Prices come from an official 2021 price list and may not match '
              'what a shop charges today.\n\n'
              '- Photos are read on your phone. They are not uploaded.',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
            const Spacer(),
            if (!viewOnly)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await store.acceptDisclaimer();
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  child: const Text('I understand'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
