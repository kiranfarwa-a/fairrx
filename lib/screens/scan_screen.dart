import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../models.dart';
import '../store.dart';
import '../widgets.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _busy = false;
  String? _error;

  Future<void> _scan(ImageSource source) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file == null) {
        setState(() => _busy = false);
        return;
      }
      final input = InputImage.fromFilePath(file.path);
      final result = await recognizer.processImage(input);
      final text = result.text;
      final matches = store.matcher.matchText(text);
      await store.addHistory('scan', matches);
      if (!mounted) return;
      setState(() => _busy = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(text: text, matches: matches),
        ),
      );
    } catch (e) {
      setState(() {
        _busy = false;
        _error = 'Could not read the image. Please try again.';
      });
    } finally {
      await recognizer.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradAppBar(title: const Text('Scan')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: kGradient,
                borderRadius: BorderRadius.circular(42),
                boxShadow: kSoftShadow,
              ),
              child: const Icon(Icons.document_scanner,
                  size: 70, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text('Scan a prescription or strip',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text(
              'Take a clear photo. Keep the text flat, bright and in focus.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, height: 1.4),
            ),
            const SizedBox(height: 26),
            if (_busy)
              const Column(children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Reading text on your phone...'),
              ])
            else ...[
              FilledButton.icon(
                onPressed: () => _scan(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Use camera'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _scan(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Choose from gallery'),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            const DisclaimerBanner(),
          ],
        ),
      ),
    );
  }
}

class ScanResultScreen extends StatelessWidget {
  final String text;
  final List<Medicine> matches;
  const ScanResultScreen(
      {super.key, required this.text, required this.matches});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: gradAppBar(title: const Text('Scan result')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            matches.isEmpty
                ? 'No medicine from our list was found.'
                : '${matches.length} medicine(s) found',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (matches.isEmpty)
            const Text('Try a clearer photo, or search by name instead. '
                'This demo knows about 250 products from a 2021 price list.'),
          for (final m in matches) MedicineTile(med: m),
          const SizedBox(height: 12),
          ExpansionTile(
            title: const Text('Text the phone read'),
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(text.isEmpty ? '(nothing read)' : text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const DisclaimerBanner(),
        ],
      ),
    );
  }
}
