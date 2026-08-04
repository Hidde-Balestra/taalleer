import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Pure berekening van het eerstvolgende moment op of na [now] waarop het
/// [hour]:00 is — los van de plugin/tijdzone-integratie, dus rechtstreeks
/// testbaar. Is [now] al op of na [hour]:00 vandaag, dan is dat morgen.
DateTime nextTrigger(DateTime now, int hour) {
  var scheduled = DateTime(now.year, now.month, now.day, hour);
  if (!scheduled.isAfter(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

/// Plant en annuleert de dagelijkse oefenherinnering. Gebruikt inexact
/// schedulen (`AndroidScheduleMode.inexactAllowWhileIdle`) zodat er geen
/// `SCHEDULE_EXACT_ALARM`-permissie nodig is — voor een herinnering om te
/// oefenen hoeft het niet op de minuut nauwkeurig.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _reminderId = 1;
  static const _channelId = 'daily_reminder';

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    await _plugin.initialize(
      const InitializationSettings(android: androidSettings),
    );
    _initialized = true;
  }

  /// Vraagt notificatiepermissie aan (Android 13+); geeft `true` terug als
  /// die (al) is toegestaan.
  Future<bool> requestPermission() async {
    await _ensureInitialized();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.requestNotificationsPermission() ?? true;
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required String title,
    required String body,
  }) async {
    await _ensureInitialized();
    final scheduled = tz.TZDateTime.from(
      nextTrigger(DateTime.now(), hour),
      tz.local,
    );
    await _plugin.zonedSchedule(
      _reminderId,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          'Dagelijkse herinnering',
          importance: Importance.defaultImportance,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder() async {
    await _ensureInitialized();
    await _plugin.cancel(_reminderId);
  }
}

final notificationService = NotificationService();
