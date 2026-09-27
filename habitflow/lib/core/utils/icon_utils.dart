import 'package:flutter/material.dart';

IconData getHabitIcon(String iconName) {
  switch (iconName) {
    // Rutinitas Pagi
    case 'alarm_on': return Icons.alarm_on;
    case 'fitness_center': return Icons.fitness_center;
    case 'restaurant': return Icons.restaurant;
    case 'edit_note': return Icons.edit_note;
    // Gaya Hidup Sehat
    case 'local_drink': return Icons.local_drink;
    case 'bedtime': return Icons.bedtime;
    case 'directions_walk': return Icons.directions_walk;
    case 'no_food': return Icons.no_food;
    // Fokus Belajar
    case 'menu_book': return Icons.menu_book;
    case 'notes': return Icons.notes;
    case 'no_cell': return Icons.no_cell;
    case 'app_blocking': return Icons.app_blocking;
    case 'quiz': return Icons.quiz;
    // Mindfulness
    case 'self_improvement': return Icons.self_improvement;
    case 'favorite': return Icons.favorite;
    case 'do_not_disturb': return Icons.do_not_disturb;
    case 'air': return Icons.air;
    // Olahraga & Kebugaran
    case 'directions_run': return Icons.directions_run;
    case 'accessibility_new': return Icons.accessibility_new;
    case 'pool': return Icons.pool;
    case 'sports_gymnastics': return Icons.sports_gymnastics;
    // Pengembangan Diri
    case 'headphones': return Icons.headphones;
    case 'lightbulb': return Icons.lightbulb;
    case 'people': return Icons.people;
    case 'track_changes': return Icons.track_changes;
    case 'trending_up': return Icons.trending_up;
    // Istirahat & Relaksasi
    case 'nature_people': return Icons.nature_people;
    case 'phonelink_off': return Icons.phonelink_off;
    case 'auto_stories': return Icons.auto_stories;
    case 'weekend': return Icons.weekend;
    default: return Icons.check_circle_outline;
  }
}

/// A preset list of all available icons for the color & icon picker
final List<String> presetHabitIcons = [
  // Rutinitas & Kesehatan
  'alarm_on', 'fitness_center', 'restaurant', 'edit_note',
  'local_drink', 'bedtime', 'directions_walk', 'no_food',
  // Belajar & Produktivitas
  'menu_book', 'notes', 'app_blocking', 'quiz',
  'no_cell', 'lightbulb', 'track_changes', 'trending_up',
  // Mindfulness
  'self_improvement', 'favorite', 'do_not_disturb', 'air',
  // Olahraga
  'directions_run', 'accessibility_new', 'pool', 'sports_gymnastics',
  // Pengembangan Diri & Sosial
  'headphones', 'people',
  // Istirahat & Relaksasi
  'nature_people', 'phonelink_off', 'auto_stories', 'weekend',
];
