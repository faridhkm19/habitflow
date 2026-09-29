import 'package:flutter/material.dart';
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
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              _buildSegment('daily', 'Tiap Hari', context),
              _buildSegment('specific_days', 'Pilih Hari', context),
              _buildSegment('x_per_week', 'X Seminggu', context),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Specific Days Selector
        if (frequencyType == 'specific_days')
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayButton('mon', 'SEN', context),
              _buildDayButton('tue', 'SEL', context),
              _buildDayButton('wed', 'RAB', context),
              _buildDayButton('thu', 'KAM', context),
              _buildDayButton('fri', 'JUM', context),
              _buildDayButton('sat', 'SAB', context),
              _buildDayButton('sun', 'MIN', context),
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
                context: context,
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
                context: context,
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDayButton(String dayKey, String label, BuildContext context) {
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
            color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: isSelected ? null : Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
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

  Widget _buildStepperButton({required IconData icon, VoidCallback? onPressed, required BuildContext context}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
      highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: onPressed != null ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surface,
          shape: BoxShape.circle,
          border: Border.all(color: onPressed != null ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Icon(
          icon,
          color: onPressed != null ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }

  Widget _buildSegment(String value, String label, BuildContext context) {
    final isSelected = frequencyType == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTypeChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
