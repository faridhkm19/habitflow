import 'package:equatable/equatable.dart';

class JournalEntryEntity extends Equatable {
  final String habitId;
  final DateTime logDate;
  final bool isCompleted;
  final String? mood;
  final String? note;
  final String habitName;
  final String habitIconName;
  final String habitColorHex;

  const JournalEntryEntity({
    required this.habitId,
    required this.logDate,
    required this.isCompleted,
    this.mood,
    this.note,
    required this.habitName,
    required this.habitIconName,
    required this.habitColorHex,
  });

  @override
  List<Object?> get props => [
    habitId,
    logDate,
    isCompleted,
    mood,
    note,
    habitName,
    habitIconName,
    habitColorHex,
  ];
}
