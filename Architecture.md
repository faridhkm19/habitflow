# Technical Architecture Document
## HabitFlow — Daily Habit and Wellness Tracker

---

## Daftar Isi

1. [Overview Arsitektur](#1-overview-arsitektur)
2. [Software Architecture Pattern](#2-software-architecture-pattern)
3. [Folder Structure](#3-folder-structure)
4. [Database Design (ERD & Schema)](#4-database-design-erd--schema)
5. [Row Level Security Policy](#5-row-level-security-policy)
6. [State Management Pattern](#6-state-management-pattern)
7. [Routing & Navigation Structure](#7-routing--navigation-structure)
8. [Business Logic: Streak & Consistency Engine](#8-business-logic-streak--consistency-engine)
9. [Data Sync Strategy (Mobile ↔ Web)](#9-data-sync-strategy-mobile--web)
10. [Responsive Layout Strategy](#10-responsive-layout-strategy)
11. [Alur Kerja UI/UX dengan Google Stitch](#11-alur-kerja-uiux-dengan-google-stitch)
12. [Dependency List](#12-dependency-list)

---

## 1. Overview Arsitektur

Secara garis besar, HabitFlow dibangun dengan arsitektur client-heavy, di mana sebagian besar logic (perhitungan streak, consistency score, validasi form) ditangani di sisi Flutter, sementara Supabase berperan sebagai penyedia data, autentikasi, dan storage. Pendekatan ini dipilih karena selaras dengan tujuan pembelajaran, yaitu memahami bagaimana aplikasi Flutter mengelola state dan business logic secara mandiri, bukan sekadar menjadi tampilan dari backend.

```
┌─────────────────────────────────────────────┐
│              Flutter Application              │
│        (Mobile: Android/iOS · Web)             │
│                                                │
│  ┌──────────────┐  ┌──────────────┐          │
│  │ Presentation │  │   Domain     │          │
│  │   Layer      │←→│   Layer      │          │
│  └──────────────┘  └──────────────┘          │
│         ↑                  ↑                  │
│         └──────────────────┘                  │
│                  │                             │
│           ┌──────────────┐                    │
│           │  Data Layer  │                    │
│           └──────────────┘                    │
└─────────────────┬───────────────────────────┘
                  │
                  ▼
     ┌─────────────────────────┐
     │      Supabase Backend    │
     │                          │
     │  ┌────────┐ ┌─────────┐ │
     │  │  Auth  │ │ Storage │ │
     │  └────────┘ └─────────┘ │
     │  ┌──────────────────┐   │
     │  │  PostgreSQL + RLS │   │
     │  └──────────────────┘   │
     └─────────────────────────┘
```

Kenapa pendekatan ini masuk akal untuk HabitFlow: perhitungan streak dan consistency score membutuhkan logic yang cukup spesifik (mempertimbangkan grace period, hari non-jadwal, dan sebagainya), sehingga lebih terkontrol jika ditulis eksplisit di domain layer Flutter daripada disembunyikan dalam database function yang lebih sulit dites dan ditelusuri saat proses belajar.

---

> **Catatan penting soal Authentication:** Proyek ini menggunakan Supabase Auth dengan metode **email/password saja**. Email yang didaftarkan bersifat simulasi (tidak wajib email asli, karena fitur "Confirm email" dinonaktifkan di pengaturan Supabase Auth agar akun langsung aktif setelah sign up). **Google Sign-In tidak termasuk dalam scope proyek ini** dan tidak perlu diimplementasikan dalam bentuk apapun, untuk menjaga proses pembelajaran tetap sederhana.

## 2. Software Architecture Pattern

Proyek ini menggunakan Clean Architecture dengan pendekatan feature-first, di mana setiap fitur (auth, habits, logging, statistics, profile) punya struktur internal yang identik, terdiri dari tiga lapisan.

**Presentation Layer** menangani semua hal yang berhubungan dengan UI, mencakup screens, widgets, dan providers (Riverpod) yang menjembatani UI dengan domain layer. Lapisan ini tidak boleh berisi logic bisnis, murni soal bagaimana data ditampilkan dan interaksi pengguna ditangkap.

**Domain Layer** berisi entities (representasi murni dari data, tidak terikat pada Supabase), use cases (satu class untuk satu aksi spesifik, misal `CreateHabitUseCase` atau `CalculateStreakUseCase`), dan repository interface (kontrak abstrak yang nanti diimplementasikan di data layer). Lapisan ini adalah jantung dari business logic dan sepenuhnya independen dari framework maupun database.

**Data Layer** bertanggung jawab pada implementasi repository yang sebenarnya, models (representasi data yang sesuai dengan struktur tabel Supabase, biasanya dengan method `fromJson`/`toJson`), dan data sources (kelas yang benar-benar memanggil Supabase client).

Alasan memilih pola ini untuk pemula: meskipun terasa lebih banyak boilerplate di awal, pola feature-first Clean Architecture membuat setiap fitur mudah dipahami secara terisolasi. Kalau ingin memahami fitur habit logging misalnya, semua yang relevan ada dalam satu folder, tidak tersebar di berbagai tempat.

```
Presentation  →  Domain  →  Data  →  Supabase
   (UI)         (Logic)    (Repo)    (Server)
```

---

## 3. Folder Structure

```
lib/
├── main.dart
├── app.dart                          # MaterialApp.router config
│
├── core/
│   ├── config/
│   │   └── supabase_config.dart      # inisialisasi Supabase client
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_spacing.dart
│   ├── router/
│   │   └── app_router.dart           # go_router configuration
│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── validators.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   └── widgets/                      # shared/reusable widgets
│       ├── app_button.dart
│       ├── app_text_field.dart
│       └── loading_indicator.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_up_usecase.dart      # email/password, bersifat simulasi (tidak wajib email asli)
│   │   │       ├── sign_in_usecase.dart
│   │   │       └── reset_password_usecase.dart  # reset via form, tanpa email verifikasi sungguhan
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   ├── register_screen.dart
│   │       │   └── forgot_password_screen.dart
│   │       └── widgets/
│   │
│   ├── onboarding/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── guided_setup_screen.dart
│   │
│   ├── habits/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── habit_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── habit_model.dart
│   │   │   └── repositories/
│   │   │       └── habit_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── habit_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── habit_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_habit_usecase.dart
│   │   │       ├── update_habit_usecase.dart
│   │   │       ├── archive_habit_usecase.dart
│   │   │       ├── delete_habit_usecase.dart
│   │   │       └── get_habits_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── habit_provider.dart
│   │       ├── screens/
│   │       │   ├── habits_list_screen.dart
│   │       │   ├── add_habit_screen.dart
│   │       │   ├── edit_habit_screen.dart
│   │       │   └── habit_detail_screen.dart
│   │       └── widgets/
│   │           ├── habit_card.dart
│   │           └── icon_color_picker.dart
│   │
│   ├── logging/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── mark_habit_complete_usecase.dart
│   │   │       ├── unmark_habit_usecase.dart
│   │   │       └── add_log_note_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── home_provider.dart
│   │       ├── screens/
│   │       │   └── home_screen.dart
│   │       └── widgets/
│   │           ├── daily_progress_ring.dart
│   │           ├── habit_checklist_item.dart
│   │           └── checkin_bottom_sheet.dart
│   │
│   ├── statistics/
│   │   ├── data/
│   │   ├── domain/
│   │   │   └── usecases/
│   │   │       ├── calculate_streak_usecase.dart
│   │   │       ├── calculate_consistency_score_usecase.dart
│   │   │       └── get_monthly_summary_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── statistics_provider.dart
│   │       ├── screens/
│   │       │   ├── statistics_screen.dart
│   │       │   └── calendar_view_screen.dart
│   │       └── widgets/
│   │           ├── heatmap_chart.dart
│   │           └── weekly_bar_chart.dart
│   │
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── screens/
│           │   ├── profile_screen.dart
│           │   └── settings_screen.dart
│           └── providers/
│               └── theme_provider.dart
│
└── shared/
    └── layout/
        ├── mobile_scaffold.dart      # bottom nav wrapper
        ├── web_scaffold.dart         # sidebar nav wrapper
        └── adaptive_scaffold.dart    # pemilih otomatis berdasar breakpoint
```

Catatan penting: struktur ini sengaja dibuat berulang di setiap fitur (data-domain-presentation) supaya polanya menjadi predictable. Setelah membangun fitur `habits`, membangun fitur `statistics` akan terasa familiar karena mengikuti skeleton yang sama.

---

## 4. Database Design (ERD & Schema)

### Entity Relationship Diagram

```
┌─────────────────┐
│      users        │  (dikelola oleh Supabase Auth: auth.users)
├─────────────────┤
│ id (PK, uuid)      │
│ email               │
└────────┬─────────┘
          │ 1
          │
          │ N
┌────────▼─────────────┐
│    profiles            │
├──────────────────────┤
│ id (PK, FK → users.id) │
│ display_name           │
│ avatar_url              │
│ theme_preference        │
│ notif_enabled           │
│ created_at              │
│ updated_at              │
└──────────────────────┘

┌────────┬─────────┐
│      users        │
└────────┬─────────┘
          │ 1
          │
          │ N
┌────────▼──────────────────┐
│         habits              │
├──────────────────────────┤
│ id (PK, uuid)                │
│ user_id (FK → users.id)      │
│ name                          │
│ icon_name                     │
│ color_hex                     │
│ category                      │
│ frequency_type                │
│ frequency_value (jsonb)       │
│ reminder_time (nullable)      │
│ reminder_message (nullable)   │
│ is_archived (boolean)         │
│ longest_streak (int)          │
│ created_at                    │
│ updated_at                    │
└────────┬──────────────────┘
          │ 1
          │
          │ N
┌────────▼──────────────────┐
│       habit_logs            │
├──────────────────────────┤
│ id (PK, uuid)                │
│ habit_id (FK → habits.id)    │
│ user_id (FK → users.id)      │
│ log_date (date)               │
│ is_completed (boolean)        │
│ mood (nullable, enum)         │
│ note (nullable, varchar 100)  │
│ created_at                    │
└──────────────────────────┘
```

### Detail Schema

**Table: profiles**
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid (PK, FK) | Sama dengan auth.users.id |
| display_name | varchar | Nama tampilan pengguna |
| avatar_url | text | Nullable, path ke Supabase Storage |
| theme_preference | varchar | `light` / `dark`, default `light` |
| notif_enabled | boolean | Default `true` |
| created_at | timestamptz | Default `now()` |
| updated_at | timestamptz | Auto-update via trigger |

**Table: habits**
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid (PK) | Default `gen_random_uuid()` |
| user_id | uuid (FK) | References `auth.users.id` |
| name | varchar | Wajib diisi, max 50 karakter |
| icon_name | varchar | Referensi ke icon set preset |
| color_hex | varchar | Format `#RRGGBB` |
| category | varchar | `health`, `learning`, `mindfulness`, `productivity`, `social`, `custom` |
| frequency_type | varchar | `daily`, `specific_days`, `x_per_week` |
| frequency_value | jsonb | Contoh: `["mon","wed","fri"]` atau `{"times": 3}` |
| reminder_time | time | Nullable |
| reminder_message | varchar | Nullable, max 100 karakter |
| is_archived | boolean | Default `false` |
| longest_streak | int | Default `0`, diupdate lewat use case |
| created_at | timestamptz | Default `now()` |
| updated_at | timestamptz | Auto-update via trigger |

**Table: habit_logs**
| Kolom | Tipe | Keterangan |
|---|---|---|
| id | uuid (PK) | Default `gen_random_uuid()` |
| habit_id | uuid (FK) | References `habits.id`, cascade delete |
| user_id | uuid (FK) | References `auth.users.id`, untuk mempermudah RLS |
| log_date | date | Wajib, kombinasi unik dengan `habit_id` |
| is_completed | boolean | Default `true` saat insert |
| mood | varchar | Nullable: `good`, `neutral`, `tired` |
| note | varchar | Nullable, max 100 karakter |
| created_at | timestamptz | Default `now()` |

**Constraint penting:** kombinasi `habit_id` + `log_date` harus unik (unique constraint), supaya satu habit hanya punya satu log per hari, dan operasi check-in cukup menggunakan `upsert`.

---

## 5. Row Level Security Policy

Setiap tabel yang menyimpan data personal wajib memiliki RLS aktif dengan pola yang konsisten: pengguna hanya bisa mengakses baris yang `user_id`-nya sama dengan `auth.uid()`.

**Kebijakan untuk tabel `habits`:**
- SELECT: diizinkan jika `user_id = auth.uid()`
- INSERT: diizinkan jika `user_id = auth.uid()` pada baris yang akan dimasukkan
- UPDATE: diizinkan jika `user_id = auth.uid()`
- DELETE: diizinkan jika `user_id = auth.uid()`

**Kebijakan untuk tabel `habit_logs`:**
Pola yang sama diterapkan, dengan tambahan validasi bahwa `habit_id` yang direferensikan juga benar-benar milik user yang sedang login, sebagai lapisan keamanan kedua di luar `user_id` yang sudah ada langsung di tabel log.

**Kebijakan untuk tabel `profiles`:**
- SELECT dan UPDATE hanya diizinkan untuk baris dengan `id = auth.uid()`
- Baris profile dibuat otomatis lewat trigger setelah user baru terdaftar di `auth.users`

Pendekatan menaruh `user_id` langsung di tabel `habit_logs` (bukan hanya join lewat `habits`) sengaja dilakukan supaya penulisan RLS policy dan query jauh lebih sederhana, meskipun sedikit redundan secara normalisasi data.

---

## 6. State Management Pattern

Riverpod digunakan dengan beberapa jenis provider yang disesuaikan dengan kebutuhan masing-masing:

**AsyncNotifierProvider** digunakan untuk data yang butuh proses async dan bisa diubah, seperti daftar habits atau habit logs. Provider jenis ini otomatis menangani state `loading`, `data`, dan `error` tanpa perlu ditulis manual.

**Provider (biasa)** digunakan untuk dependency injection sederhana, misalnya menyediakan instance repository ke use case, atau use case ke provider di atasnya.

**StateProvider** digunakan untuk state UI yang sederhana dan tidak butuh async, seperti filter kategori yang sedang aktif di halaman habits list, atau toggle antara quick view dan detail view.

**Pola aliran data secara umum:**

```
UI (Screen/Widget)
   │
   │  ref.watch(habitListProvider)
   ▼
AsyncNotifierProvider (Presentation)
   │
   │  memanggil use case
   ▼
UseCase (Domain)
   │
   │  memanggil repository interface
   ▼
Repository Implementation (Data)
   │
   │  memanggil data source
   ▼
Supabase Client
```

**Contoh kasus konkret — menandai habit selesai:**
1. User tap checkbox di `HabitChecklistItem`
2. Widget memanggil `ref.read(homeProvider.notifier).markComplete(habitId)`
3. Provider langsung update state lokal secara optimis (UI berubah instan)
4. Provider memanggil `MarkHabitCompleteUseCase`
5. Use case memanggil `HabitLogRepository.upsertLog()`
6. Repository memanggil Supabase melalui data source
7. Jika gagal, provider melakukan rollback state ke kondisi sebelumnya dan menampilkan pesan error

Pendekatan optimistic update ini penting untuk memenuhi non-functional requirement soal performa, di mana interaksi check-in harus terasa instan meski di balik layar masih ada proses network call.

---

## 7. Routing & Navigation Structure

go_router dipilih karena mendukung URL-based routing yang dibutuhkan versi web, sekaligus tetap kompatibel dengan pola navigasi stack di mobile.

```
/                          → Splash / Auth Check
/login                     → Login Screen
/register                  → Register Screen
/forgot-password           → Forgot Password Screen
/onboarding/guided-setup   → Guided Setup (pilih habit awal)

/home                      → Home Screen (daily check-in)
/habits                    → Habits List Screen
/habits/add                → Add Habit Screen
/habits/:id                → Habit Detail Screen
/habits/:id/edit           → Edit Habit Screen

/statistics                → Statistics Overview
/statistics/calendar       → Calendar View

/profile                   → Profile Screen
/profile/settings          → Settings Screen
```

**Route guard:** middleware sederhana di level `redirect` pada go_router akan memeriksa status autentikasi. Jika user belum login dan mencoba mengakses route selain `/login`, `/register`, atau `/forgot-password`, sistem akan otomatis mengarahkan ke `/login`. Sebaliknya, user yang sudah login tidak akan bisa mengakses halaman auth tersebut.

**Shell route untuk navigasi utama:** route `/home`, `/habits`, `/statistics`, dan `/profile` dibungkus dalam `ShellRoute` yang menampilkan `AdaptiveScaffold`, sehingga bottom navigation (mobile) atau sidebar (web) tetap konsisten terlihat saat berpindah antar tab.

---

## 8. Business Logic: Streak & Consistency Engine

Ini adalah bagian paling krusial dari HabitFlow, mengingat differentiator utama aplikasi ini terletak pada cara streak dihitung.

### Perhitungan Streak

Streak dihitung berdasarkan hari-hari yang memang dijadwalkan untuk habit tersebut, bukan hari kalender biasa. Untuk habit dengan frekuensi `daily`, setiap hari dihitung. Untuk `specific_days`, hanya hari yang tercantum di `frequency_value` yang dihitung sebagai hari wajib. Untuk `x_per_week`, sistem menghitung apakah target mingguan tercapai, bukan berdasarkan hari spesifik.

**Konsep grace period:** ketika satu hari wajib terlewat, sistem tidak langsung mereset streak ke nol. Sebagai gantinya, sistem memberikan toleransi satu hari (grace day) sebelum benar-benar memutus streak. Jika dalam grace day tersebut pengguna kembali melakukan check-in, streak dianggap tetap bersambung namun dengan catatan "dilanjutkan setelah jeda". Jika grace day juga terlewat, barulah streak dihitung ulang dari nol pada check-in berikutnya.

```
Pseudocode — CalculateStreakUseCase

function calculateStreak(habitId):
    logs = getLogsSortedByDateDesc(habitId)
    scheduledDates = getScheduledDates(habit, fromDate: today, backwards: true)
    
    streak = 0
    graceUsed = false
    
    for date in scheduledDates:
        if hasCompletedLog(logs, date):
            streak += 1
        else if not graceUsed:
            graceUsed = true
            continue  // lewati satu hari tanpa memutus streak
        else:
            break  // streak terputus
    
    return streak
```

### Perhitungan Consistency Score

Consistency Score dihitung terpisah dari streak, sebagai representasi yang lebih menyeluruh dari performa 30 hari terakhir, tidak terpengaruh oleh grace period.

```
Consistency Score = (jumlah hari terselesaikan / jumlah hari terjadwal) × 100%

Rentang waktu: 30 hari terakhir
Hanya menghitung hari yang memang terjadwal berdasarkan frequency_type
```

### Longest Streak

Setiap kali `CalculateStreakUseCase` dijalankan dan menghasilkan angka yang lebih besar dari `longest_streak` yang tersimpan di tabel `habits`, sistem akan mengupdate kolom tersebut sebagai pencatatan rekor historis.

---

## 9. Data Sync Strategy (Mobile ↔ Web)

Karena tidak ada backend custom di luar Supabase, sinkronisasi antar platform sepenuhnya mengandalkan Supabase sebagai single source of truth. Strategi yang diterapkan:

**Local caching sederhana.** Data terakhir yang berhasil di-fetch disimpan sementara di memory (state Riverpod), bukan disimpan permanen di local storage pada tahap MVP. Ini artinya saat aplikasi dibuka kembali setelah ditutup, data akan di-fetch ulang dari Supabase.

**Refresh saat kembali aktif.** Setiap kali user berpindah tab atau membuka kembali aplikasi setelah di background, provider terkait akan melakukan refresh data agar perubahan yang mungkin terjadi di platform lain (misalnya check-in dari mobile saat sedang membuka web) langsung terlihat.

**Realtime subscription (opsional, Phase 2).** Supabase mendukung realtime listener yang bisa digunakan agar perubahan data langsung terpantul tanpa perlu refresh manual. Ini dipertimbangkan sebagai peningkatan di luar MVP, mengingat kompleksitas tambahan dalam mengelola subscription lifecycle.

**Konflik data.** Mengingat sifat aplikasi personal (satu user, tidak ada kolaborasi multi-user dalam satu data), risiko konflik data sangat rendah. Strategi *last write wins* sudah cukup memadai tanpa perlu mekanisme resolusi konflik yang rumit.

---

## 10. Responsive Layout Strategy

Pendekatan adaptive dilakukan di level widget `AdaptiveScaffold` yang membaca lebar layar lewat `MediaQuery` dan memilih layout yang sesuai.

```dart
class AdaptiveScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 600) {
      return MobileScaffold(child: child);   // bottom navigation
    } else {
      return WebScaffold(child: child);      // sidebar navigation
    }
  }
}
```

**Perbedaan komponen antar layout:**

| Elemen | Mobile (< 600px) | Web (≥ 600px) |
|---|---|---|
| Navigasi utama | Bottom navigation bar | Sidebar kiri persistent |
| Habit list | Single column, full width card | Grid 2-3 kolom |
| Statistics | Scroll vertikal per section | Grid layout, semua chart terlihat sekaligus |
| Add habit | Full screen | Modal dialog di tengah layar |
| Detail habit | Push ke screen baru | Side panel atau modal lebar |

Prinsip yang dipegang: komponen inti (`HabitCard`, `HeatmapChart`, dan sebagainya) dibuat sekali sebagai widget yang reusable, sementara yang berbeda hanyalah bagaimana widget-widget tersebut disusun dalam layout (grid vs list, sidebar vs bottom nav).

---

## 11. Alur Kerja UI/UX dengan Google Stitch

Sebelum masuk ke tahap penyusunan kode, akan dilakukan proses desain kasar menggunakan Google Stitch untuk menghasilkan gambaran visual awal dari aplikasi. Berikut alur kerja yang direncanakan agar proses ini terhubung baik dengan dokumen-dokumen sebelumnya:

**Tahap 1 — Persiapan Prompt untuk Stitch.** Screen inventory yang sudah disusun di dokumen Phase 1 (Brainstorming) akan dijadikan dasar penyusunan prompt per layar, mencakup deskripsi tujuan layar, elemen yang harus ada, serta gaya visual yang diinginkan berdasarkan Design System yang akan disusun di Phase 4.

**Tahap 2 — Generate per Kelompok Layar.** Alih-alih meminta seluruh aplikasi sekaligus, layar akan digenerate per kelompok fitur (auth flow, home & check-in, habits management, statistics, profile) supaya hasilnya lebih terarah dan mudah dievaluasi satu per satu.

**Tahap 3 — Evaluasi terhadap Screen Inventory.** Setiap hasil dari Stitch akan dicocokkan kembali dengan daftar screen yang sudah direncanakan, memastikan tidak ada elemen fungsional yang terlewat, seperti progress ring di home atau color picker di form tambah habit.

**Tahap 4 — Ekstraksi Referensi Visual untuk Design System.** Hasil dari Stitch tidak langsung dijadikan acuan pasti, tapi digunakan sebagai referensi kasar untuk menyusun Design System yang lebih terstruktur di Phase 4, termasuk penentuan palet warna final, tipografi, dan komponen yang konsisten.

**Tahap 5 — Menjadi Referensi Visual saat Prompting ke AI Agent.** Ketika masuk ke tahap pembangunan kode, screenshot atau deskripsi dari hasil Stitch akan disertakan sebagai referensi visual dalam prompt ke AI Agent, sehingga output kode antarmuka yang dihasilkan punya arah visual yang jelas, bukan sekadar mengandalkan deskripsi teks semata.

Catatan penting: karena Stitch menghasilkan output berbasis AI generatif, kemungkinan besar akan ada penyesuaian manual pada detail kecil (spacing, ukuran font, kontras warna) setelah dokumen Design System selesai disusun. Proses ini bersifat iteratif dan tidak harus sempurna di percobaan pertama.

---

## 12. Dependency List

Berikut daftar pustaka utama yang direncanakan digunakan, sebagai referensi saat setup awal proyek.

| Pustaka | Fungsi | Kategori |
|---|---|---|
| flutter_riverpod | State management | Core |
| go_router | Navigasi & routing | Core |
| supabase_flutter | Koneksi ke Supabase | Core |
| fl_chart | Grafik & heatmap | UI |
| flutter_local_notifications | Reminder lokal | Fitur |
| image_picker | Upload foto profil | Fitur |
| pdf & printing | Export laporan | Fitur |
| intl | Format tanggal & lokal | Utility |
| equatable | Perbandingan objek (entities) | Utility |
| get_it (opsional) | Dependency injection | Arsitektur |

---

## Ringkasan Phase 3

| Aspek | Keputusan |
|---|---|
| Pattern arsitektur | Clean Architecture, feature-first |
| State management | Riverpod 2.x (AsyncNotifier, Provider, StateProvider) |
| Navigasi | go_router dengan ShellRoute + route guard |
| Database | Supabase PostgreSQL, 3 tabel utama (profiles, habits, habit_logs) |
| Keamanan data | RLS di semua tabel berbasis `auth.uid()` |
| Logic streak | Custom engine di domain layer dengan grace period |
| Sync strategy | Supabase sebagai single source of truth, refresh on resume |
| Layout | Adaptive scaffold, breakpoint 600px |
| Alat desain UI | Google Stitch untuk draft kasar sebelum coding |

---

## Langkah Selanjutnya

```
✅ Phase 1 — Brainstorming & Detailing
✅ Phase 2 — PRD
✅ Phase 3 — Technical Architecture

🔜 Phase 4 — Design System
   → Color palette (light & dark)
   → Typography scale
   → Component library (button, card, input, dsb)
   → Spacing & breakpoint system
   → Icon set
   → Menjadi acuan prompt untuk Google Stitch

💬 Phase 5 — Prompt Engineering Plan
   → Prompt untuk Google Stitch (per kelompok layar)
   → Master prompt untuk AI Agent (setup proyek)
   → Prompt per fitur untuk tahap coding
```

---

*Dokumen Technical Architecture Phase 3 — HabitFlow, menjadi acuan struktural dalam proses pengembangan aplikasi pada tahap-tahap selanjutnya.*
