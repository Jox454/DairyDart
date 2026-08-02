import '../entities/mood_entry_entity.dart';
import '../repositories/diary_repository.dart';

class UpdateMoodEntry {
  final DiaryRepository repository;

  UpdateMoodEntry(this.repository);

  Future<void> call(MoodEntryEntity entry) async {
    return await repository.updateMoodEntry(entry);
  }
}
