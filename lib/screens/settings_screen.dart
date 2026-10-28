import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'about_screen.dart';
import 'disclaimer_screen.dart';
import 'premium_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Widget _item(IconData icon, String title, VoidCallback onTap) {
    return SoftCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: GradBadge(icon: icon, size: 40),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradAppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _item(Icons.workspace_premium, 'Premium', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PremiumScreen()));
          }),
          _item(Icons.warning_amber, 'Medical disclaimer', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const DisclaimerScreen(viewOnly: true)));
          }),
          _item(Icons.privacy_tip, 'Privacy policy', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AboutScreen(showPrivacy: true)));
          }),
          _item(Icons.info_outline, 'About FairRx', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AboutScreen()));
          }),
          _item(Icons.delete_outline, 'Clear scan history', () async {
            await store.clearHistory();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('History cleared')));
          }),
        ],
      ),
    );
  }
}
