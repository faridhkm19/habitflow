# Design System
## HabitFlow — Fun & Friendly, Light Mode Focus

---

## Daftar Isi

1. [Prinsip Desain](#1-prinsip-desain)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Spacing & Layout Grid](#4-spacing--layout-grid)
5. [Border Radius & Elevation](#5-border-radius--elevation)
6. [Iconography](#6-iconography)
7. [Component Library](#7-component-library)
8. [Component States](#8-component-states)
9. [Responsive Breakpoints](#9-responsive-breakpoints)
10. [Motion & Micro-interaction](#10-motion--micro-interaction)
11. [Catatan Dark Mode](#11-catatan-dark-mode)

---

## 1. Prinsip Desain

Design system ini disusun berdasarkan hasil riset referensi UI dan keputusan warna yang sudah ditetapkan sebelumnya, dengan tiga prinsip utama yang memandu setiap keputusan visual.

**Fun tapi tetap terkontrol.** Mengacu pada tren *exaggerated minimalism*, HabitFlow tetap mempertahankan layout yang bersih dan terstruktur, namun elemen tertentu seperti warna, ilustrasi, dan micro-interaction dibuat cukup ekspresif supaya aplikasi tidak terasa monoton atau kaku seperti tracker pada umumnya.

**Suportif, bukan menghukum.** Setiap keputusan visual, terutama warna, tetap tunduk pada prinsip dari PRD bahwa aplikasi tidak boleh membuat pengguna merasa bersalah. Tidak ada elemen visual yang secara sengaja dibuat "menakutkan" untuk merepresentasikan kegagalan.

**Konsisten lintas platform.** Karena HabitFlow berjalan di mobile dan web, seluruh token desain di dokumen ini (warna, spacing, radius) dibuat sebagai satu sumber kebenaran yang sama, hanya composition layout-nya yang berbeda antara mobile dan web, sebagaimana sudah dijelaskan di Technical Architecture.

---

## 2. Color System

Palet berikut adalah Opsi A yang sudah dipilih sebelumnya, disusun ulang sebagai design token yang siap dipakai di kode.

### Brand Colors

| Token | Hex | Peran |
|---|---|---|
| `color.primary` | `#4E55E0` | Periwinkle Blue — CTA utama, active state, brand |
| `color.secondary` | `#B8EB6C` | Lime Green — progress, pencapaian, completion |
| `color.accent1` | `#F7CD63` | Mustard Amber — reward, badge, streak |
| `color.accent2` | `#FC8FC6` | Bubblegum Pink — elemen playful, dekoratif |

### Variasi Tint & Shade (untuk kebutuhan hover, background lembut, dsb)

| Token | Hex | Keterangan |
|---|---|---|
| `color.primary.light` | `#EEEFFC` | Background lembut berbasis primary (mis. selected chip) |
| `color.primary.dark` | `#3A3FB0` | Untuk pressed state tombol primary |
| `color.secondary.light` | `#EEFAE0` | Background progress bar track |
| `color.secondary.dark` | `#8FC94A` | Untuk teks/ikon di atas background lime |
| `color.accent1.light` | `#FDF3DE` | Background badge amber |
| `color.accent2.light` | `#FEEAF4` | Background badge pink |

### Neutral (Light Mode)

| Token | Hex | Penggunaan |
|---|---|---|
| `color.background` | `#FDFBF7` | Background utama aplikasi |
| `color.surface` | `#FFFFFF` | Background card, sheet, dialog |
| `color.border` | `#E8E4DC` | Divider, outline input, border card |
| `color.text.primary` | `#2B2B2B` | Teks judul dan body utama |
| `color.text.secondary` | `#6E6E6E` | Teks pendukung, caption, placeholder |
| `color.text.onPrimary` | `#FFFFFF` | Teks di atas warna primary |

### Semantic

| Token | Hex | Penggunaan |
|---|---|---|
| `color.success` | `#B8EB6C` (secondary) | Menggunakan warna sekunder yang sudah ada, bukan hijau generik |
| `color.warning` | `#F7CD63` (accent1) | Menggunakan warna pendukung yang sudah ada |
| `color.error` | `#E57373` | Dipakai sangat terbatas, hanya untuk validasi form/error teknis, tidak untuk merepresentasikan progres habit yang terlewat |
| `color.neutralMissed` | `#D8D5CE` | Representasi hari yang terjadwal tapi belum/tidak diselesaikan, netral dan tidak menghukum |

### Kategori Habit (Color Picker saat Create Habit)

Pengguna bisa memilih salah satu dari kombinasi warna berikut saat membuat habit baru, semuanya diturunkan dari brand color yang sama supaya tetap harmonis:

```
#4E55E0  Periwinkle Blue
#B8EB6C  Lime Green
#F7CD63  Mustard Amber
#FC8FC6  Bubblegum Pink
#6C9BEB  Sky Blue (turunan primary)
#EB8F6C  Peach Orange (turunan accent, komplementer)
```

---

## 3. Typography

Font yang dipilih adalah **Poppins** sebagai typeface utama, dengan **Inter** sebagai alternatif fallback untuk teks body pada ukuran kecil apabila dibutuhkan keterbacaan ekstra di layar mobile.

Alasan pemilihan Poppins sebagai typeface utama: bentuknya geometris dengan sudut yang sedikit membulat pada beberapa huruf, terasa modern dan bersih namun tetap ramah, sesuai dengan arahan "modern & clean tapi tetap friendly" yang sudah ditentukan sebelumnya. Poppins juga sudah sangat teruji dalam kombinasi Flutter dan web karena tersedia lengkap di Google Fonts.

### Type Scale

| Token | Ukuran | Weight | Line Height | Penggunaan |
|---|---|---|---|---|
| `text.display` | 32px | Bold (700) | 40px | Judul besar di splash/onboarding |
| `text.h1` | 24px | SemiBold (600) | 32px | Judul halaman (mis. "Habits", "Statistics") |
| `text.h2` | 20px | SemiBold (600) | 28px | Judul section, judul card besar |
| `text.h3` | 16px | SemiBold (600) | 24px | Judul card habit, subjudul |
| `text.bodyLarge` | 16px | Regular (400) | 24px | Body text utama |
| `text.bodyMedium` | 14px | Regular (400) | 20px | Body text sekunder, deskripsi |
| `text.bodySmall` | 12px | Regular (400) | 16px | Caption, label kecil, timestamp |
| `text.button` | 14px | Medium (500) | 20px | Label tombol |
| `text.numberLarge` | 28px | Bold (700) | 34px | Angka besar (streak, consistency score) |

Untuk web, seluruh ukuran di atas tetap sama sebagai baseline, namun elemen seperti `text.display` dan `text.h1` boleh dinaikkan sedikit (misalnya +4px) pada breakpoint layar besar (≥ 1024px) supaya tidak terasa terlalu kecil di layar lebar.

---

## 4. Spacing & Layout Grid

Spacing menggunakan sistem berbasis kelipatan 4px, supaya konsisten dan mudah dihitung baik oleh developer maupun saat translasi dari desain Figma/Stitch ke kode Flutter.

| Token | Nilai | Penggunaan |
|---|---|---|
| `space.xs` | 4px | Jarak antar elemen sangat rapat (icon-text) |
| `space.sm` | 8px | Jarak antar elemen kecil dalam satu komponen |
| `space.md` | 16px | Padding standar card, jarak antar elemen umum |
| `space.lg` | 24px | Jarak antar section |
| `space.xl` | 32px | Margin halaman, jarak section besar |
| `space.xxl` | 48px | Jarak pada layout web yang lebih lega |

**Grid mobile:** margin halaman kiri-kanan 16px, single column, jarak antar card 12px.

**Grid web:** margin halaman kiri-kanan minimum 32px (menyesuaikan lebar sidebar), grid 12 kolom untuk konten utama, gutter 24px antar kolom, maksimum lebar konten 1200px supaya tidak terlalu melebar di layar sangat besar.

---

## 5. Border Radius & Elevation

Sesuai keputusan sebelumnya, radius yang digunakan adalah **medium rounded** — cukup membulat untuk terasa fun, tapi tidak se-ekstrem squircle penuh seperti referensi Ronas IT, supaya tetap terasa lebih netral dan mudah dipadukan dengan konten yang padat seperti statistik dan angka.

| Token | Nilai | Penggunaan |
|---|---|---|
| `radius.sm` | 8px | Chip, badge kecil, input field |
| `radius.md` | 12px | Card habit, tombol standar |
| `radius.lg` | 16px | Card besar, bottom sheet, dialog |
| `radius.xl` | 24px | Elemen hero seperti progress ring container, onboarding illustration container |
| `radius.full` | 999px | Avatar, floating action button, pill button |

### Elevation (Shadow)

Shadow dibuat lembut dan tidak terlalu tajam, konsisten dengan mood "tenang tapi fun".

| Token | Nilai (Flutter BoxShadow) | Penggunaan |
|---|---|---|
| `elevation.low` | `blur: 8, opacity: 0.06, offset: (0,2)` | Card habit di list |
| `elevation.medium` | `blur: 16, opacity: 0.08, offset: (0,4)` | Bottom sheet, dropdown |
| `elevation.high` | `blur: 24, opacity: 0.12, offset: (0,8)` | Dialog konfirmasi, modal |

---

## 6. Iconography

Ikon menggunakan gaya **rounded/filled line icon** (bukan sharp/outline tajam), untuk tetap konsisten dengan mood friendly. Direkomendasikan menggunakan set `lucide_icons` atau `phosphor_flutter` dengan varian "rounded" atau "duotone" jika tersedia, karena keduanya punya cakupan ikon yang luas dan mudah diintegrasikan ke Flutter.

**Ukuran standar ikon:**
| Token | Ukuran | Penggunaan |
|---|---|---|
| `icon.sm` | 16px | Ikon inline di teks, caption |
| `icon.md` | 20px | Ikon di button, list item |
| `icon.lg` | 24px | Ikon navigasi, ikon kategori habit |
| `icon.xl` | 32px | Ikon di empty state, ikon besar di card kosong |
| `icon.hero` | 48px+ | Ikon besar di onboarding, ilustrasi pendukung |

**Ikon kustom untuk habit:** selain ikon sistem, disediakan set ikon preset khusus habit (olahraga, membaca, tidur, air minum, meditasi, belajar, dsb) yang digambar dengan gaya rounded-filled agar konsisten, ditampilkan di dalam container lingkaran (`radius.full`) berwarna sesuai kategori habit yang dipilih pengguna.

---

## 7. Component Library

### Button

**Primary Button**
- Background: `color.primary`
- Text: `color.text.onPrimary`, `text.button`
- Radius: `radius.md`
- Padding: vertikal 14px, horizontal 24px
- Penggunaan: aksi utama per halaman (Simpan, Lanjutkan, Masuk)

**Secondary Button**
- Background: transparan
- Border: 1.5px `color.primary`
- Text: `color.primary`
- Radius: `radius.md`
- Penggunaan: aksi alternatif (Batal, Kembali)

**Text Button**
- Tanpa background/border
- Text: `color.primary`, underline opsional
- Penggunaan: aksi tersier (Lupa password, Skip)

**Floating Action Button (mobile)**
- Background: `color.primary`
- Shape: `radius.full`
- Ikon putih di tengah, ukuran `icon.lg`
- Shadow: `elevation.medium`

### Card

**Habit Card (Home & List)**
- Background: `color.surface`
- Radius: `radius.md`
- Padding: `space.md`
- Shadow: `elevation.low`
- Struktur: ikon kategori (kiri, dalam container bulat berwarna), nama habit + streak (tengah), checkbox lingkaran besar (kanan)

**Stat Card**
- Background: `color.surface`
- Radius: `radius.lg`
- Padding: `space.lg`
- Digunakan untuk ringkasan statistik, angka besar (`text.numberLarge`) sebagai fokus utama

### Input Field

- Background: `color.surface`
- Border: 1px `color.border`, berubah jadi `color.primary` saat fokus
- Radius: `radius.sm`
- Padding: vertikal 14px, horizontal 16px
- Label mengambang (floating label) di atas border saat field terisi/fokus

### Progress Ring

- Stroke warna `color.secondary` untuk porsi terisi, `color.neutralMissed` untuk porsi kosong
- Ketebalan stroke 10-12px pada mobile, bisa dinaikkan sedikit di web
- Angka persentase di tengah menggunakan `text.numberLarge`

### Heatmap Cell

- Ukuran cell konsisten, radius `radius.sm` per cell (bukan kotak tajam, supaya tetap terasa fun)
- Gradasi warna dari `color.secondary.light` (completion rendah) ke `color.secondary` (completion tinggi)
- Cell tanpa jadwal: `color.border` (sangat muted, hampir menyatu dengan background)

### Bottom Navigation (Mobile)

- Background: `color.surface`
- Item aktif: ikon dan label berwarna `color.primary`, dengan indikator kecil (dot atau background pill lembut `color.primary.light`) di belakang ikon
- Item tidak aktif: `color.text.secondary`

### Sidebar Navigation (Web)

- Background: `color.surface`
- Lebar tetap ±240px
- Item aktif: background `color.primary.light`, teks dan ikon `color.primary`, radius `radius.sm` pada item
- Logo/wordmark HabitFlow di bagian atas sidebar

### Badge / Chip

- Radius: `radius.sm` untuk chip filter, `radius.full` untuk badge pencapaian kecil
- Filter chip aktif: background `color.primary`, teks putih
- Filter chip tidak aktif: background `color.surface` dengan border `color.border`, teks `color.text.secondary`

### Bottom Sheet (Check-in Mood & Note)

- Background: `color.surface`
- Radius atas: `radius.lg`
- Handle bar kecil di tengah atas sebagai indikator bisa di-drag
- Mood picker: tiga ikon bulat besar (`radius.full`) yang bisa dipilih, dengan state terpilih diberi border `color.primary`

---

## 8. Component States

Setiap komponen interaktif memiliki minimal 4 state yang perlu didefinisikan konsisten:

| State | Perlakuan Umum |
|---|---|
| Default | Sesuai spesifikasi warna dasar komponen |
| Hover (web only) | Background sedikit lebih gelap/terang 5-8%, atau munculkan shadow tipis |
| Pressed/Active | Warna primary bergeser ke `color.primary.dark`, scale sedikit mengecil (0.97x) untuk memberi kesan tactile |
| Disabled | Opacity diturunkan ke 40%, warna dasar tetap sama tanpa diganti abu-abu total |
| Focus (khusus input) | Border berubah ke `color.primary`, dengan tambahan outline glow tipis berwarna `color.primary.light` |

Khusus untuk checkbox check-in habit, ditambahkan state kelima yaitu **Completed**, dengan animasi transisi singkat (checkmark muncul dengan scale-bounce ringan) dan background yang berubah dari outline kosong menjadi terisi warna kategori habit tersebut.

---

## 9. Responsive Breakpoints

Konsisten dengan keputusan di Technical Architecture, breakpoint utama berada di 600px, dengan tambahan breakpoint menengah untuk tablet/layar sedang.

| Breakpoint | Range | Layout |
|---|---|---|
| Mobile | < 600px | Bottom navigation, single column, FAB |
| Tablet/Small Web | 600px – 1024px | Sidebar navigation mulai muncul, grid 2 kolom |
| Desktop/Large Web | > 1024px | Sidebar navigation penuh, grid hingga 3 kolom, max-width konten 1200px |

---

## 10. Motion & Micro-interaction

Mengacu pada tren *motion design yang lebih natural, personal, dan playful*, HabitFlow menggunakan animasi singkat dan halus untuk memperkuat kesan fun tanpa mengganggu kecepatan penggunaan.

| Interaksi | Durasi | Easing | Efek |
|---|---|---|---|
| Tap check-in habit | 250ms | `easeOutBack` | Checkbox scale-bounce, ikon centang muncul |
| Progress ring update | 400ms | `easeInOutCubic` | Animasi mengisi dari nilai lama ke nilai baru |
| Buka bottom sheet | 300ms | `easeOut` | Slide-up dari bawah dengan sedikit fade |
| Perpindahan tab (bottom nav) | 200ms | `easeInOut` | Fade + slight slide pada konten halaman |
| Toast/snackbar konfirmasi | 200ms masuk, 2500ms tahan, 200ms keluar | `easeOut` | Slide dari bawah, auto-dismiss |
| Milestone tercapai (mis. 7 hari streak) | 600ms | `easeOutElastic` | Confetti ringan atau badge pop-up sebagai reward visual |

Prinsip penting: animasi harus selalu terasa cepat dan tidak menghalangi alur penggunaan. Durasi di atas 400ms sebaiknya dihindari untuk interaksi yang sering diulang seperti check-in harian, supaya tidak terasa lambat ketika digunakan berkali-kali dalam sehari.

---

## 11. Catatan Dark Mode

Sesuai kesepakatan, dark mode belum dirancang detail pada dokumen ini dan akan disusun menyusul setelah light mode terkonfirmasi sepenuhnya melalui implementasi awal. Sebagai catatan sementara untuk keperluan arsitektur (mengacu pada `theme_preference` di tabel `profiles`), struktur token warna di atas sudah disusun dalam format semantic naming (`color.background`, `color.surface`, dan seterusnya) bukan hardcoded value, sehingga transisi ke dark mode nantinya cukup dilakukan dengan mendefinisikan ulang nilai tiap token tanpa perlu mengubah struktur kode di level komponen.

---

## Ringkasan Design Token

| Kategori | Keputusan Final |
|---|---|
| Warna primary | Periwinkle Blue `#4E55E0` |
| Warna sekunder | Lime Green `#B8EB6C` |
| Warna pendukung | Mustard Amber `#F7CD63`, Bubblegum Pink `#FC8FC6` |
| Typeface | Poppins (utama), Inter (fallback) |
| Border radius | Medium rounded (8-24px tergantung komponen) |
| Icon style | Rounded/filled line icon |
| Mode yang dirancang detail | Light mode (dark mode menyusul) |

---

## Langkah Selanjutnya

```
✅ Phase 1 — Brainstorming & Detailing
✅ Phase 2 — PRD
✅ Phase 3 — Technical Architecture
✅ Phase 4 — Design System

🔜 Phase 5 — Prompt Engineering Plan
   → Master prompt setup proyek Flutter
   → Prompt per fitur untuk AI Agent (auth, habits, logging, statistics, profile)
   → Strategi iterasi dan refinement per prompt
```

---

*Dokumen Design System Phase 4 — HabitFlow, menjadi acuan visual dalam proses pengembangan aplikasi pada tahap coding selanjutnya.*
