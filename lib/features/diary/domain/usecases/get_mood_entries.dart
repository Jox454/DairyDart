import '../entities/mood_entry_entity.dart';
import '../repositories/diary_repository.dart';

class GetMoodEntries {
  final DiaryRepository repository;

  GetMoodEntries(this.repository);

  Future<List<MoodEntryEntity>> call() async {
    return await repository.getMoodEntries();
  }
}
