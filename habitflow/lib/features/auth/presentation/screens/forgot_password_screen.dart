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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _newPasswordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authNotifierProvider.notifier)
        .updatePassword(newPassword: _newPasswordCtrl.text);
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
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil diubah! Silakan login kembali.'),
            backgroundColor: Color(0xFF8FC94A),
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authNotifierProvider.notifier).reset();
        context.go('/login');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.md),

                Text(
                  'Ubah Password',
                  style: AppTextStyles.h1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Masukkan password baru untuk akunmu.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Info box — menjelaskan keterbatasan simulasi tanpa terkesan error
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Fitur ini hanya tersedia jika kamu sedang dalam sesi aktif.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                AppTextField(
                  label: 'Password Baru',
                  hint: 'Min. 6 karakter',
                  controller: _newPasswordCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.lock_rounded,
                  validator: validatePassword,
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Konfirmasi Password Baru',
                  hint: 'Ulangi password baru',
                  controller: _confirmCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) =>
                      validateConfirmPassword(_newPasswordCtrl.text, v),
                  onFieldSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: AppSpacing.xl),

                AppButton(
                  label: 'Ubah Password',
                  onPressed: authState.isLoading ? null : _submit,
                  isLoading: authState.isLoading,
                ),

                const SizedBox(height: AppSpacing.lg),

                Center(
                  child: AppButton(
                    label: 'Kembali ke Login',
                    variant: AppButtonVariant.text,
                    isFullWidth: false,
                    onPressed: () => context.go('/login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
