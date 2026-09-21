// lib/core/theme/theme_preview_screen.dart
//
// Visual showcase of all Design System tokens and shared widgets.
// FOR VERIFICATION ONLY — will be removed before Phase 2.
//
// Displays:
//   - Color swatches for all AppColors tokens
//   - All text styles from AppTextStyles
//   - All AppButton variants (primary / secondary / text + disabled states)
//   - AppTextField examples (default, focus, error)
//   - AppCard variants (habit, stat)
//   - LoadingIndicator
//   - Spacing and radius references

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_elevation.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_indicator.dart';

class ThemePreviewScreen extends StatelessWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Design System Preview'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Color Swatches ───────────────────────────────────────────
            _SectionHeader('Color System'),
            _SubHeader('Brand Colors'),
            _ColorRow([
              _ColorSwatch(AppColors.primary, 'primary\n#4E55E0'),
              _ColorSwatch(AppColors.secondary, 'secondary\n#B8EB6C', textColor: AppColors.textPrimary),
              _ColorSwatch(AppColors.accent1, 'accent1\n#F7CD63', textColor: AppColors.textPrimary),
              _ColorSwatch(AppColors.accent2, 'accent2\n#FC8FC6', textColor: AppColors.textPrimary),
            ]),
            const SizedBox(height: AppSpacing.sm),
            _SubHeader('Tints & Shades'),
            _ColorRow([
              _ColorSwatch(AppColors.primaryLight, 'primary\nLight', textColor: AppColors.primary),
              _ColorSwatch(AppColors.primaryDark, 'primary\nDark'),
              _ColorSwatch(AppColors.secondaryLight, 'secondary\nLight', textColor: AppColors.textPrimary),
              _ColorSwatch(AppColors.secondaryDark, 'secondary\nDark'),
              _ColorSwatch(AppColors.accent1Light, 'accent1\nLight', textColor: AppColors.textPrimary),
              _ColorSwatch(AppColors.accent2Light, 'accent2\nLight', textColor: AppColors.textPrimary),
            ]),
            const SizedBox(height: AppSpacing.sm),
            _SubHeader('Neutrals (Light Mode)'),
            _ColorRow([
              _ColorSwatch(AppColors.background, 'background\n#FDFBF7', textColor: AppColors.textPrimary, hasBorder: true),
              _ColorSwatch(AppColors.surface, 'surface\n#FFFFFF', textColor: AppColors.textPrimary, hasBorder: true),
              _ColorSwatch(AppColors.border, 'border\n#E8E4DC', textColor: AppColors.textPrimary),
              _ColorSwatch(AppColors.textPrimary, 'textPrimary\n#2B2B2B'),
              _ColorSwatch(AppColors.textSecondary, 'textSecondary\n#6E6E6E'),
            ]),
            const SizedBox(height: AppSpacing.sm),
            _SubHeader('Semantic'),
            _ColorRow([
              _ColorSwatch(AppColors.success, 'success', textColor: AppColors.textPrimary),
              _ColorSwatch(AppColors.warning, 'warning', textColor: AppColors.textPrimary),
              _ColorSwatch(AppColors.error, 'error'),
              _ColorSwatch(AppColors.neutralMissed, 'neutralMissed', textColor: AppColors.textPrimary),
            ]),
            const SizedBox(height: AppSpacing.sm),
            _SubHeader('Habit Color Picker'),
            _ColorRow(
              AppColors.habitColors
                  .map((c) => _ColorSwatch(c, '', textColor: Colors.white))
                  .toList(),
            ),

            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border),

            // ── Typography ───────────────────────────────────────────────
            _SectionHeader('Typography (Poppins)'),
            Text('display — 32px Bold', style: AppTextStyles.display.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.sm),
            Text('h1 — 24px SemiBold', style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.xs),
            Text('h2 — 20px SemiBold', style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.xs),
            Text('h3 — 16px SemiBold', style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: AppSpacing.xs),
            Text('bodyLarge — 16px Regular', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary)),
            Text('bodyMedium — 14px Regular', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
            Text('bodySmall — 12px Regular', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.xs),
            Text('button — 14px Medium', style: AppTextStyles.button.copyWith(color: AppColors.primary)),
            const SizedBox(height: AppSpacing.xs),
            Text('numberLarge — 28px Bold', style: AppTextStyles.numberLarge.copyWith(color: AppColors.textPrimary)),

            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border),

            // ── Buttons ──────────────────────────────────────────────────
            _SectionHeader('Buttons'),
            _SubHeader('Primary'),
            AppButton(label: 'Masuk', onPressed: () {}),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'Loading...', onPressed: () {}, isLoading: true),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'Disabled', onPressed: null),
            const SizedBox(height: AppSpacing.md),

            _SubHeader('Secondary'),
            AppButton(label: 'Batal', variant: AppButtonVariant.secondary, onPressed: () {}),
            const SizedBox(height: AppSpacing.sm),
            AppButton(label: 'Disabled', variant: AppButtonVariant.secondary, onPressed: null),
            const SizedBox(height: AppSpacing.md),

            _SubHeader('Text'),
            AppButton(label: 'Lupa password?', variant: AppButtonVariant.text, onPressed: () {}, isFullWidth: false),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Dengan Icon',
              variant: AppButtonVariant.primary,
              onPressed: () {},
              prefixIcon: Icons.add_rounded,
              isFullWidth: false,
            ),

            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border),

            // ── Input Fields ─────────────────────────────────────────────
            _SectionHeader('Input Fields'),
            AppTextField(
              label: 'Email',
              hint: 'Masukkan email kamu',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Password',
              hint: 'Min. 8 karakter',
              obscureText: true,
              prefixIcon: Icons.lock_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Catatan (maks. 100 karakter)',
              hint: 'Tambahkan catatan opsional...',
              maxLength: 100,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            // Error state
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Field Error',
                hintText: 'Dengan error state',
                errorText: 'Kolom ini wajib diisi',
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(borderRadius: AppRadius.sm),
                errorBorder: OutlineInputBorder(
                  borderRadius: AppRadius.sm,
                  borderSide: const BorderSide(color: AppColors.error, width: 1),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border),

            // ── Cards ────────────────────────────────────────────────────
            _SectionHeader('Cards'),
            _SubHeader('Habit Card (radius.md, space.md, elevation.low)'),
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.full,
                    ),
                    child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olahraga Pagi', style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary)),
                        Text('🔥 7 hari berturut', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: AppRadius.full,
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SubHeader('Stat Card (radius.lg, space.lg, elevation.low)'),
            AppCard(
              variant: AppCardVariant.stat,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Consistency Score', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: AppSpacing.xs),
                  Text('85%', style: AppTextStyles.numberLarge.copyWith(color: AppColors.primary)),
                  Text('30 hari terakhir', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              onTap: () {},
              child: Text('Card dengan tap/onTap', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
            ),

            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border),

            // ── Loading Indicator ────────────────────────────────────────
            _SectionHeader('Loading Indicator'),
            Row(
              children: [
                const LoadingIndicator(size: 24),
                const SizedBox(width: AppSpacing.md),
                const LoadingIndicator(size: 32),
                const SizedBox(width: AppSpacing.md),
                const LoadingIndicator(size: 48),
                const SizedBox(width: AppSpacing.md),
                LoadingIndicator(size: 32, color: AppColors.secondary),
                const SizedBox(width: AppSpacing.md),
                LoadingIndicator(size: 32, color: AppColors.accent1),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border),

            // ── Border Radius Reference ───────────────────────────────────
            _SectionHeader('Border Radius'),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _RadiusSwatch(AppRadius.smValue, 'sm\n8px'),
                _RadiusSwatch(AppRadius.mdValue, 'md\n12px'),
                _RadiusSwatch(AppRadius.lgValue, 'lg\n16px'),
                _RadiusSwatch(AppRadius.xlValue, 'xl\n24px'),
                _RadiusSwatch(AppRadius.fullValue, 'full\n999px'),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            const Divider(color: AppColors.border),

            // ── Elevation Reference ───────────────────────────────────────
            _SectionHeader('Elevation / Shadow'),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _ElevationSwatch(AppElevation.low, 'elevation.low\nCard habit'),
                _ElevationSwatch(AppElevation.medium, 'elevation.medium\nBottom sheet'),
                _ElevationSwatch(AppElevation.high, 'elevation.high\nDialog'),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ── Footer ────────────────────────────────────────────────────
            Center(
              child: Text(
                '✅ HabitFlow Design System — Phase 2 Complete',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ── Helper widgets ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Text(
        title,
        style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

class _SubHeader extends StatelessWidget {
  const _SubHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(
        title,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow(this.swatches);
  final List<Widget> swatches;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: swatches);
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch(
    this.color,
    this.label, {
    this.textColor = Colors.white,
    this.hasBorder = false,
  });

  final Color color;
  final String label;
  final Color textColor;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.sm,
        border: hasBorder ? Border.all(color: AppColors.border) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _RadiusSwatch extends StatelessWidget {
  const _RadiusSwatch(this.radius, this.label);
  final double radius;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(radius.clamp(0, 30)),
            border: Border.all(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
      ],
    );
  }
}

class _ElevationSwatch extends StatelessWidget {
  const _ElevationSwatch(this.shadows, this.label);
  final List<BoxShadow> shadows;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.md,
            boxShadow: shadows,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
      ],
    );
  }
}
