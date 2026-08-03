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

  Future<void> loadEntries({DateTime? month}) async {
    final DateTime targetMonth = month ?? 
        (state is DiaryLoaded ? (state as DiaryLoaded).selectedMonth : DateTime.now());
    
    emit(DiaryLoading());
    try {
      final allEntries = await getMoodEntries();
      
      // Filter entries by month and year
      final filteredEntries = allEntries.where((entry) {
        return entry.createdAt.month == targetMonth.month && 
               entry.createdAt.year == targetMonth.year;
      }).toList();

      // Sort entries by date (newest first)
      filteredEntries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      emit(DiaryLoaded(
        entries: filteredEntries,
        selectedMonth: DateTime(targetMonth.year, targetMonth.month),
      ));
    } catch (e) {
      emit(const DiaryError("Failed to load entries"));
    }
  }

  Future<void> changeMonth(DateTime newMonth) async {
    await loadEntries(month: newMonth);
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
