import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../widgets/glass_card.dart';
import '../../domain/entities/mood_entry_entity.dart';
import '../../../../core/theme/app_colors.dart';

class JournalTab extends StatelessWidget {
  const JournalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryCubit, DiaryState>(
      builder: (context, state) {
        if (state is DiaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DiaryLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today, ${DateFormat('MMMM d').format(DateTime.now())}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                _buildCalendar(context, state),
                const SizedBox(height: 24),
                _buildMoodDistribution(state.entries),
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildCalendar(BuildContext context, DiaryLoaded state) {
    final now = DateTime.now();
    final bool isCurrentMonth = state.selectedMonth.year == now.year && 
                                state.selectedMonth.month == now.month;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(state.selectedMonth).toUpperCase(),
                style: const TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
                    onPressed: () {
                      final prevMonth = DateTime(state.selectedMonth.year, state.selectedMonth.month - 1);
                      context.read<DiaryCubit>().changeMonth(prevMonth);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right, 
                      color: isCurrentMonth ? AppColors.outline : AppColors.onSurfaceVariant,
                    ),
                    onPressed: isCurrentMonth ? null : () {
                      final nextMonth = DateTime(state.selectedMonth.year, state.selectedMonth.month + 1);
                      context.read<DiaryCubit>().changeMonth(nextMonth);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCalendarGrid(state),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DiaryLoaded state) {
    final List<String> weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
    final DateTime firstDayOfMonth = DateTime(state.selectedMonth.year, state.selectedMonth.month, 1);
    final int firstWeekday = firstDayOfMonth.weekday; // 1 (Mon) to 7 (Sun)
    
    // Calculate days from previous month to show
    final int daysBefore = firstWeekday - 1;
    final DateTime prevMonthEnd = firstDayOfMonth.subtract(const Duration(days: 1));
    
    // Calculate total days in current month
    final int daysInMonth = DateTime(state.selectedMonth.year, state.selectedMonth.month + 1, 0).day;

    // Group entries by day, keeping the latest one
    final Map<int, MoodEntryEntity> latestEntriesByDay = {};
    for (var entry in state.entries) {
      final day = entry.createdAt.day;
      if (!latestEntriesByDay.containsKey(day) || entry.createdAt.isAfter(latestEntriesByDay[day]!.createdAt)) {
        latestEntriesByDay[day] = entry;
      }
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdays
              .map((d) => Text(d, style: const TextStyle(color: AppColors.outline, fontSize: 12)))
              .toList(),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 5,
            childAspectRatio: 0.8, // Adjusted to fit number under icon
          ),
          itemCount: daysBefore + daysInMonth,
          itemBuilder: (context, index) {
            if (index < daysBefore) {
              final day = prevMonthEnd.day - (daysBefore - index - 1);
              return _buildCalendarDay(day.toString(), null, isCurrentMonth: false);
            } else {
              final day = index - daysBefore + 1;
              final entry = latestEntriesByDay[day];
              return _buildCalendarDay(day.toString(), entry, isCurrentMonth: true);
            }
          },
        ),
      ],
    );
  }

  Widget _buildCalendarDay(String dayLabel, MoodEntryEntity? entry, {required bool isCurrentMonth}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: entry != null ? AppColors.surfaceVariant : Colors.transparent,
            border: entry != null ? Border.all(color: Colors.white.withOpacity(0.05)) : null,
          ),
          child: Center(
            child: entry != null 
                ? Icon(_getMoodIcon(entry.moodId), size: 18, color: AppColors.primary)
                : const SizedBox(),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dayLabel,
          style: TextStyle(
            color: isCurrentMonth ? Colors.white : AppColors.outline,
            fontSize: 10,
            fontWeight: entry != null ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildMoodDistribution(List<MoodEntryEntity> entries) {
    // Calculate real stats
    final Map<String, int> counts = {
      'super': 0,
      'good': 0,
      'neutral': 0,
      'bad': 0,
      'awful': 0,
    };
    
    double totalScore = 0;
    for (var entry in entries) {
      counts[entry.moodId] = (counts[entry.moodId] ?? 0) + 1;
      totalScore += _getMoodScore(entry.moodId);
    }
    
    final avgScore = entries.isEmpty ? 0.0 : totalScore / entries.length;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "MOOD DISTRIBUTION",
            style: TextStyle(
              color: AppColors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            avgScore.toStringAsFixed(1),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            "AVG SCORE",
            style: TextStyle(fontSize: 10, color: AppColors.outline),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodStat(Icons.sentiment_very_satisfied, counts['super'].toString(), AppColors.tertiary),
              _buildMoodStat(Icons.sentiment_satisfied, counts['good'].toString(), AppColors.tertiary),
              _buildMoodStat(Icons.sentiment_neutral, counts['neutral'].toString(), Colors.blue),
              _buildMoodStat(Icons.sentiment_dissatisfied, counts['bad'].toString(), AppColors.outline),
              _buildMoodStat(Icons.sentiment_very_dissatisfied, counts['awful'].toString(), Colors.redAccent),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMoodStat(IconData icon, String count, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(count, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  IconData _getMoodIcon(String id) {
    switch (id) {
      case "super": return Icons.sentiment_very_satisfied;
      case "good": return Icons.sentiment_satisfied;
      case "neutral": return Icons.mood;
      case "bad": return Icons.sentiment_dissatisfied;
      case "awful": return Icons.sentiment_very_dissatisfied;
      default: return Icons.mood;
    }
  }

  double _getMoodScore(String id) {
    switch (id) {
      case "super": return 5;
      case "good": return 4;
      case "neutral": return 3;
      case "bad": return 2;
      case "awful": return 1;
      default: return 3;
    }
  }
}
