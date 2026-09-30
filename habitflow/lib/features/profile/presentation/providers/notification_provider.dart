// lib/features/profile/presentation/providers/notification_provider.dart
//
// Provider untuk global toggle notifikasi (on/off).
// Saat toggle on  → reschedule semua reminder habit yang aktif.
// Saat toggle off → cancel semua notifikasi yang sedang terjadwal.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../features/habits/domain/usecases/schedule_habit_reminders_usecase.dart';
import '../../../../features/habits/presentation/providers/habit_provider.dart';

class NotificationNotifier extends StateNotifier<bool> {
  final Ref _ref;

  NotificationNotifier(this._ref)
      : super(PreferencesService.instance.notificationsEnabled);

  Future<void> toggle(bool value) async {
    // Simpan preferensi terlebih dahulu
    await PreferencesService.instance.setNotificationsEnabled(value);
    state = value;

    if (!value) {
      // Matikan semua notifikasi yang sedang terjadwal
      await NotificationService.instance.cancelAllReminders();
    } else {
      // Nyalakan kembali: jadwalkan ulang semua habit yang punya reminderTime
      final scheduleUseCase = _ref.read(scheduleHabitRemindersUseCaseProvider);
      await scheduleUseCase();
    }
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier(ref);
});

// Provider untuk use case (diletakkan di sini agar mudah diakses)
final scheduleHabitRemindersUseCaseProvider =
    Provider<ScheduleHabitRemindersUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return ScheduleHabitRemindersUseCase(repository);
});
