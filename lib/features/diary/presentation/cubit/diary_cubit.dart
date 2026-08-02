import 'package:flutter_bloc/flutter_bloc.dart';
import 'diary_state.dart';
import '../../domain/entities/mood_entry_entity.dart';
import '../../domain/usecases/get_mood_entries.dart';
import '../../domain/usecases/add_mood_entry.dart';
import '../../domain/usecases/delete_mood_entry.dart';
import '../../domain/usecases/update_mood_entry.dart';

class DiaryCubit extends Cubit<DiaryState> {
  final GetMoodEntries getMoodEntries;
  final AddMoodEntry addMoodEntry;
  final DeleteMoodEntry deleteMoodEntry;
  final UpdateMoodEntry updateMoodEntry;

  DiaryCubit({
    required this.getMoodEntries,
    required this.addMoodEntry,
    required this.deleteMoodEntry,
    required this.updateMoodEntry,
  }) : super(DiaryInitial());

  Future<void> loadEntries() async {
    emit(DiaryLoading());
    try {
      final entries = await getMoodEntries();
      emit(DiaryLoaded(entries));
    } catch (e) {
      emit(const DiaryError("Failed to load entries"));
    }
  }

  Future<void> addEntry(MoodEntryEntity entry) async {
    try {
      await addMoodEntry(entry);
      await loadEntries();
    } catch (e) {
      emit(const DiaryError("Failed to add entry"));
    }
  }

  Future<void> updateEntry(MoodEntryEntity entry) async {
    try {
      await updateMoodEntry(entry);
      await loadEntries();
    } catch (e) {
      emit(const DiaryError("Failed to update entry"));
    }
  }

  Future<void> deleteEntry(String id) async {
    try {
      await deleteMoodEntry(id);
      await loadEntries();
    } catch (e) {
      emit(const DiaryError("Failed to delete entry"));
    }
  }
}
