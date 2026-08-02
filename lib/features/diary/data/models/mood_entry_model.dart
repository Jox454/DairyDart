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
    );
  }

  factory MoodEntryModel.fromJson(Map<String, dynamic> json) {
    return MoodEntryModel(
      id: json['id'],
      moodTitle: json['moodTitle'],
      moodId: json['moodId'],
      date: json['date'],
      time: json['time'],
      note: json['note'],
      activities: List<String>.from(json['activities']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moodTitle': moodTitle,
      'moodId': moodId,
      'date': date,
      'time': time,
      'note': note,
      'activities': activities,
    };
  }
}
