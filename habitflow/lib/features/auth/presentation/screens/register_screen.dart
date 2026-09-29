import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authNotifierProvider.notifier)
        .signUp(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authNotifierProvider.notifier).reset();
      }
      // Navigasi ke onboarding setelah register berhasil
      if (next.isSuccess) {
        context.go('/onboarding/guided-setup');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xxl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),

                const AuthHeader(),

                const SizedBox(height: AppSpacing.xxl),

                Text(
                  'Buat Akun',
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Mulai perjalanan kebiasaan barumu',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                AppTextField(
                  label: 'Email',
                  hint: 'contoh@email.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_rounded,
                  validator: validateEmail,
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Password',
                  hint: 'Min. 6 karakter',
                  controller: _passwordCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.lock_rounded,
                  validator: validatePassword,
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Konfirmasi Password',
                  hint: 'Ulangi password',
                  controller: _confirmCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) =>
                      validateConfirmPassword(_passwordCtrl.text, v),
                  onFieldSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: AppSpacing.xl),

                AppButton(
                  label: 'Daftar',
                  onPressed: authState.isLoading ? null : _submit,
                  isLoading: authState.isLoading,
                ),

                const SizedBox(height: AppSpacing.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Masuk',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
