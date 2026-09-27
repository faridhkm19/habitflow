import '../../domain/entities/habit_entity.dart';

class HabitModel extends HabitEntity {
  const HabitModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.iconName,
    required super.colorHex,
    required super.category,
    required super.frequencyType,
    super.frequencyValue,
    super.reminderTime,
    super.reminderMessage,
    super.isArchived,
    super.longestStreak,
    required super.createdAt,
    required super.updatedAt,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String,
      colorHex: json['color_hex'] as String,
      category: json['category'] as String,
      frequencyType: json['frequency_type'] as String,
      frequencyValue: json['frequency_value'] as Map<String, dynamic>? ?? {},
      reminderTime: json['reminder_time'] as String?,
      reminderMessage: json['reminder_message'] as String?,
      isArchived: json['is_archived'] as bool? ?? false,
      longestStreak: json['longest_streak'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'user_id': userId,
      'name': name,
      'icon_name': iconName,
      'color_hex': colorHex,
      'category': category,
      'frequency_type': frequencyType,
      'frequency_value': frequencyValue,
      'reminder_time': reminderTime,
      'reminder_message': reminderMessage,
      'is_archived': isArchived,
      'longest_streak': longestStreak,
      // created_at dan updated_at di-handle otomatis oleh Supabase
    };

    if (id.isNotEmpty) {
      map['id'] = id;
    }

    return map;
  }

  /// Konversi dari Entity murni ke Model
  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      iconName: entity.iconName,
      colorHex: entity.colorHex,
      category: entity.category,
      frequencyType: entity.frequencyType,
      frequencyValue: entity.frequencyValue,
      reminderTime: entity.reminderTime,
      reminderMessage: entity.reminderMessage,
      isArchived: entity.isArchived,
      longestStreak: entity.longestStreak,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
