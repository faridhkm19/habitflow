// Template data untuk fitur Guided Onboarding (Task 2.2)
// Berisi konstanta lokal yang akan ditawarkan ke pengguna saat pertama kali setup.

class HabitTemplateItem {
  final String name;
  final String iconName;
  final String colorHex;
  final String category;
  final String frequencyType;
  final Map<String, dynamic> frequencyValue;

  const HabitTemplateItem({
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.category,
    required this.frequencyType,
    this.frequencyValue = const {},
  });
}

class HabitTemplate {
  final String id;
  final String title;
  final String description;
  final List<HabitTemplateItem> habits;

  const HabitTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.habits,
  });
}

// 4 Preset Template sesuai PRD
final List<HabitTemplate> onboardingTemplates = [
  const HabitTemplate(
    id: 'morning_routine',
    title: 'Rutinitas Pagi',
    description: 'Mulai hari dengan segar dan terstruktur',
    habits: [
      HabitTemplateItem(
        name: 'Bangun Jam 6 Pagi',
        iconName: 'alarm_on',
        colorHex: '#4E55E0', // Primary
        category: 'health',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Olahraga Ringan 15 Menit',
        iconName: 'fitness_center',
        colorHex: '#B8EB6C', // Secondary
        category: 'health',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Sarapan Sehat',
        iconName: 'restaurant',
        colorHex: '#F7CD63', // Accent1
        category: 'health',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Journaling Pagi',
        iconName: 'edit_note',
        colorHex: '#FC8FC6', // Accent2
        category: 'mindfulness',
        frequencyType: 'daily',
      ),
    ],
  ),
  const HabitTemplate(
    id: 'healthy_lifestyle',
    title: 'Gaya Hidup Sehat',
    description: 'Perbaiki pola makan, tidur, dan aktivitas fisik',
    habits: [
      HabitTemplateItem(
        name: 'Minum 8 Gelas Air',
        iconName: 'local_drink',
        colorHex: '#6C9BEB', // Light blue
        category: 'health',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Tidur Sebelum Jam 11',
        iconName: 'bedtime',
        colorHex: '#4E55E0',
        category: 'health',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Jalan Kaki 30 Menit',
        iconName: 'directions_walk',
        colorHex: '#B8EB6C',
        category: 'health',
        frequencyType: 'x_per_week',
        frequencyValue: {'times': 3},
      ),
      HabitTemplateItem(
        name: 'Tanpa Fast Food',
        iconName: 'no_food',
        colorHex: '#EB8F6C', // Peach orange
        category: 'health',
        frequencyType: 'daily',
      ),
    ],
  ),
  const HabitTemplate(
    id: 'study_focus',
    title: 'Fokus Belajar',
    description: 'Tingkatkan produktivitas dan konsentrasi',
    habits: [
      HabitTemplateItem(
        name: 'Baca Buku 20 Menit',
        iconName: 'menu_book',
        colorHex: '#4E55E0',
        category: 'learning',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Review Catatan Kuliah',
        iconName: 'notes',
        colorHex: '#6C9BEB',
        category: 'learning',
        frequencyType: 'specific_days',
        frequencyValue: {
          'days': ['mon', 'wed', 'fri'],
        },
      ),
      HabitTemplateItem(
        name: 'Tanpa Sosmed 2 Jam',
        iconName: 'app_blocking',
        colorHex: '#EB8F6C',
        category: 'productivity',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Latihan Soal',
        iconName: 'quiz',
        colorHex: '#F7CD63',
        category: 'learning',
        frequencyType: 'x_per_week',
        frequencyValue: {'times': 3},
      ),
    ],
  ),
  const HabitTemplate(
    id: 'mindfulness',
    title: 'Mindfulness',
    description: 'Lebih tenang, sadar, dan bebas stres',
    habits: [
      HabitTemplateItem(
        name: 'Meditasi 10 Menit',
        iconName: 'self_improvement',
        colorHex: '#4E55E0',
        category: 'mindfulness',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Tulis 3 Hal Disyukuri',
        iconName: 'favorite',
        colorHex: '#FC8FC6',
        category: 'mindfulness',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Tanpa HP Sebelum Tidur',
        iconName: 'do_not_disturb',
        colorHex: '#6C9BEB',
        category: 'mindfulness',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Latihan Napas Dalam',
        iconName: 'air',
        colorHex: '#B8EB6C',
        category: 'mindfulness',
        frequencyType: 'daily',
      ),
    ],
  ),
  const HabitTemplate(
    id: 'fitness',
    title: 'Olahraga & Kebugaran',
    description: 'Bangun tubuh sehat dengan latihan yang konsisten',
    habits: [
      HabitTemplateItem(
        name: 'Lari Pagi',
        iconName: 'directions_run',
        colorHex: '#EB8F6C',
        category: 'health',
        frequencyType: 'x_per_week',
        frequencyValue: {'times': 3},
      ),
      HabitTemplateItem(
        name: 'Push-up 30 Repetisi',
        iconName: 'fitness_center',
        colorHex: '#4E55E0',
        category: 'health',
        frequencyType: 'specific_days',
        frequencyValue: {
          'days': ['mon', 'wed', 'fri'],
        },
      ),
      HabitTemplateItem(
        name: 'Peregangan / Stretching',
        iconName: 'accessibility_new',
        colorHex: '#B8EB6C',
        category: 'health',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Renang / Olahraga Air',
        iconName: 'pool',
        colorHex: '#6C9BEB',
        category: 'health',
        frequencyType: 'x_per_week',
        frequencyValue: {'times': 1},
      ),
    ],
  ),
  const HabitTemplate(
    id: 'self_development',
    title: 'Pengembangan Diri',
    description: 'Terus tumbuh dan kembangkan potensi terbaikmu',
    habits: [
      HabitTemplateItem(
        name: 'Podcast / Audiobook 20 Menit',
        iconName: 'headphones',
        colorHex: '#4E55E0',
        category: 'learning',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Belajar Skill Baru 30 Menit',
        iconName: 'lightbulb',
        colorHex: '#F7CD63',
        category: 'learning',
        frequencyType: 'specific_days',
        frequencyValue: {
          'days': ['mon', 'wed', 'fri'],
        },
      ),
      HabitTemplateItem(
        name: 'Hubungi Rekan / Networking',
        iconName: 'people',
        colorHex: '#FC8FC6',
        category: 'social',
        frequencyType: 'x_per_week',
        frequencyValue: {'times': 2},
      ),
      HabitTemplateItem(
        name: 'Review Target Mingguan',
        iconName: 'track_changes',
        colorHex: '#B8EB6C',
        category: 'productivity',
        frequencyType: 'specific_days',
        frequencyValue: {
          'days': ['sun'],
        },
      ),
    ],
  ),
  const HabitTemplate(
    id: 'rest_relaxation',
    title: 'Istirahat & Relaksasi',
    description: 'Jaga keseimbangan energi agar tetap produktif',
    habits: [
      HabitTemplateItem(
        name: 'Tidur Cukup 7-8 Jam',
        iconName: 'bedtime',
        colorHex: '#4E55E0',
        category: 'health',
        frequencyType: 'daily',
      ),
      HabitTemplateItem(
        name: 'Jalan Santai di Luar',
        iconName: 'nature_people',
        colorHex: '#B8EB6C',
        category: 'health',
        frequencyType: 'x_per_week',
        frequencyValue: {'times': 3},
      ),
      HabitTemplateItem(
        name: 'Digital Detox 1 Jam',
        iconName: 'phonelink_off',
        colorHex: '#EB8F6C',
        category: 'mindfulness',
        frequencyType: 'specific_days',
        frequencyValue: {
          'days': ['sat', 'sun'],
        },
      ),
      HabitTemplateItem(
        name: 'Baca Buku Santai',
        iconName: 'auto_stories',
        colorHex: '#FC8FC6',
        category: 'mindfulness',
        frequencyType: 'daily',
      ),
    ],
  ),
];
