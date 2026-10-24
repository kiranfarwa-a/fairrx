class Medicine {
  final String id;
  final String brand; // full brand text, e.g. "Brufen 400mg Tablet"
  final String core; // short brand name used for matching, e.g. "Brufen"
  final String company;
  final String generic;
  final String strength;
  final String form;
  final String pack;
  final double price; // MRP: per tablet/capsule, or per pack for liquids
  final String unit; // e.g. "per tablet" or "per pack (60 ml)"
  final bool comparable; // true when the strength is clear enough to compare

  const Medicine({
    required this.id,
    required this.brand,
    required this.core,
    required this.company,
    required this.generic,
    required this.strength,
    required this.form,
    required this.pack,
    required this.price,
    required this.unit,
    required this.comparable,
  });

  factory Medicine.fromJson(Map<String, dynamic> j) => Medicine(
        id: j['id'] as String,
        brand: j['brand'] as String,
        core: j['core'] as String,
        company: j['company'] as String,
        generic: j['generic'] as String,
        strength: j['strength'] as String,
        form: j['form'] as String,
        pack: j['pack'] as String,
        price: (j['price'] as num).toDouble(),
        unit: j['unit'] as String,
        comparable: j['cmp'] as bool,
      );

  /// Same active ingredient, strength and form = "same salt".
  String get saltKey =>
      '${generic.toLowerCase()}|${strength.toLowerCase()}|${form.toLowerCase()}';
}

class HistoryItem {
  final DateTime date;
  final String source; // 'scan' or 'search'
  final List<String> medicineIds;

  const HistoryItem({
    required this.date,
    required this.source,
    required this.medicineIds,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'source': source,
        'ids': medicineIds,
      };

  factory HistoryItem.fromJson(Map<String, dynamic> j) => HistoryItem(
        date: DateTime.parse(j['date'] as String),
        source: j['source'] as String,
        medicineIds: (j['ids'] as List).map((e) => e as String).toList(),
      );
}

class Reminder {
  final String id;
  final String medicineName;
  final int hour;
  final int minute;
  final String note;
  final bool enabled;

  const Reminder({
    required this.id,
    required this.medicineName,
    required this.hour,
    required this.minute,
    required this.note,
    required this.enabled,
  });

  Reminder copyWith({bool? enabled}) => Reminder(
        id: id,
        medicineName: medicineName,
        hour: hour,
        minute: minute,
        note: note,
        enabled: enabled ?? this.enabled,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': medicineName,
        'hour': hour,
        'minute': minute,
        'note': note,
        'enabled': enabled,
      };

  factory Reminder.fromJson(Map<String, dynamic> j) => Reminder(
        id: j['id'] as String,
        medicineName: j['name'] as String,
        hour: j['hour'] as int,
        minute: j['minute'] as int,
        note: j['note'] as String,
        enabled: j['enabled'] as bool,
      );
}
