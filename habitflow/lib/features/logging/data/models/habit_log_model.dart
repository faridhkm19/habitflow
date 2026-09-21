import '../../domain/entities/habit_log_entity.dart';

class HabitLogModel extends HabitLogEntity {
  const HabitLogModel({
    required super.id,
    required super.habitId,
    required super.userId,
    required super.logDate,
    required super.isCompleted,
    super.mood,
    super.note,
    required super.createdAt,
  });

  factory HabitLogModel.fromJson(Map<String, dynamic> json) {
    return HabitLogModel(
      id: json['id'] as String,
      habitId: json['habit_id'] as String,
      userId: json['user_id'] as String,
      logDate: DateTime.parse(json['log_date'] as String),
      isCompleted: json['is_completed'] as bool? ?? true,
      mood: json['mood'] as String?,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    // Format YYYY-MM-DD for date
    final String dateString = logDate.toIso8601String().split('T').first;
    
    final map = <String, dynamic>{
      'habit_id': habitId,
      'user_id': userId,
      'log_date': dateString,
      'is_completed': isCompleted,
      'mood': mood,
      'note': note,
    };

    if (id.isNotEmpty) {
      map['id'] = id;
    }

    return map;
  }

  factory HabitLogModel.fromEntity(HabitLogEntity entity) {
    return HabitLogModel(
      id: entity.id,
      habitId: entity.habitId,
      userId: entity.userId,
      logDate: entity.logDate,
      isCompleted: entity.isCompleted,
      mood: entity.mood,
      note: entity.note,
      createdAt: entity.createdAt,
    );
  }
}
