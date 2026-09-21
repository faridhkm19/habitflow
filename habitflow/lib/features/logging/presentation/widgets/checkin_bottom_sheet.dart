import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Bottom sheet check-in: mood picker + input catatan singkat
/// Muncul saat user menandai habit selesai
class CheckinBottomSheet extends StatefulWidget {
  final String habitName;
  final Future<void> Function(String? mood, String? note) onSave;

  const CheckinBottomSheet({
    super.key,
    required this.habitName,
    required this.onSave,
  });

  @override
  State<CheckinBottomSheet> createState() => _CheckinBottomSheetState();

  /// Tampilkan bottom sheet, return setelah user selesai
  static Future<void> show(
    BuildContext context, {
    required String habitName,
    required Future<void> Function(String? mood, String? note) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CheckinBottomSheet(habitName: habitName, onSave: onSave),
    );
  }
}

class _CheckinBottomSheetState extends State<CheckinBottomSheet> {
  String? _selectedMood;
  final _noteController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();
    try {
      await widget.onSave(_selectedMood, note);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
        Navigator.of(context).pop();
      }
    }
  }

  void _handleSkip() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Handle bar ─────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Header ─────────────────────────────────────────────────────────
          Text(
            widget.habitName,
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'Bagaimana perasaanmu setelah ini?',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // ── Mood Picker ────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MoodOption(
                emoji: '😊',
                label: 'Semangat',
                value: 'good',
                selected: _selectedMood == 'good',
                onTap: () => setState(() =>
                    _selectedMood = _selectedMood == 'good' ? null : 'good'),
              ),
              _MoodOption(
                emoji: '😐',
                label: 'Biasa',
                value: 'neutral',
                selected: _selectedMood == 'neutral',
                onTap: () => setState(() =>
                    _selectedMood = _selectedMood == 'neutral' ? null : 'neutral'),
              ),
              _MoodOption(
                emoji: '😔',
                label: 'Lelah',
                value: 'tired',
                selected: _selectedMood == 'tired',
                onTap: () => setState(() =>
                    _selectedMood = _selectedMood == 'tired' ? null : 'tired'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Input Catatan ──────────────────────────────────────────────────
          Text(
            'Catatan singkat (opsional)',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _noteController,
            maxLength: 100,
            maxLines: 2,
            inputFormatters: [LengthLimitingTextInputFormatter(100)],
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Tambahkan catatan...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
              counterStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 20),

          // ── Action Buttons ─────────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _isSaving ? null : _handleSkip,
                  child: Text(
                    'Lewati',
                    style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _isSaving ? null : _handleSave,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.textOnPrimary,
                          ),
                        )
                      : Text(
                          'Simpan',
                          style: AppTextStyles.button.copyWith(
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Satu opsi mood di picker
class _MoodOption extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  const _MoodOption({
    required this.emoji,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2.0 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
