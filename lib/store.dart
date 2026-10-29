import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'matcher.dart';
import 'models.dart';
import 'notifications.dart';

/// One place that holds the app data and saves it on the phone.
class AppStore extends ChangeNotifier {
  List<Medicine> medicines = [];
  List<HistoryItem> history = [];
  List<Reminder> reminders = [];
  bool disclaimerAccepted = false;
  bool tourSeen = false;
  Set<String> favorites = {};
  bool premium = false; // demo switch only - no real payment
  late MedicineMatcher matcher;

  SharedPreferences? _prefs;

  Future<void> load() async {
    final raw = await rootBundle.loadString('assets/medicines.json');
    medicines = (jsonDecode(raw) as List)
        .map((e) => Medicine.fromJson(e as Map<String, dynamic>))
        .toList();
    matcher = MedicineMatcher(medicines);

    _prefs = await SharedPreferences.getInstance();
    disclaimerAccepted = _prefs!.getBool('accepted') ?? false;
    premium = _prefs!.getBool('premium') ?? false;
    tourSeen = _prefs!.getBool('tour') ?? false;
    favorites = (_prefs!.getStringList('favs') ?? <String>[]).toSet();

    final h = _prefs!.getString('history');
    if (h != null) {
      history = (jsonDecode(h) as List)
          .map((e) => HistoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    final r = _prefs!.getString('reminders');
    if (r != null) {
      reminders = (jsonDecode(r) as List)
          .map((e) => Reminder.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    notifyListeners();
  }

  Medicine? byId(String id) {
    for (final m in medicines) {
      if (m.id == id) return m;
    }
    return null;
  }

  Future<void> acceptDisclaimer() async {
    disclaimerAccepted = true;
    await _prefs?.setBool('accepted', true);
    notifyListeners();
  }

  Future<void> finishTour() async {
    tourSeen = true;
    await _prefs?.setBool('tour', true);
    notifyListeners();
  }

  bool isFav(String id) => favorites.contains(id);

  Future<void> toggleFav(String id) async {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await _prefs?.setStringList('favs', favorites.toList());
    notifyListeners();
  }

  Future<void> setPremium(bool value) async {
    premium = value;
    await _prefs?.setBool('premium', value);
    notifyListeners();
  }

  Future<void> addHistory(String source, List<Medicine> meds) async {
    if (meds.isEmpty) return;
    history.insert(
      0,
      HistoryItem(
        date: DateTime.now(),
        source: source,
        medicineIds: meds.map((m) => m.id).toList(),
      ),
    );
    // Free plan keeps the last 10 items; premium keeps everything.
    if (!premium && history.length > 10) {
      history = history.sublist(0, 10);
    }
    await _saveHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    history = [];
    await _saveHistory();
    notifyListeners();
  }

  Future<void> addReminder(Reminder r) async {
    reminders.add(r);
    await _saveReminders();
    try {
      if (r.enabled) await Notifier.schedule(r);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> toggleReminder(String id, bool enabled) async {
    reminders = reminders
        .map((r) => r.id == id ? r.copyWith(enabled: enabled) : r)
        .toList();
    await _saveReminders();
    try {
      for (final r in reminders) {
        if (r.id == id) {
          if (enabled) {
            await Notifier.schedule(r);
          } else {
            await Notifier.cancel(r);
          }
        }
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> deleteReminder(String id) async {
    final gone = reminders.where((r) => r.id == id).toList();
    reminders.removeWhere((r) => r.id == id);
    await _saveReminders();
    try {
      for (final r in gone) {
        await Notifier.cancel(r);
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    await _prefs?.setString(
        'history', jsonEncode(history.map((e) => e.toJson()).toList()));
  }

  Future<void> _saveReminders() async {
    await _prefs?.setString(
        'reminders', jsonEncode(reminders.map((e) => e.toJson()).toList()));
  }
}

/// Simple global access (keeps the code short for a student project).
final AppStore store = AppStore();
