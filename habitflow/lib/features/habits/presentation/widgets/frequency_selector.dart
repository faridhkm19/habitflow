import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class FrequencySelector extends StatelessWidget {
  final String frequencyType;
  final ValueChanged<String> onTypeChanged;
  
  final List<String> selectedDays;
  final ValueChanged<List<String>> onDaysChanged;
  
  final int timesPerWeek;
  final ValueChanged<int> onTimesPerWeekChanged;

  const FrequencySelector({
    super.key,
    required this.frequencyType,
    required this.onTypeChanged,
    required this.selectedDays,
    required this.onDaysChanged,
    required this.timesPerWeek,
    required this.onTimesPerWeekChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Type Selector (Custom Segmented Control)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _buildSegment('daily', 'Tiap Hari'),
              _buildSegment('specific_days', 'Pilih Hari'),
              _buildSegment('x_per_week', 'X Seminggu'),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Specific Days Selector
        if (frequencyType == 'specific_days')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayButton('mon', 'SEN'),
              _buildDayButton('tue', 'SEL'),
              _buildDayButton('wed', 'RAB'),
              _buildDayButton('thu', 'KAM'),
              _buildDayButton('fri', 'JUM'),
              _buildDayButton('sat', 'SAB'),
              _buildDayButton('sun', 'MIN'),
            ],
          ),

        // X per Week Selector
        if (frequencyType == 'x_per_week')
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStepperButton(
                icon: Icons.remove,
                onPressed: timesPerWeek > 1 ? () => onTimesPerWeekChanged(timesPerWeek - 1) : null,
              ),
              const SizedBox(width: 24),
              Text(
                '$timesPerWeek',
                style: AppTextStyles.numberLarge,
              ),
              const SizedBox(width: 24),
              _buildStepperButton(
                icon: Icons.add,
                onPressed: timesPerWeek < 6 ? () => onTimesPerWeekChanged(timesPerWeek + 1) : null,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDayButton(String dayKey, String label) {
    final isSelected = selectedDays.contains(dayKey);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final newList = List<String>.from(selectedDays);
          if (isSelected) {
            newList.remove(dayKey);
          } else {
            newList.add(dayKey);
          }
          onDaysChanged(newList);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
            border: isSelected ? null : Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperButton({required IconData icon, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: onPressed != null ? AppColors.primaryLight : AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: onPressed != null ? AppColors.primary : AppColors.border),
        ),
        child: Icon(
          icon,
          color: onPressed != null ? AppColors.primary : AppColors.border,
        ),
      ),
    );
  }

  Widget _buildSegment(String value, String label) {
    final isSelected = frequencyType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
