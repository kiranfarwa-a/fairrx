import 'package:flutter/material.dart';
import '../widgets.dart';
import '../models.dart';
import '../store.dart';

/// Search list that returns the chosen medicine to the previous screen.
class PickMedicineScreen extends StatefulWidget {
  const PickMedicineScreen({super.key});
  @override
  State<PickMedicineScreen> createState() => _PickMedicineScreenState();
}

class _PickMedicineScreenState extends State<PickMedicineScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final List<Medicine> results = store.matcher.search(_query);
    return Scaffold(
      appBar: gradAppBar(title: const Text('Choose a medicine')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search by brand or generic name',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, i) {
                final m = results[i];
                return ListTile(
                  title: Text(m.brand),
                  subtitle: Text(
                      '${m.generic}${m.strength.isEmpty ? '' : ' - ${m.strength}'}'),
                  trailing: Text('Rs ${m.price.toStringAsFixed(2)}'),
                  onTap: () => Navigator.pop(context, m),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
