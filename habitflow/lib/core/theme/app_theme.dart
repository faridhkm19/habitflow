import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_text_styles.dart';

/// HabitFlow ThemeData
/// Source of truth: Design_System.md (all sections)
///
/// Assembles all design tokens into a single Flutter ThemeData for LIGHT MODE.
/// Dark mode is NOT implemented at this stage — see Design_System.md §11.
///
/// Usage:
///   MaterialApp.router(theme: AppTheme.light, ...)
abstract final class AppTheme {
  AppTheme._();

  /// Light mode ThemeData — the only theme implemented at this stage.
  static ThemeData get light {
    // Build the color scheme from our brand tokens
    final colorScheme = ColorScheme(
      brightness: Brightness.light,

      // Primary
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primary,

      // Secondary (Lime Green)
      secondary: AppColors.secondary,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.secondaryLight,
      onSecondaryContainer: AppColors.secondaryDark,

      // Tertiary (Mustard Amber — accent1)
      tertiary: AppColors.accent1,
      onTertiary: AppColors.textPrimary,
      tertiaryContainer: AppColors.accent1Light,
      onTertiaryContainer: AppColors.textPrimary,

      // Error
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),

      // Surface & Background
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.border,
      onSurfaceVariant: AppColors.textSecondary,

      // Outline
      outline: AppColors.border,
      outlineVariant: AppColors.border,
    );

    // Text theme built from Poppins — applies to all Material widgets
    final textTheme = TextTheme(
      // display* → our display / h1 / h2
      displayLarge: AppTextStyles.display.copyWith(
        color: AppColors.textPrimary,
      ),
      displayMedium: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
      displaySmall: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),

      // headline* → our h3 / bodyLarge
      headlineLarge: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
      headlineMedium: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.textPrimary,
      ),
      headlineSmall: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.textPrimary,
      ),

      // title* → mapped to h3 and bodyLarge
      titleLarge: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
      titleMedium: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      titleSmall: AppTextStyles.bodySmall.copyWith(
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),

      // body* → bodyLarge / bodyMedium
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
      ),
      bodySmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),

      // label* → button / bodySmall
      labelLarge: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
      labelMedium: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
      labelSmall: AppTextStyles.bodySmall.copyWith(
        color: AppColors.textSecondary,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // Apply Poppins as the app-wide font family
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: textTheme,

      // ── Page & Scaffold ───────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── Global Ripple/Splash ───────────────────────────────────────────────
      splashColor: AppColors.primary.withValues(alpha: 0.12),
      highlightColor: AppColors.primary.withValues(alpha: 0.08),

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        centerTitle: false,
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      // Habit Card: surface bg, radius.md, elevation.low shadow
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0, // we use custom BoxShadow, not Flutter elevation
        shape: AppRadius.mdShape,
        margin: EdgeInsets.zero,
      ),

      // ── ElevatedButton (maps to Primary Button) ───────────────────────────
      // Background: color.primary | Text: color.text.onPrimary | Radius: radius.md
      // Padding: vertical 14px, horizontal 24px
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: AppColors.textOnPrimary.withValues(
            alpha: 0.6,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: AppRadius.mdShape,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: AppTextStyles.button,
        ),
      ),

      // ── OutlinedButton (maps to Secondary Button) ─────────────────────────
      // Transparent bg | 1.5px border color.primary | Text: color.primary | Radius: radius.md
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.primary.withValues(alpha: 0.4),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: AppRadius.mdShape,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: AppTextStyles.button,
        ),
      ),

      // ── TextButton (maps to Text Button) ─────────────────────────────────
      // No bg/border | Text: color.primary
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.primary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          textStyle: AppTextStyles.button,
        ),
      ),

      // ── FloatingActionButton ──────────────────────────────────────────────
      // Background: color.primary | Shape: radius.full | Shadow: elevation.medium
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        shape: AppRadius.fullShape,
      ),

      // ── InputDecoration (Input Field) ─────────────────────────────────────
      // Background: color.surface | Border: 1px color.border → color.primary on focus
      // Radius: radius.sm | Padding: v14 h16 | Floating label
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        // Border styles
        border: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(
            color: AppColors.border.withValues(alpha: 0.5),
            width: 1,
          ),
        ),

        // Label & hint styling
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),

      // ── BottomNavigationBar ───────────────────────────────────────────────
      // Background: color.surface
      // Active: color.primary | Inactive: color.text.secondary
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodySmall,
        elevation: 8,
      ),

      // ── NavigationBar (Material 3 version of BottomNavigationBar) ─────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryLight,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textSecondary, size: 24);
        }),
        elevation: 8,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // ── Chip ─────────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.border,
        labelStyle: AppTextStyles.bodySmall,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.sm,
          side: BorderSide(color: AppColors.border),
        ),
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        surfaceTintColor: Colors.transparent,
        color: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryLight;
          }
          return AppColors.surface;
        }),
      ),

      // ── SnackBar ──────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textOnPrimary,
        ),
        behavior: SnackBarBehavior.floating,
        shape: AppRadius.mdShape,
      ),

      // ── Dialog ────────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: AppRadius.lgShape,
        titleTextStyle: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  /// Dark mode ThemeData — a basic dark theme implementation
  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,

      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryDark,
      onPrimaryContainer: Colors.white,

      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryDark,
      onSecondaryContainer: Colors.white,

      tertiary: AppColors.accent1,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.accent1Light,
      onTertiaryContainer: Colors.white,

      error: AppColors.error,
      onError: Colors.white,
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),

      // Use dark backgrounds
      surface: const Color(0xFF1E1E1E),
      onSurface: Colors.white,
      surfaceContainerHighest: const Color(0xFF333333),
      onSurfaceVariant: Colors.white,

      outline: const Color(0xFF555555),
      outlineVariant: const Color(0xFF444444),
    );

    final textTheme = TextTheme(
      displayLarge: AppTextStyles.display.copyWith(color: Colors.white),
      displayMedium: AppTextStyles.h1.copyWith(color: Colors.white),
      displaySmall: AppTextStyles.h2.copyWith(color: Colors.white),
      headlineLarge: AppTextStyles.h3.copyWith(color: Colors.white),
      headlineMedium: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      headlineSmall: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      titleLarge: AppTextStyles.h3.copyWith(color: Colors.white),
      titleMedium: AppTextStyles.bodyMedium.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      titleSmall: AppTextStyles.bodySmall.copyWith(
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.white),
      labelLarge: AppTextStyles.button.copyWith(color: Colors.white),
      labelMedium: AppTextStyles.bodySmall.copyWith(color: Colors.white),
      labelSmall: AppTextStyles.bodySmall.copyWith(color: Colors.white),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: const Color(0xFF121212),

      // ── Global Ripple/Splash ───────────────────────────────────────────────
      splashColor: AppColors.primary.withValues(alpha: 0.18),
      highlightColor: AppColors.primary.withValues(alpha: 0.12),

      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF121212),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: AppTextStyles.h2.copyWith(color: Colors.white),
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 0,
        shape: AppRadius.mdShape,
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: AppRadius.mdShape,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.primary.withValues(alpha: 0.4),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: AppRadius.mdShape,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.primary.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          textStyle: AppTextStyles.button,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: AppRadius.fullShape,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: Color(0xFF555555), width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: Color(0xFF555555), width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.sm,
          borderSide: BorderSide(
            color: const Color(0xFF555555).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
        floatingLabelStyle: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
        errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.white,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.bodySmall,
        elevation: 8,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        indicatorColor: AppColors.primaryDark,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTextStyles.bodySmall.copyWith(color: Colors.white);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: Colors.white, size: 24);
        }),
        elevation: 8,
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF555555),
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedColor: AppColors.primary,
        disabledColor: const Color(0xFF555555),
        labelStyle: AppTextStyles.bodySmall,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.sm,
          side: BorderSide(color: Color(0xFF555555)),
        ),
        side: const BorderSide(color: Color(0xFF555555)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        surfaceTintColor: Colors.transparent,
        color: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          if (states.contains(WidgetState.pressed)) {
            return AppColors.primaryDark;
          }
          return const Color(0xFF1E1E1E);
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.black,
        ),
        behavior: SnackBarBehavior.floating,
        shape: AppRadius.mdShape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: AppRadius.lgShape,
        titleTextStyle: AppTextStyles.h2.copyWith(color: Colors.white),
        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
