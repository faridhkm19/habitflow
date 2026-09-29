import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../providers/onboarding_provider.dart';
import '../widgets/step_welcome.dart';
import '../widgets/step_template.dart';
import '../widgets/step_customize.dart';
import '../widgets/step_completion.dart';

class GuidedSetupScreen extends ConsumerStatefulWidget {
  const GuidedSetupScreen({super.key});

  @override
  ConsumerState<GuidedSetupScreen> createState() => _GuidedSetupScreenState();
}

class _GuidedSetupScreenState extends ConsumerState<GuidedSetupScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextStep(int currentStep) {
    if (currentStep < 3) {
      ref.read(onboardingProvider.notifier).nextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPreviousStep(int currentStep) {
    if (currentStep > 0) {
      ref.read(onboardingProvider.notifier).previousStep();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: List.generate(4, (index) {
                  final isActive = index <= state.currentStep;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Konten Layar (PageView)
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // cegah swipe manual
                children: [
                  StepWelcome(onNext: () => _onNextStep(state.currentStep)),
                  StepTemplate(
                    onNext: () => _onNextStep(state.currentStep),
                    onBack: () => _onPreviousStep(state.currentStep),
                  ),
                  StepCustomize(
                    onNext: () => _onNextStep(state.currentStep),
                    onBack: () => _onPreviousStep(state.currentStep),
                  ),
                  StepCompletion(
                    onBack: () => _onPreviousStep(state.currentStep),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
