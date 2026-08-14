import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_page.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/pages/register_page.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

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
                          // Buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                // Guest
                                _AuthButton(
                                  label: "Continue without account",
                                  icon: Icons.person_outline,
                                  onPressed: () {
                                    context.read<AuthCubit>().continueAsGuest();
                                  },
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.black,
                                ),
                                const SizedBox(height: 12),
                                // Login
                                _AuthButton(
                                  label: "Sign In",
                                  icon: Icons.login,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const LoginPage()),
                                    );
                                  },
                                  backgroundColor: AppColors.surfaceVariant,
                                  foregroundColor: Colors.white,
                                ),
                                const SizedBox(height: 12),
                                // Register
                                _AuthButton(
                                  label: "Register",
                                  icon: Icons.person_add_outlined,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                                    );
                                  },
                                  backgroundColor: AppColors.surfaceVariant.withOpacity(0.5),
                                  foregroundColor: Colors.white70,
                                ),
                              ],
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

class _AuthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const _AuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// Extension to use RoundedCornerShape name if not available or just use generic
RoundedRectangleBorder RoundedCornerShape(double radius) => RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(radius),
);
