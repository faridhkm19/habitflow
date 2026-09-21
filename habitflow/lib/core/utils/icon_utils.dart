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
    default: return Icons.check_circle_outline;
  }
}

/// A preset list of all available icons for the color & icon picker
final List<String> presetHabitIcons = [
  'alarm_on', 'fitness_center', 'restaurant', 'edit_note',
  'local_drink', 'bedtime', 'directions_walk', 'no_food',
  'menu_book', 'notes', 'no_cell', 'app_blocking', 'quiz',
  'self_improvement', 'favorite', 'do_not_disturb', 'air'
];
