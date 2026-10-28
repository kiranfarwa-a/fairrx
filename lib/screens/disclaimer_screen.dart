import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'home_screen.dart';

/// Shown once on first launch. Also reused from Settings (viewOnly = true).
class DisclaimerScreen extends StatelessWidget {
  final bool viewOnly;
  const DisclaimerScreen({super.key, this.viewOnly = false});

  Widget _point(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GradBadge(icon: icon, size: 38),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 15, height: 1.4)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradAppBar(title: const Text('Important notice')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Please read',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: SoftCard(
                  child: Column(
                    children: [
                      _point(Icons.medical_services,
                          'FairRx gives information only. It is not medical advice.'),
                      _point(Icons.local_pharmacy,
                          'Never change or stop a medicine without asking your doctor or pharmacist.'),
                      _point(Icons.warning_amber,
                          'A cheaper medicine with the same ingredient may still not be right for you. Allergies, dose and other medicines matter.'),
                      _point(Icons.price_check,
                          'Prices come from an official 2021 price list and may not match what a shop charges today.'),
                      _point(Icons.lock,
                          'Photos are read on your phone. They are not uploaded.'),
                    ],
                  ),
                ),
              ),
            ),
            if (!viewOnly)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
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
              ),
          ],
        ),
      ),
    );
  }
}
