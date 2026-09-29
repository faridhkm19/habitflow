import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/icon_utils.dart';

class IconColorPicker extends StatelessWidget {
  final String selectedIcon;
  final Color selectedColor;
  final ValueChanged<String> onIconChanged;
  final ValueChanged<Color> onColorChanged;

  const IconColorPicker({
    super.key,
    required this.selectedIcon,
    required this.selectedColor,
    required this.onIconChanged,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Selected Icon Preview
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: getLighterColor(selectedColor, 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              getHabitIcon(selectedIcon),
              color: selectedColor,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        Text('Pilih Warna', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        // Color Swatches
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AppColors.habitColors.map((color) {
              final isSelected = color == selectedColor;
              return GestureDetector(
                onTap: () => onColorChanged(color),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 3) : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        Text('Pilih Ikon', style: AppTextStyles.h3),
        const SizedBox(height: 12),
        // Icon Grid
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: presetHabitIcons.length,
          itemBuilder: (context, index) {
            final iconName = presetHabitIcons[index];
            final isSelected = iconName == selectedIcon;

            return GestureDetector(
              onTap: () => onIconChanged(iconName),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? getLighterColor(selectedColor, 0.15) : Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: selectedColor, width: 2) : Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                ),
                child: Icon(
                  getHabitIcon(iconName),
                  color: isSelected ? selectedColor : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
