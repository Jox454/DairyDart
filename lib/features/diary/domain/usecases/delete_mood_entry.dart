import '../repositories/diary_repository.dart';

class DeleteMoodEntry {
  final DiaryRepository repository;

  DeleteMoodEntry(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteMoodEntry(id);
  }
}
