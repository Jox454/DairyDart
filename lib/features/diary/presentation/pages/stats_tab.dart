import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/glass_card.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _buildMonthNavigation(),
          const SizedBox(height: 24),
          _buildStreakSection(),
          const SizedBox(height: 24),
          _buildMoodFluctuations(),
          const SizedBox(height: 24),
          _buildAchievementsSection(),
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildMonthNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: AppColors.primary),
          onPressed: () {},
        ),
        const Text(
          "July 2026",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: AppColors.primary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildStreakSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "STREAK",
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1.5),
            ),
            Text(
              "4 Days Row",
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(16),
          borderRadius: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStreakDay("Mon", true),
              _buildStreakDay("Tue", true),
              _buildStreakDay("Wed", true),
              _buildStreakDay("Thu", true),
              _buildStreakDay("Fri", false, dayNum: "17"),
              _buildStreakDay("Sat", false, dayNum: "18"),
            ],
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

  Widget _buildMoodFluctuations() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
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
              painter: _MoodChartPainter(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["28", "29", "30", "31", "01", "02", "03"]
                .map((d) => Text(d, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "ACHIEVEMENTS",
          style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12, letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildAchievement("Zen Master", "7 days of meditation", Icons.workspace_premium, AppColors.tertiary),
            _buildAchievement("On Fire", "Longest streak ever", Icons.local_fire_department, AppColors.primary),
            _buildAchievement("Philosopher", "Write 50 journals", Icons.psychology, AppColors.onSurfaceVariant, isLocked: true),
            _buildAchievement("Optimist", "10 Good days in a row", Icons.auto_awesome, AppColors.secondary),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievement(String title, String desc, IconData icon, Color color, {bool isLocked = false}) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 16,
      child: Opacity(
        opacity: isLocked ? 0.5 : 1.0,
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
      ),
    );
  }
}

class _MoodChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.15, size.height * 0.4),
      Offset(size.width * 0.3, size.height * 0.7),
      Offset(size.width * 0.45, size.height * 0.3),
      Offset(size.width * 0.6, size.height * 0.6),
      Offset(size.width * 0.75, size.height * 0.4),
      Offset(size.width, size.height * 0.5),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    // Gradient fill
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

    // Draw points
    final dotPaint = Paint()..color = AppColors.primary;
    for (var point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
