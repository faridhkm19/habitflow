import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
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
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo area
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.self_improvement_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'HabitFlow',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Versi 1.0.0',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '"Build better days, one habit at a time."',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Aplikasi tracking kebiasaan yang rendah friksi, penuh konteks, dan ramah secara psikologis.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
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
    final currentEmail = ref.watch(currentEmailProvider);
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
            padding: const EdgeInsets.only(bottom: 100),
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
                      currentEmail.isEmpty ? (user!.email) : currentEmail,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = AppColors.textPrimary;
    final effectiveIconBg = isDark
        ? iconColor.withValues(alpha: 0.15)
        : const Color(0xFF2B2B2B).withValues(alpha: 0.08);

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
          DropdownButton<String>(
            value: getValue(),
            icon: const Icon(Icons.arrow_drop_down_rounded),
            elevation: 16,
            borderRadius: BorderRadius.circular(12),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
            underline: const SizedBox(),
            alignment: Alignment.centerRight,
            onChanged: (String? newValue) {
              if (newValue != null) {
                onChanged(newValue);
              }
            },
            items: const [
              DropdownMenuItem(value: 'light', child: Text('Terang')),
              DropdownMenuItem(value: 'dark', child: Text('Gelap')),
              DropdownMenuItem(value: 'system', child: Text('Default')),
            ],
          ),
        ],
      ),
    );
  }
}
