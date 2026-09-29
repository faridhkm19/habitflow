import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AchievementEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.isUnlocked,
    this.unlockedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        color,
        backgroundColor,
        isUnlocked,
        unlockedAt,
      ];
}
