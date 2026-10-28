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

  static const List<String> _titles = [
    'FairRx',
    'Search',
    'Saved',
    'History',
    'Reminders',
  ];

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
      appBar: gradAppBar(
        title: Text(_titles[_tab],
            style: const TextStyle(fontWeight: FontWeight.w800)),
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
        padding: EdgeInsets.zero,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 26),
            decoration: const BoxDecoration(
              gradient: kGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Know the fair price',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                const SizedBox(height: 8),
                const Text(
                    'Scan a prescription or search a medicine. See the generic '
                    'name and cheaper options with the same ingredient.',
                    style: TextStyle(
                        fontSize: 14.5, height: 1.4, color: Colors.white70)),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ScanScreen())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 14,
                            offset: Offset(0, 6)),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.document_scanner, color: kGradEnd),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Scan a prescription or strip',
                              style: TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.black38),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.search,
                        label: 'Search medicine',
                        onTap: () => onGoTo(1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ActionCard(
                        icon: Icons.favorite,
                        label: 'Saved (${store.favorites.length})',
                        onTap: () => onGoTo(2),
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
                        label: 'History (${store.history.length})',
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
                const SizedBox(height: 14),
                if (!store.premium) const AdBanner(),
                const SizedBox(height: 80),
              ],
            ),
          ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: kSoftShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Column(
              children: [
                GradBadge(icon: icon, size: 52),
                const SizedBox(height: 10),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
