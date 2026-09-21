import '../../features/habits/domain/entities/habit_entity.dart';

/// Cek apakah habit dijadwalkan pada tanggal tertentu
bool isScheduledForToday(HabitEntity habit, DateTime date) {
  switch (habit.frequencyType) {
    case 'daily':
      return true;
    case 'specific_days':
      // frequency_value: {"days": ["mon","tue","wed",...]}
      final days = habit.frequencyValue['days'];
      if (days == null) return false;
      final List<String> scheduledDays = List<String>.from(days);
      final dayKey = _weekdayKey(date);
      return scheduledDays.contains(dayKey);
    case 'x_per_week':
      // Tampil setiap hari — user bebas pilih kapan
      return true;
    default:
      return true;
  }
}

/// Konversi weekday int ke key string (sesuai format DB)
String _weekdayKey(DateTime date) {
  switch (date.weekday) {
    case DateTime.monday:
      return 'mon';
    case DateTime.tuesday:
      return 'tue';
    case DateTime.wednesday:
      return 'wed';
    case DateTime.thursday:
      return 'thu';
    case DateTime.friday:
      return 'fri';
    case DateTime.saturday:
      return 'sat';
    case DateTime.sunday:
      return 'sun';
    default:
      return '';
  }
}

/// Strip waktu, hanya bandingkan tanggal (YYYY-MM-DD)
bool isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

/// Format tanggal ke YYYY-MM-DD
String toDateString(DateTime date) {
  return date.toIso8601String().split('T').first;
}
