import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull;
    final email = user?.email ?? '-';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keamanan Akun'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _NavRow(
                  icon: Icons.email_rounded,
                  iconBg: AppColors.primaryLight,
                  iconColor: AppColors.primary,
                  title: 'Ubah Email',
                  subtitle: email,
                  isFirst: true,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur ubah email segera hadir')),
                    );
                  },
                ),
                const _RowDivider(),
                _NavRow(
                  icon: Icons.lock_rounded,
                  iconBg: AppColors.secondaryLight,
                  iconColor: AppColors.secondaryDark,
                  title: 'Ubah Password',
                  subtitle: 'Perbarui kata sandi akun',
                  isLast: true,
                  onTap: () => context.push('/forgot-password'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _NavRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(12) : Radius.zero,
          bottom: isLast ? const Radius.circular(12) : Radius.zero,
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 66),
      child: Divider(height: 1, color: AppColors.border),
    );
  }
}
