import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Avatar profil pengguna.
/// - Jika [avatarUrl] tersedia → tampilkan foto via NetworkImage.
/// - Jika belum ada foto → tampilkan inisial huruf pertama [displayName]
///   di atas background color.primary, teks putih.
/// - Badge kamera selalu tampil di pojok kanan bawah untuk aksi ganti foto.
class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String displayName;
  final VoidCallback onTap;
  final bool isLoading;

  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.displayName,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = avatarUrl != null && avatarUrl!.isNotEmpty;
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Lingkaran utama
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Foto: pakai gambar; fallback: bg primary solid
              color: hasPhoto ? null : AppColors.primary,
              image: hasPhoto
                  ? DecorationImage(
                      image: NetworkImage(avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
              // Cincin putih tipis agar avatar terlihat naik dari background
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: hasPhoto
                ? null
                : Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
          ),

          // Loading spinner overlay
          if (isLoading)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.35),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Badge kamera di pojok kanan bawah
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
