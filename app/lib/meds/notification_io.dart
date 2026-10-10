// Mobile: daily med reminders via local notifications (offline-capable).
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

final _plugin = FlutterLocalNotificationsPlugin();
bool _ready = false;

Future<bool> _ensure() async {
  if (_ready) return true;
  tzdata.initializeTimeZones();
  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const ios = DarwinInitializationSettings();
  final ok = await _plugin.initialize(
    const InitializationSettings(android: android, iOS: ios),
  );
  _ready = ok ?? false;
  return _ready;
}

Future<bool> scheduleDailyReminder(
    {required int hour,
    required String title,
    required String body}) async {
  if (!await _ensure()) return false;
  try {
    await _plugin.zonedSchedule(
      hour, // one id per hour slot
      title,
      body,
      _nextAt(hour),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'meds', 'Medication', importance: Importance.high),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    return true;
  } catch (_) {
    return false;
  }
}

tz.TZDateTime _nextAt(int hour) {
  final now = tz.TZDateTime.now(tz.local);
  var at =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
  if (at.isBefore(now)) at = at.add(const Duration(days: 1));
  return at;
}

Future<void> cancelReminders() async {
  if (await _ensure()) await _plugin.cancelAll();
}
