import 'package:flutter/material.dart';
import 'models.dart';
import 'screens/detail_screen.dart';

const Color kBrand = Color(0xFF0A7C78);

class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF2B35E)),
      ),
      child: const Text(
        'Information only, not medical advice. Ask your doctor or '
        'pharmacist before changing any medicine. Prices are official MRPs from '
        'a 2021 list and may be out of date.',
        style: TextStyle(fontSize: 12.5),
      ),
    );
  }
}

/// Placeholder for a real ad (for example Google AdMob) in the free plan.
class AdBanner extends StatelessWidget {
  const AdBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('Ad space (free plan)  -  go Premium to remove',
          style: TextStyle(fontSize: 12, color: Colors.black54)),
    );
  }
}

class MedicineTile extends StatelessWidget {
  final Medicine med;
  const MedicineTile({super.key, required this.med});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(med.brand,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            '${med.generic}${med.strength.isEmpty ? '' : ' - ${med.strength}'} - ${med.form}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Rs ${med.price.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(med.unit, style: const TextStyle(fontSize: 10.5)),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(med: med)),
        ),
      ),
    );
  }
}

String formatDate(DateTime d) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  final ap = d.hour >= 12 ? 'PM' : 'AM';
  return '${d.day} ${months[d.month - 1]} ${d.year}, $h:$m $ap';
}

const String kDataSource =
    'Data: "Pharmaceutical Prices in Pakistan 2021" (maximum retail prices), '
    'published on Open Data Pakistan, last updated May 2023. The list is '
    'small and may be out of date. Always check the price at the shop.';
