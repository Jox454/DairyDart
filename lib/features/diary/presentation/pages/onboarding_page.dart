import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glow
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Header
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "MindDiary",
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.glassBackground,
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.language, color: AppColors.primary, size: 20),
                                      SizedBox(width: 8),
                                      Text("English", style: TextStyle(color: AppColors.onSurface)),
                                      SizedBox(width: 8),
                                      Icon(Icons.expand_more, color: AppColors.onSurfaceVariant, size: 20),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 2),
                          // Illustration
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: AspectRatio(
                              aspectRatio: 1.2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  'assets/images/onboarding_photo.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppColors.surfaceVariant.withOpacity(0.3),
                                    child: const Center(child: Text("Illustration Placeholder")),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Typography
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: Theme.of(context).textTheme.headlineLarge,
                                    children: [
                                      const TextSpan(text: "Express your mood \n"),
                                      const TextSpan(
                                        text: "with emojis",
                                        style: TextStyle(color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Record your moods and experiences using the language of emojis, without the need to write anything. Uncover patterns and cherish every moment.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                          // Button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: RoundedCornerShape(12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Get Started", style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Spacer(flex: 1),
                          // Footer
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Terms of Service", style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                                    SizedBox(width: 24),
                                    Text("Privacy Policy", style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "By using this application, you agree to the Terms of Service.",
                                  style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                                ),
                                SizedBox(height: 4),
                                Text("© 2026 MindDiary Inc.", style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to use RoundedCornerShape name if not available or just use generic
RoundedRectangleBorder RoundedCornerShape(double radius) => RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(radius),
);
