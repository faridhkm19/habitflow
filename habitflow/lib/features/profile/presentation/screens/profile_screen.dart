import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_stat_card.dart';
import '../widgets/habitflow_toggle.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showAvatarOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Text(
                  'Ganti Foto Profil',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ref, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accent1Light,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.photo_library_rounded,
                    color: AppColors.accent1,
                    size: 20,
                  ),
                ),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ref, ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      await ref
          .read(avatarUploadNotifierProvider.notifier)
          .uploadAvatar(pickedFile.path);
      // ignore: use_build_context_synchronously
      if (!context.mounted) return;
      final error = ref.read(avatarUploadNotifierProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar'),
          content: const Text('Apakah kamu yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                ref.read(authNotifierProvider.notifier).signOut();
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final containerBg = isDark
            ? AppColors.primary.withValues(alpha: 0.12)
            : AppColors.primaryLight;
        final quoteTextColor = isDark
            ? AppColors.primary.withValues(alpha: 0.9)
            : AppColors.primaryDark;

        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo aplikasi
              Image.asset(
                'assets/images/app_logo.png',
                width: 80,
                height: 80,
              ),
              const SizedBox(height: 14),
              Text(
                'Habit Flow',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Versi 1.0.0',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isDark ? Colors.white60 : Colors.black45,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              // Tagline
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: containerBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  '"Build better days, one habit at a time."',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: quoteTextColor,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              // Fitur-fitur utama
              _AboutFeatureRow(
                icon: Icons.track_changes_rounded,
                color: AppColors.primary,
                text: 'Lacak kebiasaan harian dengan mudah & konsisten',
              ),
              const SizedBox(height: 10),
              _AboutFeatureRow(
                icon: Icons.local_fire_department_rounded,
                color: AppColors.accent1,
                text: 'Pantau streak & pencapaian agar tetap termotivasi',
              ),
              const SizedBox(height: 10),
              _AboutFeatureRow(
                icon: Icons.bar_chart_rounded,
                color: AppColors.secondaryDark,
                text: 'Statistik kemajuan mingguan & bulanan yang detail',
              ),
              const SizedBox(height: 10),
              _AboutFeatureRow(
                icon: Icons.notifications_active_rounded,
                color: AppColors.accent2,
                text: 'Pengingat cerdas agar tidak ada habit yang terlewat',
              ),
              const SizedBox(height: 8),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          actions: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull;
    final emailOverride = ref.watch(currentEmailProvider);
    final isUploading = ref.watch(avatarUploadNotifierProvider).isLoading;

    // Toggles state
    final themeMode = ref.watch(themeProvider);
    final isNotifEnabled = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.08),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text('Profil', style: AppTextStyles.h1),
      ),
      body: profileAsync.when(
        skipLoadingOnReload: true,
        data: (profile) {
          if (profile == null || user == null) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final displayName = profile.displayName ?? 'Pengguna HabitFlow';

          return ListView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.paddingOf(context).bottom +
                  AppSpacing.listBottomPadding,
            ),
            children: [
              // ── HEADER BLOCK ──────────────────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
                padding: const EdgeInsets.only(top: 8, bottom: 28),
                child: Column(
                  children: [
                    ProfileAvatar(
                      avatarUrl: profile.avatarUrl,
                      displayName: displayName,
                      isLoading: isUploading,
                      onTap: () => _showAvatarOptions(context, ref),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          displayName,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => context.push('/profile/edit'),
                          child: Icon(
                            Icons.edit_rounded,
                            size: 20,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      emailOverride ?? user.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              ClipPath(
                clipper: _HeaderCurveClipper(),
                child: Container(
                  height: 28,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
              ),

              const SizedBox(height: 4),

              // ── STAT CARDS ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    ProfileStatCard(
                      label: 'Habit',
                      value: profile.totalHabits.toString(),
                      icon: Icons.directions_run_rounded,
                      backgroundColor: AppColors.primaryLight,
                      iconColor: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    ProfileStatCard(
                      label: 'Streak',
                      value: profile.longestStreak.toString(),
                      icon: Icons.local_fire_department_rounded,
                      backgroundColor: AppColors.accent1Light,
                      iconColor: AppColors.accent1,
                    ),
                    const SizedBox(width: 10),
                    ProfileStatCard(
                      label: 'Check-in',
                      value: profile.totalCheckIns.toString(),
                      icon: Icons.check_circle_rounded,
                      backgroundColor: AppColors.secondaryLight,
                      iconColor: AppColors.secondaryDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ═══════════════════════════════════════════════════════════
              // SECTION 1 — Preferensi
              // ═══════════════════════════════════════════════════════════
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'Preferensi'),
                    const SizedBox(height: 8),
                    _MenuCard(
                      children: [
                        _MenuTile(
                          icon: Icons.shield_rounded,
                          iconBg: AppColors.secondaryLight,
                          iconColor: AppColors.secondaryDark,
                          title: 'Keamanan Akun',
                          onTap: () => context.push('/profile/security'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ═══════════════════════════════════════════════════════════
              // SECTION 1.5 — Pengaturan Aplikasi
              // ═══════════════════════════════════════════════════════════
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'Pengaturan Aplikasi'),
                    const SizedBox(height: 8),
                    _MenuCard(
                      children: [
                        _ThemeDropdownRow(
                          currentMode: themeMode,
                          onChanged: (val) =>
                              ref.read(themeProvider.notifier).setTheme(val),
                        ),
                        const _RowDivider(),
                        _ToggleRow(
                          icon: Icons.notifications_rounded,
                          iconBg: AppColors.accent1Light,
                          iconColor: AppColors.accent1,
                          title: 'Notifikasi',
                          subtitle: isNotifEnabled
                              ? 'Pengingat habit aktif'
                              : 'Pengingat habit nonaktif',
                          value: isNotifEnabled,
                          onChanged: (val) => ref
                              .read(notificationProvider.notifier)
                              .toggle(val),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ═══════════════════════════════════════════════════════════
              // SECTION 2 — Aktivitas Saya
              // ═══════════════════════════════════════════════════════════
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'Aktivitas Saya'),
                    const SizedBox(height: 8),
                    _MenuCard(
                      children: [
                        _MenuTile(
                          icon: Icons.menu_book_rounded,
                          iconBg: AppColors.primaryLight,
                          iconColor: AppColors.primary,
                          title: 'Catatan Check-in',
                          onTap: () => context.push('/profile/journal'),
                        ),
                        const _RowDivider(),
                        _MenuTile(
                          icon: Icons.emoji_events_rounded,
                          iconBg: AppColors.accent1Light,
                          iconColor: AppColors.accent1,
                          title: 'Riwayat Pencapaian',
                          onTap: () => context.push('/profile/achievements'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ═══════════════════════════════════════════════════════════
              // SECTION 3 — Lainnya
              // ═══════════════════════════════════════════════════════════
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel(label: 'Lainnya'),
                    const SizedBox(height: 8),
                    _MenuCard(
                      children: [
                        _MenuTile(
                          icon: Icons.info_rounded,
                          iconBg: AppColors.accent2Light,
                          iconColor: AppColors.accent2,
                          title: 'Tentang Aplikasi',
                          onTap: () => _showAboutDialog(context),
                        ),
                        const _RowDivider(),
                        _MenuTile(
                          icon: Icons.logout_rounded,
                          iconBg: AppColors.error.withValues(alpha: 0.12),
                          iconColor: AppColors.error,
                          title: 'Keluar',
                          textColor: AppColors.error,
                          onTap: () => _confirmLogout(context, ref),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        // Kategori 1: skeleton header avatar + teks + baris menu
        loading: () => const ProfileSkeleton(),
        error: (err, stack) => Center(child: Text('Terjadi kesalahan: $err')),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _MenuTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconBg = isDark ? iconColor.withValues(alpha: 0.15) : iconBg;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: effectiveIconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 66),
      child: const Divider(height: 1),
    );
  }
}

class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      -size.height * 0.6,
      size.width,
      size.height,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconBg = isDark ? iconColor.withValues(alpha: 0.15) : iconBg;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: effectiveIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          HabitFlowToggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ThemeDropdownRow extends StatelessWidget {
  final ThemeMode currentMode;
  final ValueChanged<String> onChanged;

  const _ThemeDropdownRow({required this.currentMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Color getIconColor() {
      if (currentMode == ThemeMode.dark) return AppColors.primary;
      if (currentMode == ThemeMode.light) return AppColors.accent1;
      return AppColors.textSecondary;
    }

    Color getIconBg() {
      if (currentMode == ThemeMode.dark) return AppColors.primaryLight;
      if (currentMode == ThemeMode.light) return AppColors.accent1Light;
      return AppColors.textSecondary.withValues(alpha: 0.15);
    }

    IconData getIcon() {
      if (currentMode == ThemeMode.dark) return Icons.dark_mode_rounded;
      if (currentMode == ThemeMode.light) return Icons.light_mode_rounded;
      return Icons.brightness_auto_rounded;
    }

    String getSubtitle() {
      if (currentMode == ThemeMode.dark) return 'Mode gelap aktif';
      if (currentMode == ThemeMode.light) return 'Mode terang aktif';
      return 'Mengikuti sistem';
    }

    String getValue() {
      if (currentMode == ThemeMode.dark) return 'dark';
      if (currentMode == ThemeMode.light) return 'light';
      return 'system';
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = getIconColor();
    final iconBg = getIconBg();
    final effectiveIconBg = isDark ? iconColor.withValues(alpha: 0.15) : iconBg;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: effectiveIconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(getIcon(), color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tampilan',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  getSubtitle(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(100),
            ),
            child: DropdownButton<String>(
              value: getValue(),
              icon: const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 20),
              ),
              elevation: 4,
              isDense: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: Theme.of(context).colorScheme.surface,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              underline: const SizedBox(),
              alignment: Alignment.center,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              items: const [
                DropdownMenuItem(value: 'light', child: Text('Terang')),
                DropdownMenuItem(value: 'dark', child: Text('Gelap')),
                DropdownMenuItem(value: 'system', child: Text('Sistem')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Baris fitur kecil yang dipakai di dalam dialog Tentang Aplikasi.
class _AboutFeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _AboutFeatureRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 17),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
