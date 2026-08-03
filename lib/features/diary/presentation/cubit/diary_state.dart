import 'package:equatable/equatable.dart';
import '../../domain/entities/mood_entry_entity.dart';

abstract class DiaryState extends Equatable {
  const DiaryState();

  @override
  List<Object?> get props => [];
}

class DiaryInitial extends DiaryState {}

class DiaryLoading extends DiaryState {}

class DiaryLoaded extends DiaryState {
  final List<MoodEntryEntity> entries;
  final DateTime selectedMonth;

  const DiaryLoaded({
    required this.entries,
    required this.selectedMonth,
  });

  @override
  List<Object?> get props => [entries, selectedMonth];
}

class DiaryError extends DiaryState {
  final String message;
  const DiaryError(this.message);

  @override
  List<Object?> get props => [message];
}
