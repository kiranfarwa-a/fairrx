import 'package:flutter/material.dart';
import '../store.dart';
import '../widgets.dart';
import 'history_screen.dart';
import 'premium_screen.dart';
import 'reminders_screen.dart';
import 'saved_screen.dart';
import 'scan_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(onGoTo: (i) => setState(() => _tab = i)),
      const SearchScreen(),
      const SavedScreen(),
      const HistoryScreen(),
      const RemindersScreen(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('FairRx'),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium),
            tooltip: 'Premium',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PremiumScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: pages[_tab],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ScanScreen())),
        icon: const Icon(Icons.document_scanner),
        label: const Text('Scan'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.alarm), label: 'Reminders'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final void Function(int) onGoTo;
  const _HomeTab({required this.onGoTo});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Compare medicine prices in seconds',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
              'Scan a prescription or strip, or search by name. See the '
              'generic name and cheaper options with the same ingredient.'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.document_scanner,
                  label: 'Scan prescription',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ScanScreen())),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.search,
                  label: 'Search medicine',
                  onTap: () => onGoTo(1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.history,
                  label: 'My history (${store.history.length})',
                  onTap: () => onGoTo(3),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.alarm,
                  label: 'Reminders (${store.reminders.length})',
                  onTap: () => onGoTo(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const DisclaimerBanner(),
          const SizedBox(height: 16),
          if (!store.premium) const AdBanner(),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionCard(
      {required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, size: 34, color: kBrand),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
