import '../../domain/entities/mood_entry_entity.dart';
import '../../domain/repositories/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final List<MoodEntryEntity> _entries = [
    MoodEntryEntity(
      id: "6",
      moodTitle: "Super",
      moodId: "super",
      date: "August 5",
      time: "10:00",
      note: "Today is a great day!",
      activities: const ["Friends", "Sport"],
      createdAt: DateTime(2026, 8, 5, 10, 0),
    ),
    MoodEntryEntity(
      id: "5",
      moodTitle: "Good",
      moodId: "good",
      date: "August 4",
      time: "18:30",
      note: "Productive day.",
      activities: const ["Work"],
      createdAt: DateTime(2026, 8, 4, 18, 30),
    ),
    MoodEntryEntity(
      id: "1",
      moodTitle: "Neutral",
      moodId: "neutral",
      date: "August 3",
      time: "16:58",
      note: "The day went calmly, but I feel a bit tired.",
      activities: const [],
      createdAt: DateTime(2026, 8, 3, 16, 58),
    ),
    MoodEntryEntity(
      id: "2",
      moodTitle: "Good",
      moodId: "good",
      date: "August 2",
      time: "14:20",
      note: "Spent some time reading a book. Felt very peaceful.",
      activities: const [],
      createdAt: DateTime(2026, 8, 2, 14, 20),
    ),
    MoodEntryEntity(
      id: "7",
      moodTitle: "Bad",
      moodId: "bad",
      date: "August 1",
      time: "21:00",
      note: "Feeling a bit down.",
      activities: const [],
      createdAt: DateTime(2026, 8, 1, 21, 0),
    ),
    MoodEntryEntity(
      id: "3",
      moodTitle: "Super",
      moodId: "super",
      date: "July 31",
      time: "10:15",
      note: "Amazing day at the beach!",
      activities: const ["Friends", "Sport"],
      createdAt: DateTime(2026, 7, 31, 10, 15),
    ),
  ];

  @override
  Future<List<MoodEntryEntity>> getMoodEntries() async {
    return List.from(_entries);
  }

  @override
  Future<void> addMoodEntry(MoodEntryEntity entry) async {
    _entries.insert(0, entry);
  }

  @override
  Future<void> updateMoodEntry(MoodEntryEntity entry) async {
    final index = _entries.indexWhere((e) => e.id == entry.id);
    if (index != -1) {
      _entries[index] = entry;
    }
  }

  @override
  Future<void> deleteMoodEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
  }
}
