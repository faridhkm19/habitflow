// lib/core/services/notification_service.dart
//
// Smart Reminder — Implementasi penuh flutter_local_notifications.
//
// Strategi scheduling:
//  - daily / x_per_week → 1 notifikasi per habit, DateTimeComponents.time
//  - specific_days      → N notifikasi per habit (satu per hari terpilih),
//                         DateTimeComponents.dayOfWeekAndTime
//
// Notification ID:
//  - base: habitId.hashCode.abs() % 100000
//  - specific_days suffix: base + offset (DateTime.weekday: Mon=1 … Sun=7)

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../features/habits/domain/entities/habit_entity.dart';

class NotificationService {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final NotificationService instance = NotificationService._init();
  NotificationService._init();

  // ── Internals ──────────────────────────────────────────────────────────────
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // Android notification channel
  static const _channelId = 'habit_reminders';
  static const _channelName = 'Pengingat Habit';
  static const _channelDesc = 'Notifikasi pengingat untuk habit harian';

  // Mapping nama hari (dari frequencyValue HabitFlow) ke DateTime.weekday
  static const Map<String, int> _dayNameToWeekday = {
    'monday': DateTime.monday,
    'tuesday': DateTime.tuesday,
    'wednesday': DateTime.wednesday,
    'thursday': DateTime.thursday,
    'friday': DateTime.friday,
    'saturday': DateTime.saturday,
    'sunday': DateTime.sunday,
  };

  // ── Initialization ─────────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;

    // 1. Inisialisasi timezone database
    tz.initializeTimeZones();

    // 2. Set timezone lokal device
    try {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
    } catch (e) {
      debugPrint('[NotificationService] Gagal set timezone lokal: $e');
      // Fallback ke UTC agar tidak crash
      tz.setLocalLocation(tz.UTC);
    }

    // 3. Konfigurasi platform-specific initialization settings
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    // 4. Buat Android notification channel
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDesc,
            importance: Importance.high,
          ),
        );

    _initialized = true;
    debugPrint('[NotificationService] Initialized.');
  }

  // ── Permission ─────────────────────────────────────────────────────────────

  /// Meminta izin notifikasi dari pengguna.
  /// Mengembalikan true jika izin diberikan (atau sudah diberikan sebelumnya).
  Future<bool> requestPermission() async {
    if (!_initialized) await initialize();

    // Android 13+ (API 33+)
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      // Minta POST_NOTIFICATIONS permission
      final notifGranted =
          await androidImpl.requestNotificationsPermission() ?? false;
      if (!notifGranted) {
        debugPrint('[NotificationService] POST_NOTIFICATIONS ditolak.');
        return false;
      }

      // Minta SCHEDULE_EXACT_ALARM permission (Android 12+ / API 31+)
      final exactGranted =
          await androidImpl.requestExactAlarmsPermission() ?? false;
      if (!exactGranted) {
        debugPrint(
          '[NotificationService] SCHEDULE_EXACT_ALARM ditolak — '
          'notifikasi akan menggunakan inexact alarm sebagai fallback.',
        );
        // Tidak return false — masih bisa pakai inexact alarm
      }

      return true;
    }

    // iOS
    final iosImpl = _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImpl != null) {
      final granted = await iosImpl.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return true; // platform lain dianggap granted
  }

  /// Mengecek apakah exact alarm permission sudah di-grant (Android 12+).
  Future<bool> _hasExactAlarmPermission() async {
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl == null) return true; // non-Android: anggap OK

    try {
      return await androidImpl.canScheduleExactNotifications() ?? false;
    } catch (_) {
      return false;
    }
  }

  // ── Schedule ───────────────────────────────────────────────────────────────

  /// Menjadwalkan notifikasi pengingat untuk satu habit.
  /// Mengembalikan true jika berhasil dijadwalkan.
  /// Mengembalikan false jika gagal (permission ditolak / error lain).
  Future<bool> scheduleHabitReminder(HabitEntity habit) async {
    if (habit.reminderTime == null) return false;
    if (!_initialized) await initialize();

    // Cancel dulu yang lama (best-effort, tidak perlu sukses)
    await cancelHabitReminder(habit);

    final timeParts = habit.reminderTime!.split(':');
    if (timeParts.length != 2) return false;

    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) return false;

    final baseId = _notificationBaseId(habit.id);
    final title = habit.name;
    final body = 'Waktunya ${habit.name}! 💪';

    // Tentukan mode scheduling berdasarkan exact alarm permission
    final hasExact = await _hasExactAlarmPermission();
    final scheduleMode = hasExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    final notifDetails = _buildNotificationDetails();

    try {
      if (habit.frequencyType == 'specific_days') {
        await _scheduleSpecificDays(
          habit: habit,
          hour: hour,
          minute: minute,
          baseId: baseId,
          title: title,
          body: body,
          notifDetails: notifDetails,
          scheduleMode: scheduleMode,
        );
      } else {
        await _scheduleDailyRepeat(
          id: baseId,
          hour: hour,
          minute: minute,
          title: title,
          body: body,
          notifDetails: notifDetails,
          scheduleMode: scheduleMode,
        );
      }

      debugPrint(
        '[NotificationService] Reminder dijadwalkan: "${habit.name}" '
        'jam ${habit.reminderTime} | exact=$hasExact (ID base: $baseId)',
      );
      return true;
    } on PlatformException catch (e) {
      debugPrint(
        '[NotificationService] PlatformException saat schedule: ${e.message}',
      );
      return false;
    } catch (e) {
      debugPrint('[NotificationService] Error saat schedule: $e');
      return false;
    }
  }

  /// Menjadwalkan ulang semua habits yang punya reminderTime.
  Future<void> rescheduleAllReminders(List<HabitEntity> habits) async {
    if (!_initialized) await initialize();

    for (final habit in habits) {
      if (habit.reminderTime != null && !habit.isArchived) {
        await scheduleHabitReminder(habit);
      }
    }

    debugPrint(
      '[NotificationService] Reschedule selesai: ${habits.length} habit.',
    );
  }

  // ── Cancel ─────────────────────────────────────────────────────────────────

  /// Membatalkan notifikasi untuk satu habit.
  Future<void> cancelHabitReminder(HabitEntity habit) async {
    if (!_initialized) await initialize();

    try {
      final baseId = _notificationBaseId(habit.id);

      if (habit.frequencyType == 'specific_days') {
        for (int i = 1; i <= 7; i++) {
          await _plugin.cancel(baseId + i);
        }
      } else {
        await _plugin.cancel(baseId);
      }

      debugPrint(
        '[NotificationService] Reminder dibatalkan: "${habit.name}"',
      );
    } catch (e) {
      debugPrint('[NotificationService] Error saat cancel: $e');
    }
  }

  /// Membatalkan semua notifikasi aktif.
  Future<void> cancelAllReminders() async {
    if (!_initialized) await initialize();
    try {
      await _plugin.cancelAll();
      debugPrint('[NotificationService] Semua reminder dibatalkan.');
    } catch (e) {
      debugPrint('[NotificationService] Error saat cancelAll: $e');
    }
  }

  // ── Private Helpers ────────────────────────────────────────────────────────

  int _notificationBaseId(String habitId) {
    return habitId.hashCode.abs() % 100000;
  }

  NotificationDetails _buildNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> _scheduleDailyRepeat({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required NotificationDetails notifDetails,
    required AndroidScheduleMode scheduleMode,
  }) async {
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notifDetails,
      androidScheduleMode: scheduleMode,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _scheduleSpecificDays({
    required HabitEntity habit,
    required int hour,
    required int minute,
    required int baseId,
    required String title,
    required String body,
    required NotificationDetails notifDetails,
    required AndroidScheduleMode scheduleMode,
  }) async {
    final selectedDays =
        List<String>.from(habit.frequencyValue['days'] ?? []);

    for (final dayName in selectedDays) {
      final weekday = _dayNameToWeekday[dayName.toLowerCase()];
      if (weekday == null) continue;

      final id = baseId + weekday;
      final scheduledDate = _nextInstanceOfDayAndTime(weekday, hour, minute);

      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notifDetails,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfDayAndTime(int weekday, int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Maju hari demi hari sampai menemukan hari & waktu yang tepat
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
