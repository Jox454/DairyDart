import '../entities/mood_entry_entity.dart';
import '../repositories/diary_repository.dart';

class AddMoodEntry {
  final DiaryRepository repository;

  AddMoodEntry(this.repository);

  Future<void> call(MoodEntryEntity entry) async {
    return await repository.addMoodEntry(entry);
  }
}
