import 'package:equatable/equatable.dart';

class HabitLogEntity extends Equatable {
  final String id;
  final String habitId;
  final String userId;
  final DateTime logDate;
  final bool isCompleted;
  final String? mood;
  final String? note;
  final DateTime createdAt;

  const HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.logDate,
    required this.isCompleted,
    this.mood,
    this.note,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        habitId,
        userId,
        logDate,
        isCompleted,
        mood,
        note,
        createdAt,
      ];
}
