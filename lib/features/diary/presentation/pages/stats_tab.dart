import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../domain/entities/mood_entry_entity.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiaryCubit, DiaryState>(
      builder: (context, state) {
        if (state is DiaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DiaryLoaded) {
          final activeDates = state.allEntries.map((e) {
            return DateFormat('yyyy-MM-dd').format(e.createdAt);
          }).toSet();
          
          final streak = _calculateStreak(activeDates);
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                _buildMonthDisplay(state.selectedMonth),
                const SizedBox(height: 24),
                _buildStreakSection(streak, activeDates),
                const SizedBox(height: 24),
                _buildMoodFluctuations(state.allEntries),
                const SizedBox(height: 24),
                _buildAchievementsSection(state.entries),
                const SizedBox(height: 100), // Space for bottom bar
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  int _calculateStreak(Set<String> activeDates) {
    if (activeDates.isEmpty) return 0;
    
    int streak = 0;
    DateTime dateToCheck = DateTime.now();

    if (!activeDates.contains(DateFormat('yyyy-MM-dd').format(dateToCheck))) {
      dateToCheck = dateToCheck.subtract(const Duration(days: 1));
    }

    while (activeDates.contains(DateFormat('yyyy-MM-dd').format(dateToCheck))) {
      streak++;
      dateToCheck = dateToCheck.subtract(const Duration(days: 1));
    }

    return streak;
  }

  Widget _buildMonthDisplay(DateTime selectedMonth) {
    return Center(
      child: Text(
        DateFormat('MMMM yyyy').format(selectedMonth),
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildStreakSection(int streakCount, Set<String> activeDates) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> days = [];
    for (int i = 5; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      days.add({
        'label': DateFormat('E').format(date),
        'dayNum': date.day.toString(),
        'isDone': activeDates.contains(dateStr), 
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "STREAK",
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1.5),
            ),
            Text(
              "$streakCount Days Row",
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((d) => _buildStreakDay(d['label'], d['isDone'], dayNum: d['dayNum'])).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakDay(String label, bool isDone, {String? dayNum}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? AppColors.secondaryContainer : Colors.transparent,
            border: isDone ? null : Border.all(color: AppColors.outline),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_circle, color: AppColors.onSecondaryContainer, size: 24)
                : Text(dayNum ?? "", style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodFluctuations(List<MoodEntryEntity> entries) {
    final now = DateTime.now();
    final List<double> scores = [];
    final List<String> labels = [];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      labels.add(DateFormat('dd').format(date));

      final dayEntries = entries.where((e) => DateFormat('yyyy-MM-dd').format(e.createdAt) == dateStr).toList();
      if (dayEntries.isEmpty) {
        scores.add(0);
      } else {
        double total = 0;
        for (var e in dayEntries) {
          total += _getMoodScore(e.moodId);
        }
        scores.add(total / dayEntries.length);
      }
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MOOD FLUCTUATIONS",
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1.5),
              ),
              Icon(Icons.trending_up, color: AppColors.tertiary),
            ],
          ),
          const Text("Past 7 Days", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: CustomPaint(
              painter: _MoodChartPainter(scores: scores),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map((d) => Text(d, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)))
                .toList(),
          )
        ],
      ),
    );
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

  Widget _buildAchievementsSection(List<MoodEntryEntity> monthEntries) {
    final List<Widget> unlockedAchievements = [];

    // Zen Master: 7+ entries in the month
    if (monthEntries.length >= 7) {
      unlockedAchievements.add(_buildAchievement("Zen Master", "7 entries this month", Icons.workspace_premium, AppColors.tertiary));
    }

    // On Fire: at least 1 entry in the month
    if (monthEntries.isNotEmpty) {
      unlockedAchievements.add(_buildAchievement("On Fire", "Started this month", Icons.local_fire_department, AppColors.primary));
    }

    // Optimist: 5+ Good or Super entries in the month
    final positiveCount = monthEntries.where((e) => e.moodId == 'super' || e.moodId == 'good').length;
    if (positiveCount >= 5) {
      unlockedAchievements.add(_buildAchievement("Optimist", "5 positive days", Icons.auto_awesome, AppColors.secondary));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MONTH ACHIEVEMENTS",
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        if (unlockedAchievements.isEmpty)
          _buildEmptyAchievements()
        else
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: unlockedAchievements,
          ),
      ],
    );
  }

  Widget _buildEmptyAchievements() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      borderRadius: 16,
      child: Center(
        child: Column(
          children: [
            Icon(Icons.emoji_events_outlined, size: 48, color: AppColors.outline.withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              "No achievements yet",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              "Keep tracking your mood to unlock special month badges!",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievement(String title, String desc, IconData icon, Color color) {
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
              color: color.withOpacity(0.2),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 9)),
        ],
      ),
    );
  }
}

class _MoodChartPainter extends CustomPainter {
  final List<double> scores;

  _MoodChartPainter({required this.scores});

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double stepX = size.width / (scores.length - 1);
    
    double getY(double score) {
      if (score == 0) return size.height;
      return size.height - ((score - 1) / 4 * size.height * 0.8 + size.height * 0.1);
    }

    final List<Offset> points = [];
    for (int i = 0; i < scores.length; i++) {
      points.add(Offset(i * stepX, getY(scores[i])));
    }

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.primary.withOpacity(0.4), AppColors.primary.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = AppColors.primary;
    final dotBorderPaint = Paint()
      ..color = AppColors.background
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 5, dotBorderPaint);
      canvas.drawCircle(point, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MoodChartPainter oldDelegate) => oldDelegate.scores != scores;
}
