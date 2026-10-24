import 'package:flutter/material.dart';
import '../store.dart';
import 'about_screen.dart';
import 'disclaimer_screen.dart';
import 'premium_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Premium'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PremiumScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber),
            title: const Text('Medical disclaimer'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const DisclaimerScreen(viewOnly: true))),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy policy'),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const AboutScreen(showPrivacy: true))),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About FairRx'),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AboutScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Clear scan history'),
            onTap: () async {
              await store.clearHistory();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('History cleared')));
            },
          ),
        ],
      ),
    );
  }
}
