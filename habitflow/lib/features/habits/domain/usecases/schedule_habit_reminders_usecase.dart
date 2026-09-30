// lib/features/habits/domain/usecases/schedule_habit_reminders_usecase.dart
//
// Use case untuk menjadwalkan ulang semua reminder habit yang aktif.
// Dipanggil dari NotificationNotifier saat global toggle notifikasi dinyalakan.

import '../../../../core/errors/failures.dart';
import '../../../../core/services/notification_service.dart';
import '../repositories/habit_repository.dart';

class ScheduleHabitRemindersUseCase {
  final HabitRepository repository;

  ScheduleHabitRemindersUseCase(this.repository);

  Future<void> call() async {
    final result = await repository.getHabits();

    if (result.isOk) {
      final habits = result.valueOrNull ?? [];

      // Hanya habits yang aktif (tidak diarsipkan) dan punya reminderTime
      final habitsWithReminder = habits
          .where((h) => !h.isArchived && h.reminderTime != null)
          .toList();

      await NotificationService.instance
          .rescheduleAllReminders(habitsWithReminder);
    }
  }
}
