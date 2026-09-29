import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authNotifierProvider.notifier)
        .updatePasswordWithVerification(
          currentPassword: _oldPasswordCtrl.text,
          newPassword: _newPasswordCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen(authNotifierProvider, (_, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authNotifierProvider.notifier).reset();
      }
      if (next.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil diubah!'),
            backgroundColor: Color(0xFF8FC94A), // color.secondary.dark
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(authNotifierProvider.notifier).reset();
        context.pop();
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: const Text('Ubah Password'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
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
                Text(
                  'Pastikan password baru kamu kuat dan mudah diingat.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                AppTextField(
                  label: 'Password Saat Ini',
                  hint: 'Masukkan password lama',
                  controller: _oldPasswordCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Password Baru',
                  hint: 'Min. 8 karakter',
                  controller: _newPasswordCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.lock_rounded,
                  validator: (v) {
                    final newPassError = validateNewPassword(v);
                    if (newPassError != null) return newPassError;

                    if (v == _oldPasswordCtrl.text) {
                      return 'Password baru tidak boleh sama dengan password lama';
                    }
                    return null;
                  },
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
