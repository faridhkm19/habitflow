import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ChangeEmailScreen extends ConsumerStatefulWidget {
  const ChangeEmailScreen({super.key});

  @override
  ConsumerState<ChangeEmailScreen> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends ConsumerState<ChangeEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newEmailCtrl = TextEditingController();
  final _confirmEmailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _newEmailCtrl.dispose();
    _confirmEmailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authNotifierProvider.notifier)
        .updateEmail(
          newEmail: _newEmailCtrl.text,
          currentPassword: _passwordCtrl.text,
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
            content: Text('Email berhasil diubah!'),
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
        title: const Text('Ubah Email'),
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
                  'Masukkan email baru yang ingin digunakan untuk akun ini.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                AppTextField(
                  label: 'Email Baru',
                  hint: 'Masukkan email baru',
                  controller: _newEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_outlined,
                  validator: validateEmail,
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Konfirmasi Email Baru',
                  hint: 'Ketik ulang email baru',
                  controller: _confirmEmailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_rounded,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Konfirmasi email tidak boleh kosong';
                    }
                    if (v != _newEmailCtrl.text) {
                      return 'Email tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                AppTextField(
                  label: 'Password Saat Ini',
                  hint: 'Verifikasi identitas',
                  controller: _passwordCtrl,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),

                const SizedBox(height: AppSpacing.xl),

                AppButton(
                  label: 'Ubah Email',
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
