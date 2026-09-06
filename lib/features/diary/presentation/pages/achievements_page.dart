import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../domain/entities/mood_entry_entity.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Achievements",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: BlocBuilder<DiaryCubit, DiaryState>(
              builder: (context, state) {
                if (state is DiaryLoaded) {
                  final groups = _calculateAllAchievements(state.allEntries);

                  if (groups.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              DateFormat('MMMM yyyy').format(group['date']),
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: (group['items'] as List).length,
                            itemBuilder: (context, itemIndex) {
                              final achievement = (group['items'] as List)[itemIndex];
                              return GlassCard(
                                padding: const EdgeInsets.all(12),
                                borderRadius: 16,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (achievement['color'] as Color).withOpacity(0.2),
                                      ),
                                      child: Icon(
                                        achievement['icon'] as IconData, 
                                        color: achievement['color'] as Color, 
                                        size: 30
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      achievement['title'] as String,
                                      style: const TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.bold, 
                                        fontSize: 13
                                      ),
                                    ),
                                    Text(
                                      achievement['desc'] as String,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.onSurfaceVariant, 
                                        fontSize: 9
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _calculateAllAchievements(List<MoodEntryEntity> allEntries) {
    if (allEntries.isEmpty) return [];

    // Group entries by month
    final Map<String, List<MoodEntryEntity>> monthlyEntries = {};
    for (var entry in allEntries) {
      final key = DateFormat('yyyy-MM').format(entry.createdAt);
      monthlyEntries.putIfAbsent(key, () => []).add(entry);
    }

    final List<Map<String, dynamic>> achievementGroups = [];

    final sortedKeys = monthlyEntries.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var key in sortedKeys) {
      final monthEntries = monthlyEntries[key]!;
      // Sort entries within month to find earning dates
      monthEntries.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      final List<Map<String, dynamic>> items = [];

      // 1. On Fire (1st entry of the month)
      if (monthEntries.isNotEmpty) {
        items.add({
          'title': 'On Fire',
          'desc': 'Started this month',
          'icon': Icons.local_fire_department,
          'color': AppColors.primary,
          'earnedAt': monthEntries[0].createdAt,
        });
      }

      // 2. Zen Master (7th entry of the month)
      if (monthEntries.length >= 7) {
        items.add({
          'title': 'Zen Master',
          'desc': '7 entries this month',
          'icon': Icons.workspace_premium,
          'color': AppColors.tertiary,
          'earnedAt': monthEntries[6].createdAt,
        });
      }

      // 3. Optimist (5th positive entry)
      final positiveEntries = monthEntries.where((e) => e.moodId == 'super' || e.moodId == 'good').toList();
      if (positiveEntries.length >= 5) {
        items.add({
          'title': 'Optimist',
          'desc': '5 positive days',
          'icon': Icons.auto_awesome,
          'color': AppColors.secondary,
          'earnedAt': positiveEntries[4].createdAt,
        });
      }

      if (items.isNotEmpty) {
        // Sort items by earned date or just keep them
        achievementGroups.add({
          'date': monthEntries[0].createdAt, // To represent the month
          'items': items,
        });
      }
    }

    return achievementGroups;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: AppColors.outline.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            "No achievements yet",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "Track your mood regularly to earn month badges.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
