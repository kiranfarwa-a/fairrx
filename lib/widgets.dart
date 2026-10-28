import 'package:flutter/material.dart';
import 'models.dart';
import 'screens/detail_screen.dart';

const Color kBrand = Color(0xFF0A7C78);
const Color kGradStart = Color(0xFF00B09B);
const Color kGradEnd = Color(0xFF3D5AFE);
const Color kBg = Color(0xFFF3F6FB);

const LinearGradient kGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [kGradStart, kGradEnd],
);

const List<BoxShadow> kSoftShadow = [
  BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
];

/// App bar with the gradient background (used on every screen).
AppBar gradAppBar({Widget? title, List<Widget>? actions}) {
  return AppBar(
    title: title,
    actions: actions,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    flexibleSpace: Container(
      decoration: const BoxDecoration(gradient: kGradient),
    ),
  );
}

/// A rounded white card with a soft shadow.
class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 6),
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: kSoftShadow,
      ),
      child: child,
    );
  }
}

/// A round gradient icon badge.
class GradBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  const GradBadge({super.key, required this.icon, this.size = 46});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: kGradient,
        borderRadius: BorderRadius.circular(size / 3),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}

class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4E5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF2B35E)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: Color(0xFFB26A00)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Information only, not medical advice. Ask your doctor or '
              'pharmacist before changing any medicine. Prices are official '
              'MRPs from a 2021 list and may be out of date.',
              style: TextStyle(fontSize: 12.5, height: 1.35),
            ),
          ),
        ],
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
      height: 54,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
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
    final letter = med.core.isEmpty ? '?' : med.core[0].toUpperCase();
    final sub =
        '${med.generic}${med.strength.isEmpty ? '' : ' - ${med.strength}'} - ${med.form}';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: kSoftShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(med: med)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: kGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(letter,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(med.brand,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text(sub,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12.5, color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Rs ${med.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: kGradEnd)),
                    Text(med.unit,
                        style: const TextStyle(
                            fontSize: 10.5, color: Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
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
