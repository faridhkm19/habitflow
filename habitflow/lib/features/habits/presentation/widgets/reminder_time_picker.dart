// lib/features/habits/presentation/widgets/reminder_time_picker.dart
//
// Widget untuk section pengingat di Add/Edit Habit screen.
// Menampilkan toggle on/off dan time picker jika reminder diaktifkan.
// Versi StatefulWidget agar state toggle sementara bisa dikelola dengan benar.

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/services/notification_service.dart';

import '../../../profile/presentation/widgets/habitflow_toggle.dart';

class ReminderTimePicker extends StatefulWidget {
  /// null  = reminder tidak aktif
  /// "HH:mm" = reminder aktif pada jam tersebut
  final String? reminderTime;

  /// Dipanggil saat nilai berubah.
  /// null = matikan reminder, "HH:mm" = aktifkan/ubah jam
  final ValueChanged<String?> onChanged;

  const ReminderTimePicker({
    super.key,
    required this.reminderTime,
    required this.onChanged,
  });

  @override
  State<ReminderTimePicker> createState() => _ReminderTimePickerState();
}

class _ReminderTimePickerState extends State<ReminderTimePicker> {
  // Flag sementara untuk mencegah double-tap saat time picker terbuka
  bool _isPickerOpen = false;

  bool get _isEnabled => widget.reminderTime != null;

  /// Meminta permission notifikasi, lalu membuka time picker.
  /// Mengembalikan string "HH:mm" jika user memilih waktu, null jika cancel.
  Future<String?> _requestPermissionAndPickTime() async {
    // Minta permission sebelum membuka time picker
    final granted = await NotificationService.instance.requestPermission();

    if (!granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Izin notifikasi diperlukan untuk mengaktifkan pengingat. '
              'Aktifkan di Pengaturan > Aplikasi > HabitFlow.',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
      return null;
    }

    return _openTimePicker();
  }

  /// Membuka time picker dan mengembalikan nilai "HH:mm" yang dipilih, atau null.
  Future<String?> _openTimePicker() async {
    if (_isPickerOpen) return null;

    final initial = _parseTime(widget.reminderTime) ?? TimeOfDay.now();

    setState(() => _isPickerOpen = true);

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (mounted) setState(() => _isPickerOpen = false);

    if (picked == null) return null;

    return '${picked.hour.toString().padLeft(2, '0')}:'
        '${picked.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null) return null;
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Toggle baris ───────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHighest
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16), // Match Profile style
            border: Border.all(
              color: isDark ? colorScheme.outline : AppColors.border,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _isEnabled
                        ? AppColors.primaryLight
                        : (isDark
                            ? colorScheme.surfaceContainerHighest
                            : AppColors.border.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications_rounded,
                    size: 18,
                    color: _isEnabled
                        ? AppColors.primary
                        : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aktifkan Pengingat',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _isEnabled
                            ? 'Notifikasi akan muncul sesuai jadwal'
                            : 'Tidak ada pengingat untuk habit ini',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                HabitFlowToggle(
                  value: _isEnabled,
                  onChanged: (val) async {
                          if (_isPickerOpen) return;
                          if (val) {
                            final time = await _requestPermissionAndPickTime();
                            if (time != null) widget.onChanged(time);
                          } else {
                            widget.onChanged(null);
                          }
                        },
                ),
              ],
            ),
          ),
        ),

        // ── Row waktu (tampil hanya jika aktif) ────────────────────────────
        if (_isEnabled) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme.surfaceContainerHighest
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? colorScheme.outline : AppColors.border,
                width: 1,
              ),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent1Light,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: AppColors.accent1,
                ),
              ),
              title: Text(
                'Waktu Pengingat',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.reminderTime ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                    size: 20,
                  ),
                ],
              ),
              onTap: () async {
                // Ubah waktu: tidak perlu minta permission lagi
                final time = await _openTimePicker();
                if (time != null) {
                  widget.onChanged(time);
                }
              },
            ),
          ),
        ],
      ],
    );
  }
}
