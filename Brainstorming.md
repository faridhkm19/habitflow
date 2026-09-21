# HabitFlow — Phase 1: Brainstorming & Detailing
### Daily Habit & Wellness Tracker · Mobile + Web · Flutter + Supabase

---

## Daftar Isi

1. [Visi & Misi Produk](#1-visi--misi-produk)
2. [Problem Statement](#2-problem-statement)
3. [Target User & User Persona](#3-target-user--user-persona)
4. [User Journey Map](#4-user-journey-map)
5. [Competitive Analysis](#5-competitive-analysis)
6. [Differentiator & Positioning](#6-differentiator--positioning)
7. [Feature List & Prioritization](#7-feature-list--prioritization)
8. [Screen Inventory](#8-screen-inventory)
9. [Data Model Overview](#9-data-model-overview)
10. [Platform Strategy: Mobile vs Web](#10-platform-strategy-mobile-vs-web)
11. [Learning Value per Fitur](#11-learning-value-per-fitur)

---

## 1. Visi & Misi Produk

### Visi
Menjadi aplikasi wellness harian yang terasa seperti **teman, bukan pengawas** — yang membantu pengguna membangun kebiasaan sehat secara konsisten, tanpa rasa bersalah ketika gagal, dan dengan pemahaman mendalam tentang pola hidup mereka sendiri.

### Misi
Menyediakan pengalaman tracking kebiasaan yang **rendah friksi, penuh konteks, dan ramah secara psikologis** — baik di mobile untuk interaksi harian, maupun di web untuk refleksi dan analisis mendalam.

### Tagline
> *"Build better days, one habit at a time."*

---

## 2. Problem Statement

### Konteks Masalah

Riset pasar menunjukkan fakta yang keras: **80% pengguna meninggalkan habit tracker dalam 3 hari pertama**, dan sekitar **49% berhenti dalam 60 hari**. Masalahnya bukan kurangnya motivasi pengguna — masalahnya adalah desain aplikasi yang secara tidak sadar menciptakan hambatan psikologis.

Tiga akar masalah yang paling dominan ditemukan dalam riset:

### Problem #1 — The Streak Trap
Hampir semua aplikasi habit tracker menggunakan sistem streak yang reset ke nol ketika satu hari terlewat. Fenomena ini secara psikologi dikenal sebagai *"the what-the-hell effect"* — ketika seseorang melewatkan satu hari setelah 30 hari konsisten, otaknya berpikir *"sudah rusak, apa gunanya melanjutkan"* dan berhenti sepenuhnya. Aplikasi yang dirancang seperti ini secara tidak sengaja membangun **infrastruktur rasa malu**, bukan infrastruktur keberhasilan.

### Problem #2 — Complexity vs Adoption
Banyak pengguna membuat terlalu banyak kebiasaan sekaligus saat pertama kali membuka aplikasi, kemudian merasa kewalahan dalam beberapa hari. Aplikasi yang tidak membatasi atau memandu proses ini justru memperparah masalah. Cognitive overload adalah salah satu faktor utama drop-off di minggu pertama.

### Problem #3 — No Meaningful Reflection
Mayoritas aplikasi menyediakan data tracking, tetapi tidak membantu pengguna *memahami* data tersebut. Pengguna melihat angka dan grafik, namun tidak tahu apa artinya atau apa yang harus dilakukan selanjutnya. Tanpa insight bermakna, tracking terasa seperti beban administratif, bukan alat pertumbuhan.

### Problem #4 — Platform Fragmentation
Hampir tidak ada habit tracker yang memberikan pengalaman yang setara di mobile dan web. Mayoritas hanya mobile-only, sehingga pengguna yang ingin mereview progress dari laptop tidak bisa melakukannya dengan nyaman.

### How Might We?
- *"Bagaimana kita bisa merancang sistem streaks yang memotivasi tanpa menghukum?"*
- *"Bagaimana kita membantu pengguna memulai dengan benar tanpa overwhelm?"*
- *"Bagaimana kita mengubah data tracking menjadi insight yang bermakna?"*
- *"Bagaimana kita memberikan pengalaman yang koheren di mobile dan web?"*

---

## 3. Target User & User Persona

### Segmen Target Utama

- **Usia:** 18–35 tahun
- **Demografi:** Mahasiswa, young professional, pekerja remote
- **Karakteristik:** Melek teknologi, sudah pernah mencoba habit tracker sebelumnya, familiar dengan konsep self-improvement
- **Konteks:** Mencari cara untuk membangun rutinitas sehat di tengah jadwal yang tidak teratur

---

### Persona 1 — Rafi, 22 Tahun · Mahasiswa Tingkat Akhir

**Background**
Rafi adalah mahasiswa teknik semester 7 yang sedang mengerjakan skripsi. Ia sangat ingin membangun kebiasaan produktif: olahraga pagi, baca buku 30 menit, dan tidur sebelum jam 12 malam. Sudah pernah mencoba Habitica dan Streaks, keduanya ditinggalkan dalam seminggu.

**Goals**
- Membangun rutinitas harian yang konsisten di tengah jadwal kuliah yang fluktuatif
- Melihat apakah kebiasaannya berkembang dari waktu ke waktu
- Tidak merasa bersalah ketika satu hari ketinggalan karena deadline

**Pain Points**
- Ketika streak rusak, ia merasa tidak ada gunanya melanjutkan
- Membuat terlalu banyak kebiasaan di hari pertama, kewalahan di hari ketiga
- Tidak tahu apakah progress yang ia buat "normal" atau terlalu lambat
- Sering buka laptop untuk kuliah — ingin bisa cek progress dari browser juga

**Behavior Pattern**
- Paling aktif di pagi hari (setelah bangun tidur) dan malam hari (sebelum tidur)
- Sering skip satu hari karena praktikum atau deadline, bukan karena malas
- Suka melihat data visual — lebih mudah memproses grafik daripada angka

**Kutipan Representatif**
> "Aku mau aplikasi yang ngerti bahwa hidup itu nggak selalu sempurna. Kalau aku skip satu hari, aku nggak mau langsung merasa kayak udah gagal total."

---

### Persona 2 — Dinda, 27 Tahun · Marketing Executive

**Background**
Dinda bekerja di startup Jakarta dengan jam kerja yang tidak menentu. Ia sangat sadar bahwa gaya hidupnya kurang sehat — jarang olahraga, sering makan tidak teratur, tidur larut. Ia ingin mengubah ini tapi tidak punya waktu untuk sistem yang rumit.

**Goals**
- Tracking kebiasaan kesehatan dasar: minum air, tidur cukup, jalan kaki
- Melihat apakah dirinya lebih baik minggu ini dibanding minggu lalu
- Sesuatu yang bisa digunakan dalam 30 detik saat sedang sibuk

**Pain Points**
- Aplikasi yang terlalu banyak fitur terasa membebani, bukan membantu
- Notifikasi yang terlalu sering terasa seperti diomeli
- Tidak punya waktu untuk setup yang panjang dan rumit
- Ingin bisa review progress dari laptop saat meeting selesai

**Behavior Pattern**
- Menggunakan aplikasi secara impulsif — saat teringat, bukan terjadwal
- Sangat menghargai kecepatan: interaksi harus selesai dalam < 10 detik
- Tertarik pada summary mingguan yang bisa dilihat sekilas

**Kutipan Representatif**
> "Aku nggak butuh aplikasi yang kayak life coach. Aku cuma butuh sesuatu yang kasih tahu aku apakah minggu ini lebih baik dari minggu lalu."

---

### Persona 3 — Bagas, 30 Tahun · Software Developer (WFH)

**Background**
Bagas bekerja remote sebagai developer. Tantangannya adalah batas antara kerja dan istirahat yang sangat kabur. Ia ingin melacak kebiasaan yang mendukung work-life balance: tidak kerja setelah jam 7 malam, meditasi 10 menit, dan olahraga 3x seminggu.

**Goals**
- Membangun struktur harian yang jelas meski bekerja dari rumah
- Melihat tren kebiasaannya dalam jangka panjang (bulanan, bukan hanya mingguan)
- Menggunakan web version sebagai primary — mobile sebagai backup

**Pain Points**
- Hampir semua habit tracker hanya bagus di mobile, web version-nya minimal
- Ingin bisa export data atau lihat laporan yang detail
- Merasa terlalu "dikontrol" oleh notifikasi — lebih suka memeriksa secara mandiri

**Behavior Pattern**
- Konsisten dan analitis — ia akan benar-benar menggunakan fitur analytics
- Lebih sering membuka dari laptop dibanding HP saat jam kerja
- Tertarik pada customization: ingin atur frekuensi (tidak harus daily), warna, dan ikon sendiri

**Kutipan Representatif**
> "Aku mau lihat pola kebiasaanku dalam 3 bulan terakhir, bukan cuma minggu ini. Dan aku mau bisa lakukannya dari laptop dengan nyaman."

---

## 4. User Journey Map

### Journey: First-Time User (Rafi)

```
[Discover]
Rafi melihat rekomendasi di Twitter/Instagram
→ Tertarik dengan tampilan bersih, download
→ Harapan: aplikasi yang tidak bikin overwhelm

[Onboarding]
Splash screen → Pilih 1-3 kebiasaan awal (guided)
→ Set reminder opsional → Langsung ke home
→ Harapan: cepat, tidak terlalu banyak pertanyaan

[Day 1 — First Check-in]
Buka aplikasi pagi hari
→ Tap untuk complete habit → Animasi feedback menyenangkan
→ Lihat progress ring hari ini
→ Harapan: terasa rewarding, tidak terasa seperti kewajiban

[Week 1 — Building Momentum]
Cek setiap hari → Mulai lihat streak building
→ Mungkin miss 1 hari → Lihat bahwa progress tidak hilang total
→ Harapan: aplikasi tidak "menghukum" saat miss 1 hari

[Week 2-3 — Reflection]
Buka tab Statistics → Lihat heatmap minggu pertama
→ Sadar pola: selalu gagal di hari Rabu (banyak kuliah)
→ Adjust: ubah reminder untuk Rabu
→ Harapan: dapat insight yang berguna, bukan sekadar angka

[Month 1 — Habit Review]
Lihat monthly report → Satu habit sudah 80% konsisten
→ Coba tambah habit baru
→ Harapan: merasa tumbuh, ingin terus menggunakan
```

---

### Journey: Power User via Web (Bagas)

```
[Daily Mobile Check-in]
Buka app pagi → Complete habits yang sudah dilakukan
→ Cepat, selesai dalam 30 detik

[Evening Web Session]
Buka habitflow.app dari laptop
→ Login dengan akun yang sama → Data langsung tersync
→ Buka Statistics page → Lihat tren 30 hari terakhir
→ Filter per kategori habit
→ Export PDF summary mingguan

[Monthly Review]
Buka Calendar View → Identifikasi pola miss
→ Edit beberapa habit (ubah frekuensi, warna)
→ Archive habit yang sudah jadi "autopilot"
```

---

## 5. Competitive Analysis

### Matriks Kompetitor

| Fitur | HabitFlow | Habitify | Streaks | Loop | Daylio |
|---|---|---|---|---|---|
| **Cross-platform (Mobile + Web)** | ✅ | ✅ | ❌ (Apple only) | ❌ (Android only) | ❌ |
| **Flexible Streak (bukan hard reset)** | ✅ | ❌ | ❌ | ✅ | ❌ |
| **Heatmap Analytics** | ✅ | ✅ | ❌ | ✅ | ❌ |
| **Onboarding Guided (pilih habit)** | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Habit Notes/Journal per log** | ✅ | ❌ | ❌ | ❌ | ✅ |
| **Frekuensi Custom (non-daily)** | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Free tier yang useful** | ✅ | ❌ (sangat terbatas) | ❌ (paid) | ✅ | ✅ |
| **Dark Mode** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Export Data** | ✅ | ✅ (premium) | ❌ | ✅ | ✅ (premium) |

### Gap Utama yang HabitFlow Isi

1. **Flexible Streak System** — tidak ada reset total, ada "grace period" dan streak recovery
2. **Guided First-Time Onboarding** — template habit berdasarkan goals, bukan field kosong
3. **Unified Mobile + Web** — bukan sekadar web wrapper, tapi experience yang dioptimasi per platform
4. **Habit Notes** — setiap log bisa ditambahkan catatan singkat untuk konteks

---

## 6. Differentiator & Positioning

### Tiga Differentiator Utama

**1. Forgiving Streak System — "Progress, Not Perfection"**
Mengganti hard-reset streak dengan sistem yang lebih manusiawi:
- **Consistency Score** (0-100%) menggantikan streak tunggal — dihitung dari persentase completion dalam 30 hari terakhir
- **Streak tetap ada** tapi ditemani "Total Check-ins" sehingga satu hari miss tidak menghapus semua konteks
- **"Get Back on Track"** — notifikasi yang supportif, bukan accusatory, ketika pengguna kembali setelah absen

**2. Contextual Logging — Habit Bukan Sekadar Centang**
Setiap check-in bisa disertai:
- Mood indicator opsional (3 pilihan: 😊 Good · 😐 Neutral · 😔 Tired)
- Catatan singkat (max 100 karakter)
- Data ini membuat analytics menjadi jauh lebih bermakna — bukan hanya "berapa kali", tapi "bagaimana rasanya"

**3. Web-First Analytics, Mobile-First Action**
- **Mobile:** Optimized untuk quick check-in, reminder, dan snapshot hari ini
- **Web:** Optimized untuk deep review — heatmap, tren bulanan, filter per kategori, export PDF

---

## 7. Feature List & Prioritization

### Framework: MoSCoW

---

### 🔴 MUST HAVE — MVP Core

#### M1 · Authentication
- Register dengan email & password (email bersifat simulasi, tidak wajib email asli, karena murni untuk keperluan latihan)
- Login dengan email & password
- Forgot password (reset lewat form dalam aplikasi, tanpa pengiriman email verifikasi sungguhan)
- Session management (auto-login)
- Google Sign-In tidak digunakan, untuk menyederhanakan scope pembelajaran

#### M2 · Habit Management
- Buat habit baru: nama, ikon (dari preset), warna, kategori
- Edit habit yang sudah ada
- Delete / Archive habit
- Set frekuensi: Daily / Specific days (Sen-Min) / X times per week
- Set target waktu opsional (pagi / siang / malam)

#### M3 · Daily Check-in
- Home screen: daftar habit hari ini
- Tap untuk mark complete / uncomplete
- Animasi micro-interaction saat complete
- Progress ring harian (berapa persen habit selesai hari ini)
- Quick note opsional saat check-in (max 100 karakter)

#### M4 · Streak & Consistency Tracking
- Streak counter per habit (hari berturut-turut)
- Consistency Score per habit (% completion 30 hari terakhir)
- Total check-ins all-time per habit
- "Longest Streak" record per habit

#### M5 · Basic Statistics
- Weekly view: completion per hari (bar chart)
- Heatmap tahunan (GitHub-style) per habit
- Habit detail stats: streak, consistency score, total check-ins

#### M6 · Responsive Layout
- Mobile layout: bottom navigation, card-based
- Web/tablet layout: sidebar navigation, wider content area
- Adaptive breakpoint: < 600px (mobile) / ≥ 600px (web/tablet)

---

### 🟡 SHOULD HAVE — Phase 2

#### S1 · Habit Categories & Filtering
- Category tags: Health, Learning, Mindfulness, Productivity, Social, Custom
- Filter habits di home berdasarkan kategori
- Filter statistics berdasarkan kategori

#### S2 · Smart Reminders
- Set reminder time per habit
- Custom reminder message
- Snooze dari notifikasi
- "Gentle comeback" notifikasi setelah 2 hari tidak buka app

#### S3 · Mood Tracking per Log
- Pilih mood saat check-in: Good / Neutral / Tired
- Mood history di statistics
- Korelasi mood vs completion rate (visualisasi sederhana)

#### S4 · Monthly Overview
- Calendar view bulanan per habit (warna per hari berdasarkan completion)
- Monthly summary: habit terbaik, habit yang perlu perhatian
- Perbandingan bulan ini vs bulan lalu

#### S5 · Habit Templates
- Template preset saat onboarding: "Morning Routine", "Healthy Lifestyle", "Study Focus", dll
- Setiap template berisi 3-5 habit yang sudah dikonfigurasi

---

### 🟢 COULD HAVE — Phase 3

#### C1 · Web Dashboard Enhanced
- Overview semua habit dalam satu grid
- Date range selector untuk statistics (7 / 30 / 90 hari / custom)
- Filter dan sort habits

#### C2 · Export & Report
- Export PDF: weekly/monthly report dengan chart
- Export CSV: raw data semua log

#### C3 · Profile & Personalization
- Upload foto profil
- Ganti nama display
- Pilih tema warna aplikasi (3-5 pilihan preset)
- Dark mode / Light mode toggle

#### C4 · Habit Journal
- Tampilan kalender yang menampilkan semua note dari check-in
- Searchable notes

#### C5 · Gamification Ringan
- Badge/achievement untuk milestone: "First 7 Days", "30-Day Warrior", dll
- Total points system sederhana (bukan RPG, lebih subtle)

---

### ⚪ WON'T HAVE (untuk sekarang)

- Social features / sharing ke publik
- AI coaching atau rekomendasi
- Integrasi dengan Apple Health / Google Fit
- Fitur komunitas / challenge dengan pengguna lain
- Subscription / monetization system
- Widget home screen (bisa jadi C6 di masa depan)

---

## 8. Screen Inventory

### Mobile Screens

```
AUTH FLOW
├── Splash Screen
├── Onboarding 1 — Value Proposition ("What is HabitFlow")
├── Onboarding 2 — How It Works
├── Onboarding 3 — Get Started (CTA)
├── Login Screen
├── Register Screen
├── Forgot Password Screen
└── Guided Setup — Pick Your First Habits (post-register)

MAIN APP (Bottom Navigation: Home · Habits · Stats · Profile)
├── HOME
│   ├── Home Screen (daily check-in list + progress ring)
│   └── Check-in Bottom Sheet (note + mood, opsional)
│
├── HABITS
│   ├── Habits List Screen (semua habit, grouped by category)
│   ├── Add Habit Screen
│   ├── Edit Habit Screen
│   └── Habit Detail Screen (streak, stats, history log)
│
├── STATISTICS
│   ├── Statistics Overview Screen
│   ├── Heatmap View (per habit)
│   └── Monthly Calendar View
│
└── PROFILE
    ├── Profile Screen
    ├── Edit Profile Screen
    ├── Settings Screen (notifikasi, tema, dll)
    └── About Screen
```

### Web Screens (Adaptive dari Mobile)

```
WEB LAYOUT (Sidebar Navigation)
├── Dashboard / Home (equivalent of mobile home, wider layout)
├── My Habits (grid view, lebih lebar)
├── Statistics (lebih detail, date range picker, semua chart sekaligus)
├── Profile & Settings
└── Public: Landing Page (marketing page, pre-login)
```

---

## 9. Data Model Overview

*(Detail lengkap akan ada di Phase 3: Technical Architecture)*

### Entitas Utama

```
users
├── id (uuid)
├── email
├── display_name
├── avatar_url
├── created_at
└── updated_at

habits
├── id (uuid)
├── user_id (FK → users)
├── name
├── icon_name
├── color_hex
├── category
├── frequency_type (daily / specific_days / x_per_week)
├── frequency_value (json: misal ["Mon","Wed","Fri"] atau {times: 3})
├── reminder_time (nullable)
├── reminder_message (nullable)
├── is_archived (boolean)
├── created_at
└── updated_at

habit_logs
├── id (uuid)
├── habit_id (FK → habits)
├── user_id (FK → users)
├── log_date (date)
├── is_completed (boolean)
├── mood (nullable: 'good' | 'neutral' | 'tired')
├── note (nullable, max 100 chars)
└── created_at

categories (enum / lookup table)
├── health
├── learning
├── mindfulness
├── productivity
├── social
└── custom
```

### Relasi
- 1 User → banyak Habits
- 1 Habit → banyak Habit Logs
- 1 Habit Log → 1 Habit, 1 User, 1 Tanggal

---

## 10. Platform Strategy: Mobile vs Web

### Prinsip Dasar

> **Mobile adalah tempat aksi. Web adalah tempat refleksi.**

Dua platform ini tidak harus identik — mereka harus **komplementer**. Pengguna akan secara natural bergeser antar platform berdasarkan konteks:

| Konteks | Platform | Aktivitas |
|---|---|---|
| Pagi hari, baru bangun | Mobile | Check-in habit, lihat hari ini |
| Di bus / commute | Mobile | Quick check kebiasaan kemarin |
| Malam di laptop | Web | Review progress minggu ini |
| Akhir bulan | Web | Baca monthly summary, export PDF |

### Adaptive Layout Strategy (Flutter)

```dart
// Breakpoint: < 600px = mobile layout, ≥ 600px = web layout
// Implementasi dengan LayoutBuilder atau MediaQuery

Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  return width < 600 
    ? MobileLayout(child: content)
    : WebLayout(child: content);  // Sidebar navigation
}
```

### Perbedaan Layout per Platform

**Mobile Layout:**
- Bottom navigation bar (4 tabs)
- Full-screen scrollable lists
- Bottom sheet untuk aksi sekunder
- FAB (Floating Action Button) untuk tambah habit

**Web Layout:**
- Left sidebar navigation (persistent)
- Multi-column grid untuk habits
- Semua statistics dalam satu halaman (tidak perlu scroll ke detail lain)
- Top navigation bar dengan user avatar

---

## 11. Learning Value per Fitur

Ini adalah tabel penting yang menunjukkan **apa yang akan kamu pelajari** dari setiap fitur yang dibangun — karena tujuan utama project ini adalah pembelajaran arsitektur dan best practice.

| Fitur | Konsep Flutter yang Dipelajari | Konsep Backend yang Dipelajari |
|---|---|---|
| **Auth (Email/Password)** | Navigation/routing, Form validation, Provider/Riverpod basics | Supabase Auth, JWT session, RLS berbasis `auth.uid()` |
| **Habit CRUD** | Stateful widgets, Form fields, Custom icon picker | Supabase insert/update/delete, RLS policy |
| **Daily Check-in** | Gesture detection, Animated widgets, State update | Supabase upsert, date filtering query |
| **Streak Counter** | Business logic di domain layer, Use cases | PostgreSQL functions / view, date arithmetic |
| **Heatmap Chart** | Custom painter / fl_chart, Complex widget composition | Aggregation query, date grouping |
| **Responsive Layout** | LayoutBuilder, MediaQuery, Adaptive widgets | — |
| **Local Notifications** | flutter_local_notifications, Platform channels | — |
| **Dark Mode** | ThemeData, ThemeProvider, Material 3 | — |
| **Web Dashboard** | go_router (URL-based navigation), Web-specific widgets | — |
| **Export PDF** | pdf package, File system access | Supabase Storage (upload file) |
| **Image Upload (Avatar)** | image_picker, File handling | Supabase Storage bucket |

### Arsitektur yang Akan Dikuasai

Melalui project ini, kamu akan mempraktikkan:

```
Clean Architecture (Feature-First)
├── Presentation Layer → Widget, Screen, Provider (Riverpod)
├── Domain Layer      → Entity, Use Case, Repository Interface
└── Data Layer        → Repository Implementation, Data Source, Model

State Management
└── Riverpod 2.x (AsyncNotifier, StateNotifier, Provider)

Navigation
└── go_router (declarative routing, deep linking, web URL support)

Dependency Injection
└── get_it (service locator)

Error Handling
└── Either pattern (dartz) atau Result type custom

Testing (opsional, bisa ditambahkan)
└── Unit test untuk Use Cases
└── Widget test untuk Screens
```

---

## Ringkasan Eksekutif Phase 1

| Aspek | Detail |
|---|---|
| **Nama Aplikasi** | HabitFlow |
| **Tagline** | Build better days, one habit at a time |
| **Platform** | Mobile (iOS + Android) + Web |
| **Stack** | Flutter (Dart) + Supabase (PostgreSQL) |
| **State Management** | Riverpod 2.x |
| **Navigation** | go_router |
| **Target User** | 18-35 tahun, mahasiswa & young professional |
| **Core Problem Solved** | Streak trap, cognitive overload, no meaningful reflection, platform gap |
| **Key Differentiator** | Forgiving streak system + contextual logging + web-first analytics |
| **MVP Scope** | Auth + Habit CRUD + Daily Check-in + Basic Stats + Responsive Layout |
| **Phase 2 Scope** | Categories + Reminders + Mood + Monthly View + Templates |
| **Phase 3 Scope** | Web Dashboard + Export + Profile + Gamification |

---

## Langkah Selanjutnya

Dengan Phase 1 selesai, roadmap berikutnya adalah:

```
✅ Phase 1 — Brainstorming & Detailing  [SELESAI]

🔜 Phase 2 — PRD (Product Requirements Document)
   → User stories per fitur
   → Acceptance criteria
   → Error states & edge cases
   → Non-functional requirements (performance, security)

🏗️ Phase 3 — Technical Architecture
   → ERD lengkap
   → Folder structure detail
   → Supabase schema + RLS policies
   → State management pattern per fitur
   → API/query design

🎨 Phase 4 — Design System
   → Color palette (light + dark)
   → Typography scale
   → Component library
   → Responsive breakpoints
   → Icon set

💬 Phase 5 — Prompt Engineering Plan
   → Master system prompt
   → Per-feature prompts
   → Iteration & refinement strategy
```

---

*Dokumen ini adalah output Phase 1: Brainstorming & Detailing untuk project HabitFlow.*
*Dibuat sebagai bagian dari AI Agent Learning Project dengan stack Flutter + Supabase.*
