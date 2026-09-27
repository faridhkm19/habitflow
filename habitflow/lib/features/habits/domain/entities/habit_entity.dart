import 'package:equatable/equatable.dart';

class HabitEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String iconName;
  final String colorHex;
  final String category;
  final String frequencyType;
  final Map<String, dynamic> frequencyValue;
  final String? reminderTime;
  final String? reminderMessage;
  final bool isArchived;
  final int longestStreak;
  final DateTime createdAt;
  final DateTime updatedAt;

  const HabitEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.category,
    required this.frequencyType,
    this.frequencyValue = const {},
    this.reminderTime,
    this.reminderMessage,
    this.isArchived = false,
    this.longestStreak = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        iconName,
        colorHex,
        category,
        frequencyType,
        frequencyValue,
        reminderTime,
        reminderMessage,
        isArchived,
        longestStreak,
        createdAt,
        updatedAt,
      ];
}
