import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'disclaimer_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await store.load();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => store.disclaimerAccepted
            ? const HomeScreen()
            : const DisclaimerScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBrand,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.medication_liquid, size: 72, color: Colors.white),
            SizedBox(height: 12),
            Text('FairRx',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            SizedBox(height: 6),
            Text('Know what you pay for',
                style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
