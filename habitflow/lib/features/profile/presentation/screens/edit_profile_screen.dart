import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileDataProvider).valueOrNull;
    if (profile != null) {
      _nameController.text = profile.displayName ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await ref.read(editProfileNotifierProvider.notifier).updateDisplayName(name);

    if (mounted) {
      final error = ref.read(editProfileNotifierProvider).error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      } else {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editProfileNotifierProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Tampilan',
              ),
              enabled: !isLoading,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isLoading ? null : _save,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
