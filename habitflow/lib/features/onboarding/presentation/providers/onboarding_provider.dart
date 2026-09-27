import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../habits/domain/entities/habit_entity.dart';
import '../../../habits/presentation/providers/habit_provider.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/habit_templates.dart';

class OnboardingState {
  final int currentStep;
  final HabitTemplate? selectedTemplate;
  final Set<String> includedHabitNames;
  final bool isLoading;
  final String? errorMessage;

  OnboardingState({
    this.currentStep = 0,
    this.selectedTemplate,
    this.includedHabitNames = const {},
    this.isLoading = false,
    this.errorMessage,
  });

  OnboardingState copyWith({
    int? currentStep,
    HabitTemplate? selectedTemplate,
    Set<String>? includedHabitNames,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedTemplate: selectedTemplate ?? this.selectedTemplate,
      includedHabitNames: includedHabitNames ?? this.includedHabitNames,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;

  OnboardingNotifier(this._ref) : super(OnboardingState());

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void selectTemplate(HabitTemplate template) {
    // Saat template dipilih, otomatis checklist semua habit di dalamnya
    final allNames = template.habits.map((h) => h.name).toSet();
    state = state.copyWith(
      selectedTemplate: template,
      includedHabitNames: allNames,
    );
  }

  void toggleHabitInclusion(String habitName) {
    final newSet = Set<String>.from(state.includedHabitNames);
    if (newSet.contains(habitName)) {
      newSet.remove(habitName);
    } else {
      newSet.add(habitName);
    }
    state = state.copyWith(includedHabitNames: newSet);
  }

  Future<bool> saveHabits() async {
    if (state.selectedTemplate == null || state.includedHabitNames.isEmpty) {
      state = state.copyWith(errorMessage: 'Pilih minimal 1 habit untuk memulai');
      return false;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = _ref.read(authStateProvider).value;
      if (user == null) {
        state = state.copyWith(isLoading: false, errorMessage: 'User tidak ditemukan');
        return false;
      }

      // Filter template habits berdasarkan yang di-checklist
      final habitsToSave = state.selectedTemplate!.habits
          .where((h) => state.includedHabitNames.contains(h.name))
          .map((h) {
        return HabitEntity(
          id: '', // Diabaikan, Supabase pakai uuid_generate_v4() atau dari model 
                  // Wait, Entity butuh ID. Di Model id diambil dari json. 
                  // Saat create, Supabase mengabaikan ID jika kosong (atau kita harus skip).
                  // Karena kita Entity mewajibkan id non-null, kita kasih kosong.
          userId: user.id,
          name: h.name,
          iconName: h.iconName,
          colorHex: h.colorHex,
          category: h.category,
          frequencyType: h.frequencyType,
          frequencyValue: h.frequencyValue,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }).toList();

      final createBatch = _ref.read(createBatchHabitsUseCaseProvider);
      final result = await createBatch(habitsToSave);

      if (result.isOk) {
        state = state.copyWith(isLoading: false);
        // Tandai user sebagai sudah onboarding agar route guard tidak
        // pernah mengarahkan ke guided setup lagi di masa mendatang.
        await markUserAsOnboarded(_ref);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.failureOrNull?.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Terjadi kesalahan sistem',
      );
      return false;
    }
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref);
});
