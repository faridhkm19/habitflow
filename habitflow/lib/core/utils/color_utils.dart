import 'package:flutter/material.dart';

extension ColorExtension on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    // Migration: Replace old primary blue/purple with new mint green
    if (hexString.toUpperCase() == '#4E55E0' ||
        hexString.toUpperCase() == '4E55E0') {
      hexString = '7AE0C4';
    }

    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) =>
      '${leadingHashSign ? '#' : ''}'
      '${(r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
      '${(g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
      '${(b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}';
}

Color getLighterColor(Color color, [double opacity = 0.15]) {
  return color.withValues(alpha: opacity);
}
