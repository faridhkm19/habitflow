import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String? displayName;
  final String? avatarUrl;
  final String themePreference;
  final bool isOnboarded;

  final int totalHabits;
  final int longestStreak;
  final int totalCheckIns;

  const ProfileEntity({
    required this.id,
    this.displayName,
    this.avatarUrl,
    required this.themePreference,
    required this.isOnboarded,
    this.totalHabits = 0,
    this.longestStreak = 0,
    this.totalCheckIns = 0,
  });

  @override
  List<Object?> get props => [
        id,
        displayName,
        avatarUrl,
        themePreference,
        isOnboarded,
        totalHabits,
        longestStreak,
        totalCheckIns,
      ];
}
