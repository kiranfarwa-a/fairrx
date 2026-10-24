import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'store.dart';
import 'widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FairRxApp());
}

class FairRxApp extends StatelessWidget {
  const FairRxApp({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => MaterialApp(
        title: 'FairRx',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: kBrand),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
