import 'package:flutter/material.dart';
import '../widgets.dart';

class AboutScreen extends StatelessWidget {
  final bool showPrivacy;
  const AboutScreen({super.key, this.showPrivacy = false});

  @override
  Widget build(BuildContext context) {
    final text = showPrivacy
        ? 'Privacy policy (draft)\n\n'
            '- Photos are read on your phone with on-device text recognition '
            'and are not uploaded.\n'
            '- Scan history and reminders are stored only on your phone.\n'
            '- The free plan may show ads. Ad providers may collect device '
            'data under their own policy.\n'
            '- You can clear your history in Settings at any time.\n\n'
            'This is a draft for a student project. A real release needs a '
            'full policy hosted online and a completed Google Play Data '
            'Safety form.'
        : 'FairRx\n\n'
            'Version 1.0 (student prototype)\n\n'
            'FairRx helps you read a prescription, find the generic name of a '
            'medicine and compare prices of options with the same ingredient '
            'and strength.\n\n'
            'Built with Flutter and Google ML Kit text recognition.\n\n' +
            kDataSource;
    return Scaffold(
      appBar: AppBar(title: Text(showPrivacy ? 'Privacy policy' : 'About')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Text(text, style: const TextStyle(fontSize: 16, height: 1.4)),
        ),
      ),
    );
  }
}
