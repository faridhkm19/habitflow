import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habit_provider.dart';
import '../widgets/frequency_selector.dart';
import '../widgets/icon_color_picker.dart';

class EditHabitScreen extends ConsumerStatefulWidget {
  final HabitEntity habit;
  
  const EditHabitScreen({super.key, required this.habit});

  @override
  ConsumerState<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends ConsumerState<EditHabitScreen> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  late String _selectedIcon;
  late Color _selectedColor;
  late String _selectedCategory;
  
  late String _frequencyType;
  late List<String> _selectedDays;
  late int _timesPerWeek;

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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _selectedIcon = widget.habit.iconName;
    _selectedColor = ColorExtension.fromHex(widget.habit.colorHex);
    _selectedCategory = widget.habit.category;
    
    _frequencyType = widget.habit.frequencyType;
    _selectedDays = [];
    _timesPerWeek = 3;
    
    if (_frequencyType == 'specific_days' && widget.habit.frequencyValue['days'] != null) {
      _selectedDays = List<String>.from(widget.habit.frequencyValue['days']);
    } else if (_frequencyType == 'x_per_week' && widget.habit.frequencyValue['times'] != null) {
      _timesPerWeek = widget.habit.frequencyValue['times'] as int;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateHabit() async {
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
    final success = await ref.read(habitsProvider.notifier).updateHabit(
      id: widget.habit.id,
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
        title: Text('Edit Habit', style: AppTextStyles.h2),
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
                label: 'Nama Habit',
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
                label: 'Simpan Perubahan',
                isLoading: _isLoading,
                onPressed: _updateHabit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
