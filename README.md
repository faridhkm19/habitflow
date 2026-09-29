# HabitFlow

HabitFlow adalah sebuah aplikasi pelacak kebiasaan harian yang dibangun menggunakan Flutter dan Supabase. Aplikasi ini dirancang untuk menyelesaikan masalah utama yang sering ditemukan pada pelacak kebiasaan konvensional, yaitu menurunnya motivasi pengguna ketika rentetan harian terputus. HabitFlow hadir dengan pendekatan yang lebih suportif melalui penggunaan skor konsistensi dibandingkan hanya mengandalkan perhitungan rentetan yang kaku.

Aplikasi ini dapat berjalan dengan baik di berbagai platform, termasuk perangkat bergerak dan peramban web, dengan memanfaatkan basis kode yang sama.

## Fitur Utama

Berdasarkan rancangan awal, aplikasi ini memiliki beberapa fitur unggulan yang dirancang untuk mendukung pembentukan kebiasaan baru:

*   **Autentikasi dan Orientasi Pengguna:** Pendaftaran dan masuk akun yang terintegrasi dengan Supabase, dilengkapi dengan panduan awal untuk membantu pengguna baru memilih kebiasaan pertama mereka.
*   **Manajemen Kebiasaan Fleksibel:** Dukungan untuk berbagai jadwal kebiasaan, mulai dari setiap hari, hari tertentu dalam seminggu, hingga jumlah target mingguan.
*   **Skor Konsistensi:** Sistem penilaian berbasis persentase penyelesaian dalam tiga puluh hari terakhir, sehingga pengguna tidak merasa gagal sepenuhnya hanya karena terlewat satu hari.
*   **Pencatatan Harian:** Penyelesaian kebiasaan harian dengan interaksi cepat, dilengkapi dengan cincin progres harian serta kemampuan mencatat suasana hati dan catatan singkat.
*   **Statistik Terperinci:** Visualisasi data melalui grafik penyelesaian mingguan dan peta panas tahunan untuk mengenali pola kebiasaan dalam jangka panjang.
*   **Tampilan Responsif:** Antarmuka yang menyesuaikan ukuran layar secara otomatis, menampilkan navigasi bawah untuk pengguna ponsel dan bilah sisi navigasi untuk pengguna web.

## Teknologi dan Arsitektur

Proyek ini dibangun menggunakan arsitektur bersih yang memisahkan lapisan presentasi, lapisan domain, dan lapisan data. Hal ini memastikan kode tetap rapi, mudah diuji, dan mudah dikembangkan di masa depan.

*   **Antarmuka Pengguna:** Flutter dan bahasa pemrograman Dart.
*   **Manajemen Status:** Riverpod 2.x untuk pengelolaan status aplikasi termasuk status asinkron.
*   **Perutean:** go_router untuk navigasi antar halaman, terutama untuk mendukung tautan perutean pada versi web.
*   **Layanan Backend:** Supabase (PostgreSQL) yang menangani autentikasi, pangkalan data, dan penyimpanan berkas. Seluruh data dilindungi menggunakan fitur keamanan tingkat baris dari Supabase.

## Status Pengembangan

Saat ini, proyek telah menyelesaikan tahapan fondasi dasar termasuk autentikasi, manajemen kebiasaan, pencatatan harian, dan mesin skor konsistensi. Terdapat beberapa daftar tugas pengembangan tingkat lanjut yang saat ini masih berstatus tertunda dan akan dikerjakan pada tahap selanjutnya:

*   **Penyempurnaan Fitur:** Penambahan filter kategori untuk kebiasaan dan statistik.
*   **Pengingat Pintar:** Notifikasi lokal untuk setiap kebiasaan dan pengingat ketika pengguna sudah lama tidak membuka aplikasi.
*   **Tampilan Tambahan:** Tampilan kalender bulanan dan halaman khusus untuk melihat riwayat suasana hati secara berkala.
*   **Fitur Lanjutan Papan Utama Web:** Penyaringan rentang tanggal untuk bagian statistik pada versi peramban web.
*   **Ekspor Data:** Kemampuan mengunduh data laporan ke dalam format dokumen PDF maupun berkas CSV.
*   **Personalisasi Pengguna:** Halaman profil dengan fitur unggah foto profil, pencapaian sederhana, dan mode gelap.
*   **Jurnal Kebiasaan:** Halaman terpusat untuk melihat seluruh catatan harian.
*   **Pengujian dan Performa:** Penulisan pengujian unit dan komponen, serta optimasi kecepatan muat dan kinerja pangkalan data.

## Catatan Khusus
*   **Ubah Email (Simulasi):** Fitur ubah email menggunakan Supabase Auth simulasi. Email yang ditampilkan di UI diperbarui secara responsif selama sesi aktif, namun tidak persisten di server Supabase Auth karena keterbatasan client SDK yang tetap mensyaratkan *email confirmation* pada *endpoint* `updateUser` (meskipun fitur *secure email change* dan *confirm email* telah dinonaktifkan di dashboard). Untuk implementasi tingkat produksi, diperlukan integrasi Supabase Edge Function menggunakan `service_role` key untuk mem-*bypass* proses verifikasi klien.
