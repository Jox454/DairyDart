import '../../domain/entities/mood_entry_entity.dart';

class MoodEntryModel extends MoodEntryEntity {
  const MoodEntryModel({
    required super.id,
    required super.moodTitle,
    required super.moodId,
    required super.date,
    required super.time,
    required super.note,
    required super.activities,
    required super.imageUrls,
    required super.createdAt,
  });

  factory MoodEntryModel.fromEntity(MoodEntryEntity entity) {
    return MoodEntryModel(
      id: entity.id,
      moodTitle: entity.moodTitle,
      moodId: entity.moodId,
      date: entity.date,
      time: entity.time,
      note: entity.note,
      activities: entity.activities,
      imageUrls: entity.imageUrls,
      createdAt: entity.createdAt,
    );
  }

  factory MoodEntryModel.fromJson(Map<String, dynamic> json) {
    return MoodEntryModel(
      id: json['id'],
      moodTitle: json['mood_title'],
      moodId: json['mood_id'],
      date: json['date'],
      time: json['time'],
      note: json['note'] ?? "",
      activities: List<String>.from(json['activities'] ?? []),
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood_title': moodTitle,
      'mood_id': moodId,
      'date': date,
      'time': time,
      'note': note,
      'activities': activities,
      'image_urls': imageUrls,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
