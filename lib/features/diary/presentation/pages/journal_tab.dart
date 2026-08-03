import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/glass_card.dart';

class JournalTab extends StatelessWidget {
  const JournalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today, July 30",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          _buildCalendar(),
          const SizedBox(height: 24),
          _buildMoodDistribution(),
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "JULY 2026",
                style: TextStyle(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: AppColors.onSurfaceVariant),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final List<String> weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdays
              .map((d) => Text(d, style: const TextStyle(color: AppColors.outline, fontSize: 12)))
              .toList(),
        ),
        const SizedBox(height: 12),
        // Mocking the grid from screenshot
        _buildCalendarRow(["29", "30", "1", "2", "3", "4", "5"], [false, false, false, false, false, false, false]),
        _buildCalendarRow(["6", "7", "8", "9", "10", "11", "12"], [true, false, true, false, false, false, false], moods: {0: Icons.sentiment_very_satisfied, 2: Icons.sentiment_satisfied}),
        _buildCalendarRow(["13", "14", "15", "16", "17", "18", "19"], [false, false, false, false, false, false, false]),
        _buildCalendarRow(["20", "21", "22", "23", "24", "25", "26"], [false, false, false, false, false, false, false]),
        _buildCalendarRow(["27", "28", "29", "30", "31", "1", "2"], [false, false, false, true, true, false, false], selected: [3, 4]),
      ],
    );
  }

  Widget _buildCalendarRow(List<String> days, List<bool> hasMood, {Map<int, IconData>? moods, List<int>? selected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (index) {
          final bool isSelected = selected?.contains(index) ?? false;
          final bool mood = hasMood[index];
          
          return Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              shape: BoxShape.circle,
              border: mood && !isSelected ? Border.all(color: Colors.white.withOpacity(0.1), width: 1) : null,
            ),
            child: Center(
              child: mood && !isSelected
                  ? Icon(moods?[index] ?? Icons.sentiment_neutral, size: 20, color: AppColors.tertiary)
                  : Text(
                      days[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : (int.tryParse(days[index])! > 25 && days.first == "29" || int.tryParse(days[index])! < 10 && days.last == "2" ? AppColors.outline : Colors.white),
                        fontSize: 13,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMoodDistribution() {
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
          const Text(
            "2",
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            "AVG SCORE",
            style: TextStyle(fontSize: 10, color: AppColors.outline),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodStat(Icons.sentiment_very_satisfied, "12", AppColors.tertiary),
              _buildMoodStat(Icons.sentiment_satisfied, "8", AppColors.tertiary),
              _buildMoodStat(Icons.sentiment_neutral, "5", Colors.blue),
              _buildMoodStat(Icons.sentiment_dissatisfied, "2", AppColors.outline),
              _buildMoodStat(Icons.sentiment_very_dissatisfied, "0", Colors.redAccent),
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
}
