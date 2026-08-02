import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';

class MoodTab extends StatelessWidget {
  const MoodTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryCubit, DiaryState>(
      builder: (context, state) {
        if (state is DiaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DiaryLoaded) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: state.entries.length + 1, // +1 for the header
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              if (index == 0) {
                return Text(
                  "Today, August 2",
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              }
              final entry = state.entries[index - 1];
              return MoodEntryCard(entry: entry);
            },
          );
        } else if (state is DiaryError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}

class MoodEntryCard extends StatelessWidget {
  final dynamic entry; // MoodEntryEntity

  const MoodEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceVariant,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getMoodIcon(entry.moodId),
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.moodTitle,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                    Text(
                      "${entry.date}, ${entry.time}",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  entry.note,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (entry.activities.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: entry.activities.map<Widget>((act) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          _getActivityIcon(act),
                          size: 18,
                          color: AppColors.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: AppColors.onSurfaceVariant),
            color: AppColors.surfaceContainer,
            onSelected: (value) {
              if (value == 'delete') {
                context.read<DiaryCubit>().deleteEntry(entry.id);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text("Edit")),
              const PopupMenuItem(value: 'delete', child: Text("Delete", style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
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

  IconData _getActivityIcon(String act) {
    switch (act) {
      case "Family": return Icons.family_restroom;
      case "Friends": return Icons.group;
      case "Date": return Icons.favorite;
      case "Sport": return Icons.fitness_center;
      case "Work": return Icons.work;
      case "Movie": return Icons.movie;
      case "Shop": return Icons.shopping_basket;
      default: return Icons.more_horiz;
    }
  }
}
