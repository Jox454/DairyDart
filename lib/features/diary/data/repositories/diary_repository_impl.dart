import '../../domain/entities/mood_entry_entity.dart';
import '../../domain/repositories/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final List<MoodEntryEntity> _entries = [
    MoodEntryEntity(
      id: "1",
      moodTitle: "Neutral",
      moodId: "neutral",
      date: "August 2",
      time: "16:58",
      note: "The day went calmly, but I feel a bit tired.",
      activities: const [],
      createdAt: DateTime(2026, 8, 2, 16, 58),
    ),
    MoodEntryEntity(
      id: "2",
      moodTitle: "Good",
      moodId: "good",
      date: "August 1",
      time: "14:20",
      note: "Spent some time reading a book. Felt very peaceful.",
      activities: const [],
      createdAt: DateTime(2026, 8, 1, 14, 20),
    ),
    MoodEntryEntity(
      id: "3",
      moodTitle: "Super",
      moodId: "super",
      date: "July 30",
      time: "10:15",
      note: "Amazing day at the beach!",
      activities: const ["Friends", "Sport"],
      createdAt: DateTime(2026, 7, 30, 10, 15),
    ),
    MoodEntryEntity(
      id: "4",
      moodTitle: "Bad",
      moodId: "bad",
      date: "July 15",
      time: "20:00",
      note: "Too much work today.",
      activities: const ["Work"],
      createdAt: DateTime(2026, 7, 15, 20, 0),
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
