import '../../domain/entities/journal_entry_entity.dart';

class JournalEntryModel extends JournalEntryEntity {
  const JournalEntryModel({
    required super.habitId,
    required super.logDate,
    required super.isCompleted,
    super.mood,
    super.note,
    required super.habitName,
    required super.habitIconName,
    required super.habitColorHex,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    final habitData = json['habits'] as Map<String, dynamic>;
    return JournalEntryModel(
      habitId: json['habit_id'] as String,
      logDate: DateTime.parse(json['log_date'] as String),
      isCompleted: json['is_completed'] as bool,
      mood: json['mood'] as String?,
      note: json['note'] as String?,
      habitName: habitData['name'] as String,
      habitIconName: habitData['icon_name'] as String,
      habitColorHex: habitData['color_hex'] as String,
    );
  }
}
