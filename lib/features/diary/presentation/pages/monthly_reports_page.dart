import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../domain/entities/mood_entry_entity.dart';

class MonthlyReportsPage extends StatelessWidget {
  const MonthlyReportsPage({super.key});

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
          "Monthly Reports",
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
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        _buildMonthNavigation(context, state.selectedMonth),
                        const SizedBox(height: 24),
                        _buildTotalEntries(state.entries.length),
                        const SizedBox(height: 24),
                        _buildMoodDistribution(state.entries),
                        const SizedBox(height: 24),
                        _buildMonthlyFluctuations(state.entries, state.selectedMonth),
                        const SizedBox(height: 24),
                        _buildAchievementsSection(state.entries),
                        const SizedBox(height: 24),
                        _buildMonthPhotos(state.entries),
                        const SizedBox(height: 40),
                      ],
                    ),
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

  Widget _buildMoodDistribution(List<MoodEntryEntity> entries) {
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
          const SizedBox(height: 20),
          Text(
            avgScore.toStringAsFixed(1),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            "AVG SCORE",
            style: TextStyle(fontSize: 10, color: AppColors.outline),
          ),
          const SizedBox(height: 20),
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
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(count, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildMonthlyFluctuations(List<MoodEntryEntity> entries, DateTime selectedMonth) {
    final int daysInMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0).day;
    final List<double> scores = [];
    final List<String> labels = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final dayEntries = entries.where((e) => 
        e.createdAt.day == day && 
        e.createdAt.month == selectedMonth.month && 
        e.createdAt.year == selectedMonth.year
      ).toList();

      if (dayEntries.isEmpty) {
        scores.add(0);
      } else {
        double total = 0;
        for (var e in dayEntries) {
          total += _getMoodScore(e.moodId);
        }
        scores.add(total / dayEntries.length);
      }
      
      // Add labels only for some dates to keep it clean
      if (day == 1 || day == 5 || day == 10 || day == 15 || day == 20 || day == 25 || day == daysInMonth) {
        labels.add(day.toString());
      }
    }

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "MONTHLY FLUCTUATIONS",
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1.5),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: _FullMonthChartPainter(scores: scores),
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

  Widget _buildAchievementsSection(List<MoodEntryEntity> monthEntries) {
    final List<Widget> items = [];

    if (monthEntries.length >= 7) {
      items.add(_buildAchievement("Zen Master", Icons.workspace_premium, AppColors.tertiary));
    }
    if (monthEntries.isNotEmpty) {
      items.add(_buildAchievement("On Fire", Icons.local_fire_department, AppColors.primary));
    }
    final positiveCount = monthEntries.where((e) => e.moodId == 'super' || e.moodId == 'good').length;
    if (positiveCount >= 5) {
      items.add(_buildAchievement("Optimist", Icons.auto_awesome, AppColors.secondary));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MONTH ACHIEVEMENTS",
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const GlassCard(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "You don't have any achievements for this month yet. Keep it up!",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
              ),
            ),
          )
        else
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: items,
          ),
      ],
    );
  }

  Widget _buildAchievement(String title, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(8),
      borderRadius: 12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            title, 
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalEntries(int count) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      borderRadius: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total Entries",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            count.toString(),
            style: const TextStyle(color: AppColors.primary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthPhotos(List<MoodEntryEntity> monthEntries) {
    final List<String> allImages = monthEntries
        .expand((e) => e.imageUrls)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MONTH PHOTOS",
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1.5),
        ),
        const SizedBox(height: 12),
        if (allImages.isEmpty)
          const GlassCard(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text(
                "No photos for this month.",
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: allImages.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  allImages[index],
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
      ],
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
}

class _FullMonthChartPainter extends CustomPainter {
  final List<double> scores;

  _FullMonthChartPainter({required this.scores});

  @override
  void paint(Canvas canvas, Size size) {
    if (scores.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
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
      if (scores[i] != 0) {
        points.add(Offset(i * stepX, getY(scores[i])));
      }
    }

    if (points.isEmpty) return;

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);

    final dotPaint = Paint()..color = AppColors.primary;
    for (var point in points) {
      canvas.drawCircle(point, 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FullMonthChartPainter oldDelegate) => oldDelegate.scores != scores;
}
