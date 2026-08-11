import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'full_screen_image_page.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../widgets/glass_card.dart';
import '../../../../core/theme/app_colors.dart';
import 'add_entry_page.dart';

class MoodTab extends StatelessWidget {
  const MoodTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryCubit, DiaryState>(
      builder: (context, state) {
        if (state is DiaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DiaryLoaded) {
          final now = DateTime.now();
          final bool hasEntryToday = state.allEntries.any((e) => 
            e.createdAt.year == now.year && 
            e.createdAt.month == now.month && 
            e.createdAt.day == now.day
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _buildMonthNavigation(context, state.selectedMonth),
              ),
              if (!hasEntryToday)
                _buildAddEntryCTA(context),
              Expanded(
                child: state.entries.isEmpty 
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                      itemCount: state.entries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final entry = state.entries[index];
                        return MoodEntryCard(entry: entry);
                      },
                    ),
              ),
            ],
          );
        } else if (state is DiaryError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildMonthNavigation(BuildContext context, DateTime selectedMonth) {
    final now = DateTime.now();
    final bool isCurrentMonth = selectedMonth.year == now.year && selectedMonth.month == now.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.primary),
          onPressed: () {
            final prevMonth = DateTime(selectedMonth.year, selectedMonth.month - 1);
            context.read<DiaryCubit>().changeMonth(prevMonth);
          },
        ),
        Text(
          DateFormat('MMMM yyyy').format(selectedMonth),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right, 
            color: isCurrentMonth ? AppColors.outline : AppColors.primary,
          ),
          onPressed: isCurrentMonth ? null : () {
            final nextMonth = DateTime(selectedMonth.year, selectedMonth.month + 1);
            context.read<DiaryCubit>().changeMonth(nextMonth);
          },
        ),
      ],
    );
  }

  Widget _buildAddEntryCTA(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        borderRadius: 16,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_reaction_outlined, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How are you today?",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    "You haven't added a mood yet.",
                    style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddEntryPage()),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.black, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history_edu, size: 64, color: AppColors.outline.withOpacity(0.5)),
              const SizedBox(height: 24),
              const Text(
                "You haven't added anything yet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Switch to another month or start your journey today!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
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
                if (entry.imageUrls.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: entry.imageUrls.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, imgIndex) {
                        final imageUrl = entry.imageUrls[imgIndex];
                        final isNetwork = imageUrl.startsWith('http');
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => FullScreenImagePage(imageUrl: imageUrl)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: isNetwork 
                              ? Image.network(
                                  imageUrl,
                                  width: 120,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
                                )
                              : Image.file(
                                  File(imageUrl),
                                  width: 120,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
                                ),
                          ),
                        );
                      },
                    ),
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
              } else if (value == 'edit') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddEntryPage(existingEntry: entry)),
                );
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

  Widget _buildErrorPlaceholder() {
    return Container(
      width: 120,
      color: AppColors.surfaceVariant,
      child: const Icon(Icons.broken_image_outlined, color: AppColors.outline, size: 24),
    );
  }
}
