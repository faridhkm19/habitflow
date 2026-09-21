import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/color_utils.dart';
import '../providers/habit_provider.dart';
import '../widgets/frequency_selector.dart';
import '../widgets/icon_color_picker.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  const AddHabitScreen({super.key});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedIcon = 'fitness_center';
  Color _selectedColor = AppColors.habitMint;
  String _selectedCategory = 'health';
  
  String _frequencyType = 'daily';
  List<String> _selectedDays = [];
  int _timesPerWeek = 3;

  bool _isLoading = false;

  final List<Map<String, String>> _categories = [
    {'id': 'health', 'label': 'Kesehatan'},
    {'id': 'learning', 'label': 'Belajar'},
    {'id': 'mindfulness', 'label': 'Mindful'},
    {'id': 'productivity', 'label': 'Produktivitas'},
    {'id': 'social', 'label': 'Sosial'},
    {'id': 'custom', 'label': 'Lainnya'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveHabit() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_frequencyType == 'specific_days' && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih setidaknya satu hari.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    Map<String, dynamic> freqValue = {};
    if (_frequencyType == 'specific_days') {
      freqValue = {'days': _selectedDays};
    } else if (_frequencyType == 'x_per_week') {
      freqValue = {'times': _timesPerWeek};
    }

    // Call provider
    final success = await ref.read(habitsProvider.notifier).createHabit(
      name: _nameController.text.trim(),
      iconName: _selectedIcon,
      colorHex: _selectedColor.toHex(),
      category: _selectedCategory,
      frequencyType: _frequencyType,
      frequencyValue: freqValue,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan habit.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Tambah Habit', style: AppTextStyles.h2),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Nama Habit (Mis. Lari Pagi)',
                validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              
              Text('Kategori', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat['id'];
                  return ChoiceChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    showCheckmark: false,
                    onSelected: (_) => setState(() => _selectedCategory = cat['id']!),
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              
              const Divider(color: AppColors.border),
              const SizedBox(height: 24),

              IconColorPicker(
                selectedIcon: _selectedIcon,
                selectedColor: _selectedColor,
                onIconChanged: (icon) => setState(() => _selectedIcon = icon),
                onColorChanged: (color) => setState(() => _selectedColor = color),
              ),
              
              const SizedBox(height: 24),
              const Divider(color: AppColors.border),
              const SizedBox(height: 24),

              Text('Frekuensi', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              FrequencySelector(
                frequencyType: _frequencyType,
                onTypeChanged: (type) => setState(() => _frequencyType = type),
                selectedDays: _selectedDays,
                onDaysChanged: (days) => setState(() => _selectedDays = days),
                timesPerWeek: _timesPerWeek,
                onTimesPerWeekChanged: (times) => setState(() => _timesPerWeek = times),
              ),

              const SizedBox(height: 48),
              AppButton(
                label: 'Simpan Habit',
                isLoading: _isLoading,
                onPressed: _saveHabit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
