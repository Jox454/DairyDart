import '../entities/mood_entry_entity.dart';

abstract class DiaryRepository {
  Future<List<MoodEntryEntity>> getMoodEntries();
  Future<void> addMoodEntry(MoodEntryEntity entry);
  Future<void> updateMoodEntry(MoodEntryEntity entry);
  Future<void> deleteMoodEntry(String id);
}
