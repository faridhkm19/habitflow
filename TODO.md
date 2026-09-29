# TODO.md — HabitFlow Development Roadmap

Dokumen ini adalah panduan task pengembangan HabitFlow secara menyeluruh, disusun bertahap sesuai prioritas pengerjaan. Dokumen ini bersifat hidup, artinya boleh berubah, ditambah, atau disesuaikan di tengah jalan tanpa perlu merombak seluruh isinya. Fungsi utamanya adalah memberi gambaran jelas ke developer maupun AI Agent mengenai apa yang sudah dikerjakan, apa yang sedang dikerjakan, dan apa yang masih menunggu di depan.

Status yang dipakai di setiap task:
- [✔] Selesai
- [ ] Belum dikerjakan
- [~] Sedang dikerjakan / sebagian selesai

Referensi utama yang wajib dibaca sebelum mengerjakan task apapun di bawah ini tetap empat dokumen berikut, yang menjadi sumber kebenaran atas seluruh keputusan produk dan teknis:

1. HabitFlow_Phase1_Brainstorming.md
2. HabitFlow_Phase2_PRD_v3.md
3. HabitFlow_Phase3_Technical_Architecture.md
4. HabitFlow_Phase4_Design_System.md

---

## Bagian 1 — Fondasi Proyek

### 1.1 Project Initialization & Core Setup
- [✔] Inisialisasi project Flutter dengan dukungan Android dan iOS (web support telah dihapus permanen, fokus ke mobile saja)
- [✔] Pasang seluruh dependency inti (riverpod, go_router, supabase_flutter, fl_chart, dan lainnya)
- [✔] Bentuk folder structure sesuai Technical Architecture (feature-first, Clean Architecture)
- [✔] Buat file konfigurasi Supabase dengan kredensial project
- [✔] Verifikasi project berjalan tanpa error di Android/iOS

### 1.2 Design Tokens & Theme Implementation
- [✔] Buat color token sesuai Design System (brand color, neutral, semantic)
- [✔] Buat typography token dengan font Poppins
- [✔] Buat spacing, border radius, dan elevation token
- [✔] Susun ThemeData lengkap untuk light mode
- [✔] Buat shared widget dasar (button, text field, card, loading indicator)
- [✔] Verifikasi seluruh komponen lewat halaman showcase sementara

---

## Bagian 2 — Autentikasi dan Onboarding

### 2.1 Authentication Module
- [✔] Setup Supabase Auth dengan metode email dan password saja
- [✔] Nonaktifkan fitur konfirmasi email di pengaturan Supabase, mengingat email yang didaftarkan bersifat simulasi
- [✔] Buat halaman Sign Up dengan validasi form dasar
- [✔] Buat halaman Login dengan validasi form dasar
- [✔] Buat halaman Forgot Password (reset lewat form dalam aplikasi, tanpa pengiriman email verifikasi sungguhan)
- [✔] Implementasikan session persistence agar pengguna tidak perlu login ulang setiap membuka aplikasi
- [✔] Implementasikan route guard, pengguna yang belum login diarahkan ke halaman login, dan sebaliknya

### 2.2 Guided Onboarding (First-Time Setup)
- [✔] Buat layar welcome step setelah pendaftaran berhasil
- [✔] Buat layar pemilihan template habit (Rutinitas Pagi, Gaya Hidup Sehat, Fokus Belajar, Mindfulness)
- [✔] Buat layar kustomisasi habit dari template yang dipilih
- [✔] Buat layar konfirmasi penyelesaian onboarding
- [✔] Simpan habit hasil onboarding ke Supabase dan arahkan pengguna ke halaman Home

---

## Bagian 3 — Fitur Inti (Core MVP)

### 3.1 Database Schema & Row Level Security
- [✔] Buat tabel profiles di Supabase sesuai skema Technical Architecture
- [✔] Buat tabel habits sesuai skema Technical Architecture
- [✔] Buat tabel habit_logs sesuai skema Technical Architecture
- [✔] Terapkan Row Level Security di seluruh tabel berbasis auth.uid()
- [✔] Buat trigger otomatis untuk membuat baris profiles baru setiap ada pengguna baru mendaftar

### 3.2 Habits Management Module
- [✔] Buat halaman Habits List dengan pengelompokan berdasarkan kategori
- [✔] Buat halaman Add Habit dengan icon picker, color picker, dan pengaturan frekuensi
- [✔] Buat halaman Edit Habit
- [✔] Implementasikan fungsi arsip habit
- [✔] Implementasikan fungsi hapus habit dengan dialog konfirmasi
- [✔] Buat halaman Habit Detail yang menampilkan streak, consistency score, dan riwayat log

### 3.3 Daily Check-in & Home Screen
- [✔] Buat halaman Home dengan daftar habit aktif hari ini
- [✔] Implementasikan interaksi check-in satu tap beserta pembatalannya
- [✔] Buat progress ring harian
- [✔] Buat bottom sheet untuk input mood dan catatan singkat saat check-in
- [✔] Implementasikan optimistic update agar interaksi terasa instan

### 3.4 Streak & Consistency Engine
- [✔] Implementasikan use case perhitungan streak dengan mempertimbangkan frekuensi habit
- [✔] Implementasikan grace period agar streak tidak langsung direset saat satu hari terlewat
- [✔] Implementasikan perhitungan consistency score berbasis 30 hari terakhir
- [✔] Implementasikan pencatatan longest streak per habit
- [✔] Uji perhitungan dengan berbagai skenario (harian, hari tertentu, X kali seminggu)

### 3.5 Statistics Dasar
- [✔] Buat bar chart completion mingguan
- [✔] Buat heatmap tahunan per habit
- [✔] Susun query agregasi yang efisien dari tabel habit_logs

### 3.6 Layout Mobile
- [✔] Buat mobile scaffold dengan bottom navigation
- [✔] Sesuaikan komponen inti untuk tampilan mobile (single column layout)

> **Catatan:** Web scaffold (sidebar navigation), adaptive scaffold (breakpoint logic), dan seluruh layout responsif berbasis breakpoint 600px telah dihapus permanen. Folder `web/`, `web_scaffold.dart`, dan `adaptive_scaffold.dart` sudah tidak ada di project.

---

## Bagian 4 — Fitur Pelengkap (Enhancement)

### 4.1 Kategori dan Filter
- [✔] Tambahkan filter kategori di halaman Habits List
- [✔] Tambahkan filter kategori di halaman Statistics

### 4.2 Smart Reminder
- [ ] Implementasikan reminder lokal per habit menggunakan flutter_local_notifications
- [ ] Implementasikan notifikasi pengingat kembali setelah pengguna lama tidak membuka aplikasi

> **Catatan:** Fitur ini ditunda ke tahap akhir pengembangan. Seluruh logika dan UI terkait notifikasi telah dibersihkan dari codebase untuk menghindari tumpukan kode percobaan. Akan diimplementasikan ulang secara bersih setelah seluruh fitur inti dan penyempurnaan selesai.

### 4.3 Mood Tracking
- [✔] Tampilkan riwayat mood pada halaman Habit Detail

### 4.4 Calendar View
- [✔] Buat section baru di halaman Detail Habit: kalender bulanan dengan penanda warna berdasarkan status penyelesaian

### 4.5 Habit Templates
- [✔] Perbaiki logika onboarding: tambahkan kolom `is_onboarded` ke tabel `profiles`, route guard kini membaca flag ini (bukan jumlah habit) sehingga user lama tidak pernah diarahkan ke onboarding lagi
- [✔] Perluas jumlah template yang tersedia: tambahkan 3 template baru (Olahraga & Kebugaran, Pengembangan Diri, Istirahat & Relaksasi) dengan variasi frekuensi daily / x_per_week / specific_days

---

## Bagian 5 — Penyempurnaan (Refinement)

### 5.1 ~~Web Dashboard Lanjutan~~ *(Dibatalkan)*

> **Keputusan permanen:** Web support telah dihapus dari project HabitFlow. Seluruh kode, konfigurasi, dan logika web (folder `web/`, `web_scaffold.dart`, `adaptive_scaffold.dart`, breakpoint logic) telah dibersihkan. Fokus aplikasi dipersempit ke mobile saja (Android dan iOS). Task-task di seksi ini tidak akan dikerjakan.

### 5.2 ~~Export Data~~ *(Dibatalkan)*

> **Keputusan permanen:** Fitur export PDF dan CSV telah dibatalkan secara permanen. Seluruh dependency (`pdf`, `printing`) dan konfigurasi terkait telah dibersihkan secara tuntas. Task-task di seksi ini tidak akan dikerjakan.


### 5.3 Profil dan Personalisasi
- [✔] Buat halaman Profile dengan ringkasan statistik pengguna
- [✔] Buat beberapa pengaturan di halaman Profile, seperti Keamanan Akun, Tampilan, Notifikasi, Catatan Check-in, Riwayat Pencapaian
- [✔] Implementasikan unggah foto profil ke Supabase Storage
- [✔] Implementasikan fitur ubah email dan ubah password dengan verifikasi sesi aktif

### 5.4 Habit Journal
- [✔] Buat halaman yang menampilkan seluruh catatan check-in secara terpusat
- [✔] Tambahkan fitur pencarian catatan

### 5.5 Achievement Sederhana
- [✔] Rancang beberapa milestone pencapaian (misalnya tujuh hari pertama, tiga puluh hari konsisten)
- [✔] Tampilkan badge pencapaian di halaman Profile

---

## Bagian 6 — Dark Mode

- [✔] Definisikan ulang seluruh color token untuk mode gelap
- [✔] Susun ThemeData terpisah untuk dark mode
- [✔] Implementasikan toggle perpindahan tema di halaman Settings
- [✔] Pastikan seluruh komponen (termasuk heatmap dan chart) tetap terbaca baik di dark mode

---

## Bagian 7 — Kualitas dan Kesiapan Rilis

### 7.1 Testing
- [ ] Tulis unit test untuk use case krusial, terutama perhitungan streak dan consistency score
- [ ] Tulis widget test untuk komponen yang sering dipakai ulang
- [ ] Uji aplikasi pada berbagai ukuran layar (mobile kecil, tablet, desktop lebar)

### 7.2 Performa
- [ ] Audit waktu muat halaman Home
- [ ] Optimasi query statistik agar tetap cepat meski data log bertambah banyak
- [ ] Terapkan lazy loading pada daftar yang panjang

### 7.3 Penyempurnaan Umum
- [ ] Tinjau ulang seluruh copy/teks aplikasi agar konsisten dengan nada suportif yang ditetapkan di PRD
- [ ] Tinjau ulang aksesibilitas dasar (kontras warna, ukuran target sentuh)
- [ ] Perbaiki bug dan inkonsistensi visual yang ditemukan selama proses pengujian menyeluruh

### 7.4 Persiapan Rilis Umum
- [ ] Siapkan ikon aplikasi dan splash screen final
- [ ] Siapkan deskripsi dan aset untuk publikasi (jika akan dipublikasikan ke Play Store, App Store, atau hosting web)
- [ ] Tinjau kembali pengaturan keamanan Supabase sebelum aplikasi digunakan lebih luas, termasuk mempertimbangkan mengaktifkan kembali konfirmasi email apabila aplikasi tidak lagi murni untuk latihan

---

## Catatan Penting untuk Developer dan AI Agent

Dokumen ini disusun berurutan berdasarkan prioritas, namun tidak kaku. Apabila di tengah jalan muncul kebutuhan fitur baru, perubahan struktur, atau penyesuaian scope, silakan tambahkan, ubah, atau hapus task yang relevan di dokumen ini, tanpa perlu menyusun ulang keseluruhan dokumen dari awal.

Setiap kali sebuah task besar (satu bagian atau satu sub bagian) selesai dikerjakan, checklist di atas sebaiknya diperbarui agar dokumen ini tetap mencerminkan kondisi proyek yang sebenarnya.

Task di Bagian 1 sampai Bagian 3 adalah fondasi dan fitur inti yang membentuk MVP, dan sebaiknya diselesaikan secara berurutan karena banyak task yang saling bergantung satu sama lain, misalnya Habits Management membutuhkan skema database yang sudah dibuat di Database Schema, dan Statistics membutuhkan data dari Streak Engine yang sudah berjalan.

Task di Bagian 4 ke bawah bersifat lebih fleksibel urutannya, dan boleh dikerjakan sesuai kebutuhan atau ketertarikan, selama fondasi di Bagian 1 sampai Bagian 3 sudah solid.

---

*Dokumen TODO.md ini menjadi panduan progres pengembangan HabitFlow, mengacu pada Phase 1 Brainstorming, Phase 2 PRD, Phase 3 Technical Architecture, dan Phase 4 Design System.*
