import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    super.displayName,
    super.avatarUrl,
    required super.themePreference,
    required super.isOnboarded,
    super.totalHabits,
    super.longestStreak,
    super.totalCheckIns,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json, {
    int totalHabits = 0,
    int longestStreak = 0,
    int totalCheckIns = 0,
  }) {
    return ProfileModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      themePreference: json['theme_preference'] as String? ?? 'light',
      isOnboarded: json['is_onboarded'] as bool? ?? false,
      totalHabits: totalHabits,
      longestStreak: longestStreak,
      totalCheckIns: totalCheckIns,
    );
  }
}
