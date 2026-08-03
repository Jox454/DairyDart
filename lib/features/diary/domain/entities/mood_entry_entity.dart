import 'package:equatable/equatable.dart';

class MoodEntryEntity extends Equatable {
  final String id;
  final String moodTitle;
  final String moodId;
  final String date;
  final String time;
  final String note;
  final List<String> activities;
  final DateTime createdAt;

  const MoodEntryEntity({
    required this.id,
    required this.moodTitle,
    required this.moodId,
    required this.date,
    required this.time,
    required this.note,
    required this.activities,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, moodTitle, moodId, date, time, note, activities, createdAt];
}
