import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/mood_entry_entity.dart';
import '../../domain/repositories/diary_repository.dart';
import '../models/mood_entry_model.dart';

class SupabaseDiaryRepositoryImpl implements DiaryRepository {
  final SupabaseClient _supabase;

  SupabaseDiaryRepositoryImpl(this._supabase);

  // Fallback for guest mode (in-memory for now)
  final List<MoodEntryEntity> _guestEntries = [];

  @override
  Future<List<MoodEntryEntity>> getMoodEntries() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return List.from(_guestEntries);

    final response = await _supabase
        .from('mood_entries')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).map((json) => MoodEntryModel.fromJson(json)).toList();
  }

  @override
  Future<void> addMoodEntry(MoodEntryEntity entry) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _guestEntries.insert(0, entry);
      return;
    }

    final uploadedUrls = await _uploadImages(entry.imageUrls, user.id);
    final model = MoodEntryModel.fromEntity(entry).toJson();
    model['image_urls'] = uploadedUrls;
    model['user_id'] = user.id;

    await _supabase.from('mood_entries').insert(model);
  }

  @override
  Future<void> updateMoodEntry(MoodEntryEntity entry) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      final index = _guestEntries.indexWhere((e) => e.id == entry.id);
      if (index != -1) _guestEntries[index] = entry;
      return;
    }

    final uploadedUrls = await _uploadImages(entry.imageUrls, user.id);
    final model = MoodEntryModel.fromEntity(entry).toJson();
    model['image_urls'] = uploadedUrls;

    await _supabase.from('mood_entries').update(model).eq('id', entry.id);
  }

  @override
  Future<void> deleteMoodEntry(String id) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      _guestEntries.removeWhere((e) => e.id == id);
      return;
    }

    await _supabase.from('mood_entries').delete().eq('id', id);
  }

  Future<List<String>> _uploadImages(List<String> paths, String userId) async {
    final List<String> finalUrls = [];

    for (final path in paths) {
      if (path.startsWith('http')) {
        finalUrls.add(path);
        continue;
      }

      final file = File(path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.split('/').last}';
      final storagePath = '$userId/$fileName';

      await _supabase.storage.from('mood_photos').upload(storagePath, file);
      
      final publicUrl = _supabase.storage.from('mood_photos').getPublicUrl(storagePath);
      finalUrls.add(publicUrl);
    }

    return finalUrls;
  }
}
