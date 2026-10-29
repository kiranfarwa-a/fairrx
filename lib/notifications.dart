import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'models.dart';

/// Daily medicine alerts made by the phone itself. No internet is needed.
class Notifier {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      'fairrx_reminders',
      'Medicine reminders',
      channelDescription: 'Daily medicine reminders',
      importance: Importance.high,
      priority: Priority.high,
    ),
  );

  static int _id(Reminder r) {
    final n = int.tryParse(r.id);
    if (n != null) return n % 2147483647;
    return r.id.hashCode & 0x7fffffff;
  }

  static Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    // Pick a time zone from the phone's current offset (whole hours only).
    final off = DateTime.now().timeZoneOffset;
    var name = 'UTC';
    if (off.inMinutes % 60 == 0 && off.inHours != 0) {
      final h = off.inHours;
      name = 'Etc/GMT${h > 0 ? '-' : '+'}${h.abs()}';
    }
    try {
      tz.setLocalLocation(tz.getLocation(name));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings);
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    _ready = true;
  }

  /// Shows an alert right now, to prove that notifications work.
  static Future<void> showTest() async {
    await init();
    await _plugin.show(
      0,
      'FairRx',
      'Test alert: reminders work on this phone, even offline.',
      _details,
    );
  }

  /// Schedules a daily alert at the reminder time.
  static Future<void> schedule(Reminder r) async {
    await init();
    final now = tz.TZDateTime.now(tz.local);
    var when =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, r.hour, r.minute);
    if (!when.isAfter(now)) when = when.add(const Duration(days: 1));
    final body = r.note.isEmpty
        ? 'Time to take ${r.medicineName}'
        : '${r.medicineName} - ${r.note}';
    try {
      await _plugin.zonedSchedule(
        _id(r),
        'Medicine reminder',
        body,
        when,
        _details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {
      // Exact alarms may be blocked: use a slightly less exact alarm.
      await _plugin.zonedSchedule(
        _id(r),
        'Medicine reminder',
        body,
        when,
        _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static Future<void> cancel(Reminder r) async {
    await init();
    await _plugin.cancel(_id(r));
  }
}
