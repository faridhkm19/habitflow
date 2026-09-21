# Product Requirements Document (PRD)
## HabitFlow — Daily Habit and Wellness Tracker

---

## 1. Development Tools

Aplikasi HabitFlow dibangun menggunakan Flutter dengan Dart sebagai bahasa pemrograman utama, karena mampu menghasilkan satu codebase yang berjalan di mobile (Android, iOS) sekaligus web. Untuk backend, dipilih Supabase dengan PostgreSQL, mengingat struktur data aplikasi ini bersifat relasional (user memiliki banyak habit, satu habit memiliki banyak log harian) sehingga lebih tepat ditangani dengan SQL dibanding database berbasis dokumen.

**Frontend & State Management**
- Flutter (Dart) — cross-platform mobile & web
- Riverpod 2.x — state management, termasuk state asynchronous
- go_router — navigasi dengan dukungan URL routing untuk web
- fl_chart — visualisasi heatmap, grafik, progress ring
- flutter_local_notifications — reminder habit harian
- image_picker — upload foto profil
- pdf — generate laporan yang bisa diunduh

**Backend & Database**
- Supabase (PostgreSQL) — database utama
- Supabase Auth — autentikasi email/password (Sign Up & Login). Google Sign-In tidak digunakan pada proyek ini, murni untuk menyederhanakan scope pembelajaran
- Email yang didaftarkan bersifat simulasi (tidak harus email asli), sehingga fitur "Confirm email" dinonaktifkan di pengaturan Supabase Auth agar akun langsung aktif setelah sign up
- Supabase Storage — penyimpanan avatar dan file export
- Row Level Security (RLS) — memastikan data antar user terisolasi

**Pendukung Lain**
Figma digunakan untuk wireframe dan mockup sebelum masuk implementasi, sementara seluruh dokumentasi proyek disimpan dalam format markdown. Proses pengembangan dilakukan secara iteratif per fitur, mengingat proyek ini juga menjadi latihan penyusunan prompt untuk AI Agent.

---

## 2. Problem Statement

Riset menunjukkan bahwa 80% pengguna meninggalkan habit tracker dalam 3 hari pertama, dan hampir 49% berhenti dalam 60 hari. Masalahnya bukan pada motivasi pengguna, melainkan pada cara aplikasi tersebut dirancang, yang secara tidak sadar menciptakan hambatan psikologis bagi penggunanya.

Ada empat pola masalah utama yang ditemukan dari riset:

**Streak Trap.** Kebanyakan aplikasi mereset streak ke nol begitu satu hari terlewat. Ini memicu *"what-the-hell effect"*, kondisi di mana pengguna merasa progres yang sudah dibangun sia-sia, lalu memilih berhenti total alih-alih melanjutkan.

**Cognitive Overload di Awal.** Pengguna baru cenderung membuat terlalu banyak habit sekaligus di hari pertama, lalu kewalahan dan drop off dalam beberapa hari karena tidak ada panduan onboarding yang tepat.

**Data Tanpa Insight.** Sebagian besar aplikasi hanya menampilkan angka dan grafik tanpa konteks yang berarti, sehingga tracking terasa seperti tugas administratif, bukan alat bantu memahami pola hidup.

**Fragmentasi Platform.** Mayoritas habit tracker hanya tersedia di satu platform, menyulitkan pengguna yang ingin meninjau progres dari layar yang lebih besar seperti laptop.

Inti masalah yang perlu dijawab HabitFlow adalah bagaimana membangun sistem yang tetap suportif ketika pengguna tidak konsisten, memandu onboarding tanpa membuat overwhelm, menyajikan data yang bermakna, dan hadir setara baik di mobile maupun web.

---

## 3. Goals

### Tujuan Produk
Tujuan utama dari sisi produk adalah menghadirkan sistem tracking yang lebih manusiawi dan tidak menghukum ketidakkonsistenan pengguna. Beberapa target konkret yang ingin dicapai:

- Menggantikan streak biner dengan Consistency Score berbasis persentase completion
- Menyederhanakan onboarding lewat panduan pemilihan habit awal, bukan form kosong
- Menyajikan data lewat visualisasi yang actionable: heatmap, grafik mingguan, ringkasan bulanan
- Menghadirkan pengalaman mobile dan web yang saling melengkapi, bukan duplikasi satu sama lain

### Tujuan Pembelajaran
Karena proyek ini juga menjadi sarana latihan pengembangan aplikasi dengan AI Agent, ada beberapa hal teknis yang ingin dikuasai sepanjang prosesnya:

- Penerapan Clean Architecture pada proyek Flutter (presentation, domain, data layer)
- Perancangan schema Supabase yang relasional, termasuk RLS dan query agregasi
- Teknik responsive dan adaptive layout antara mobile dan web
- Kemampuan menyusun prompt yang efektif untuk membangun fitur secara bertahap

---

## 4. Target Users

Target utama HabitFlow berada di rentang usia 18-35 tahun, mencakup mahasiswa, pekerja muda, dan remote worker yang sudah familiar dengan teknologi dan pernah mencoba habit tracker sebelumnya namun berhenti di tengah jalan.

Berdasarkan riset persona, target pengguna terbagi menjadi tiga kelompok dengan kebutuhan yang sedikit berbeda:

| Persona | Konteks | Kebutuhan Utama |
|---|---|---|
| Rafi, 22 tahun (Mahasiswa) | Jadwal kuliah fluktuatif, sering ada deadline | Sistem fleksibel, tidak menghukum saat absen |
| Dinda, 27 tahun (Marketing) | Jam kerja padat, waktu terbatas | Interaksi cepat, selesai dalam hitungan detik |
| Bagas, 30 tahun (Developer WFH) | Kerja dari rumah, analitis | Web experience yang kuat, analytics mendalam |

Meski kebutuhan spesifiknya berbeda, ketiga kelompok ini sama-sama menginginkan proses pencatatan yang simpel, tidak ada rasa "gagal total" hanya karena absen satu hari, serta kejelasan progres yang mereka capai.

---

## 5. User Stories

User story disusun mengikuti format *sebagai pengguna, saya ingin melakukan sesuatu, agar saya mendapat manfaat tertentu*, dikelompokkan per modul fitur.

**Autentikasi & Onboarding**
- Mendaftar dengan email dan password (email bersifat simulasi, tidak wajib email asli, karena tidak ada proses verifikasi sungguhan)
- Login kembali dengan mudah menggunakan email dan password yang sudah didaftarkan
- Reset password lewat form khusus tanpa proses verifikasi email sungguhan
- Dipandu memilih habit awal setelah pendaftaran, agar tidak bingung harus mulai dari mana

**Manajemen Kebiasaan**
- Membuat habit baru dengan nama, ikon, warna, kategori, dan frekuensi
- Mengatur frekuensi secara fleksibel: harian, hari tertentu, atau X kali seminggu
- Mengedit detail habit yang sudah dibuat sebelumnya
- Mengarsipkan habit tanpa kehilangan riwayat, atau menghapusnya secara permanen

**Pencatatan Harian**
- Menandai habit selesai dengan satu tap, termasuk membatalkannya jika salah tandai
- Melihat progress ring harian sebagai indikator visual sederhana
- Menambahkan mood dan catatan singkat saat check-in untuk konteks tambahan

**Streak & Konsistensi**
- Melihat streak berturut-turut sebagai motivasi
- Sistem tidak langsung reset ke nol saat satu hari terlewat
- Melihat consistency score sebagai gambaran yang lebih adil dari performa keseluruhan

**Statistik & Analitik**
- Melihat heatmap tahunan untuk mengenali pola sepanjang tahun
- Melihat grafik completion mingguan untuk progres jangka pendek
- Melihat ringkasan bulanan: habit mana yang paling konsisten dan mana yang perlu perhatian

**Lintas Platform**
- Membuka HabitFlow lewat browser dengan layout yang nyaman digunakan
- Data yang dicatat di mobile langsung tersinkron ketika dibuka lewat web

**Pengaturan & Personalisasi**
- Mengatur waktu reminder per habit
- Mengganti tampilan antara dark mode dan light mode
- Mengubah foto profil dan nama tampilan

---

## 6. Functional Requirements

Kebutuhan fungsional berikut merupakan turunan teknis dari user stories di atas, dikelompokkan per modul.

**FR-1 Autentikasi**
Sistem menyediakan form register (email, password, konfirmasi) dengan validasi format dasar, tanpa mewajibkan email asli karena bersifat simulasi untuk kebutuhan latihan (fitur "Confirm email" dinonaktifkan di pengaturan Supabase Auth agar akun langsung aktif). Sistem juga menyediakan form login dengan email/password yang sudah didaftarkan, auto-login lewat session persistence, reset password lewat form khusus di dalam aplikasi (tanpa pengiriman email verifikasi sungguhan), dan redirect ke guided setup setelah register berhasil. Google Sign-In tidak termasuk dalam scope proyek ini.

**FR-2 Manajemen Kebiasaan**
Sistem menyediakan form create habit (nama, ikon, warna, kategori, frekuensi) dengan tiga tipe frekuensi (daily, specific days, X times per week), reminder time opsional, kemampuan edit seluruh detail, archive tanpa kehilangan riwayat, dan delete permanen dengan konfirmasi.

**FR-3 Pencatatan Harian**
Sistem menampilkan daftar habit aktif hari ini di home screen, mendukung toggle complete/uncomplete satu tap, menampilkan progress indicator harian, serta menyediakan input mood dan note opsional (maksimal 100 karakter) yang tersimpan per tanggal.

**FR-4 Streak & Konsistensi**
Sistem menghitung streak berturut-turut dengan mempertimbangkan hari non-jadwal, menghitung Consistency Score dari persentase completion 30 hari terakhir, menyimpan Longest Streak record, dan menerapkan grace period sebelum streak benar-benar direset.

**FR-5 Statistik**
Sistem menyediakan heatmap tahunan per habit, bar chart completion mingguan, ringkasan bulanan (habit terbaik dan terlemah), serta calendar view bulanan per habit.

**FR-6 Layout Responsif**
Sistem mendeteksi lebar layar dengan breakpoint 600px, menampilkan bottom navigation dengan 4 menu pada mobile, dan sidebar navigation persistent pada web.

**FR-7 Profil & Pengaturan**
Sistem menyediakan edit profil (foto, nama) dengan upload avatar via Supabase Storage, toggle dark/light mode yang persistent, dan toggle notifikasi on/off.

---

## 7. Non-Functional Requirements

Selain fitur utama, ada beberapa kebutuhan kualitas yang perlu dipenuhi agar aplikasi berjalan baik secara teknis:

**Performa.** Home screen harus termuat dalam waktu kurang dari 2 detik, proses check-in harus memberi respons visual instan lewat pendekatan optimistic update, dan query statistik dirancang efisien mengingat data log akan terus bertambah seiring waktu.

**Keamanan.** RLS wajib aktif di seluruh tabel Supabase, seluruh komunikasi terenkripsi, dan password sepenuhnya di-hash melalui Supabase Auth tanpa disimpan dalam bentuk teks biasa.

**Keandalan.** Data yang sudah dimuat sebelumnya tetap tampil meski koneksi terputus sementara, dengan sinkronisasi yang konsisten antara mobile dan web setiap kali data dimuat ulang.

**Kegunaan.** Antarmuka dirancang sesederhana mungkin agar tidak membebani secara kognitif, proses onboarding tidak lebih dari 2 menit, dan kontras warna tetap nyaman baik di light maupun dark mode.

**Skalabilitas.** Struktur database dan arsitektur kode (Clean Architecture) dirancang agar penambahan fitur di masa depan tidak memerlukan perombakan besar pada sistem yang sudah berjalan.

**Kompatibilitas.** Mobile app berjalan baik di Android dan iOS dengan versi yang masih didukung resmi, sementara web app kompatibel dengan browser modern seperti Chrome, Firefox, Safari, dan Edge.

**Pemeliharaan.** Kode disusun dengan penamaan konsisten dan terdokumentasi, mengingat proyek ini juga berfungsi sebagai bahan pembelajaran yang mungkin ditinjau ulang di kemudian hari.

---

## 8. Scope

Pengembangan HabitFlow dibagi menjadi tiga tahap berdasarkan prioritas yang sudah ditentukan pada tahap brainstorming.

**Tahap 1 — Core MVP.** Fokus pada fondasi utama: autentikasi lengkap, CRUD habit, daily check-in satu tap, perhitungan streak dan consistency score, statistik dasar (grafik mingguan dan heatmap tahunan), serta layout responsif antara mobile dan web.

**Tahap 2 — Enhancement.** Menambahkan fitur pelengkap setelah fondasi selesai: kategori habit beserta filter, smart reminder termasuk notifikasi comeback, mood tracking per log, calendar view bulanan, dan habit template saat onboarding.

**Tahap 3 — Refinement.** Menyempurnakan pengalaman web dan menambah fitur pelengkap lain: dashboard web dengan filter date range, export PDF/CSV, personalisasi profil (avatar, tema warna), habit journal, dan sistem achievement sederhana.

---

## 9. Out of Scope

Beberapa hal secara sengaja tidak dikerjakan dalam proyek ini, baik karena di luar tujuan pembelajaran maupun di luar batasan waktu dan sumber daya yang tersedia:

- **Integrasi AI API** dalam bentuk apapun, karena fokus proyek adalah pembelajaran murni Flutter dan Supabase
- **Fitur sosial** seperti share publik, follow antar pengguna, atau challenge, karena menambah kompleksitas backend di luar tujuan utama
- **Integrasi Apple Health / Google Fit**, karena membutuhkan proses sertifikasi dan konfigurasi tambahan
- **Sistem monetisasi atau subscription**, karena proyek ini murni untuk latihan pribadi, bukan produk komersial
- **Home screen widget**, karena butuh konfigurasi native berbeda di setiap platform, bisa dipertimbangkan di pengembangan lanjutan
- **Automated testing menyeluruh**, bukan prioritas di tahap awal meski tetap terbuka ditambahkan bertahap untuk logic krusial seperti streak
- **Dukungan multi-bahasa**, aplikasi dikembangkan dengan satu bahasa dulu di tahap awal

---

*Dokumen PRD Phase 2 — HabitFlow, menjadi acuan utama pengembangan pada tahap-tahap selanjutnya.*
