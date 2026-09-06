import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/glass_card.dart';
import 'photo_gallery_page.dart';
import 'achievements_page.dart';
import 'monthly_reports_page.dart';

class ProfileTab extends StatelessWidget {
  final VoidCallback onMoodTabRequested;
  final bool isRemindersEnabled;
  final ValueChanged<bool> onRemindersChanged;

  const ProfileTab({
    super.key,
    required this.onMoodTabRequested,
    required this.isRemindersEnabled,
    required this.onRemindersChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 24),
          _buildProfileItems(context),
          const SizedBox(height: 24),
          _buildPremiumBanner(),
          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300?img=32'), // Mock image
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          Supabase.instance.client.auth.currentUser?.email ?? "Guest User",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const Text(
          "Inner Peace Seeker",
          style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildProfileItems(BuildContext context) {
    return Column(
      children: [
        _buildItem(
          Icons.analytics_outlined, 
          "Monthly Reports", 
          iconColor: Colors.blueAccent,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MonthlyReportsPage()),
            );
          },
        ),
        _buildItem(
          Icons.photo_library_outlined, 
          "Photo Gallery", 
          iconColor: Colors.tealAccent,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PhotoGalleryPage()),
            );
          },
        ),
        _buildItem(
          Icons.military_tech_outlined, 
          "Achievements", 
          iconColor: Colors.orangeAccent,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AchievementsPage()),
            );
          },
        ),
        _buildItem(
          Icons.notifications_none, 
          "Reminders", 
          isSwitch: true, 
          switchValue: isRemindersEnabled,
          onSwitchChanged: onRemindersChanged,
          iconColor: Colors.deepPurple,
          onTap: () {},
        ),
        _buildItem(
          Icons.sentiment_satisfied_alt, 
          "Edit Moods", 
          iconColor: Colors.blue,
          onTap: onMoodTabRequested,
        ),
        const SizedBox(height: 12),
        _buildItem(
          Icons.logout, 
          "Logout", 
          iconColor: Colors.redAccent,
          onTap: () {
            context.read<AuthCubit>().signOut();
          },
        ),
      ],
    );
  }

  Widget _buildItem(
    IconData icon, 
    String title, {
    bool isSwitch = false, 
    bool switchValue = false,
    ValueChanged<bool>? onSwitchChanged,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: isSwitch ? null : onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          borderRadius: 16,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor ?? AppColors.primary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              if (isSwitch)
                Switch(
                  value: switchValue,
                  onChanged: onSwitchChanged,
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.primary,
                )
              else
                const Icon(Icons.chevron_right, color: AppColors.outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF7E57C2), Color(0xFF2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Go Premium",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Unlock detailed insights,\nunlimited moods, and cloud\nbackup.",
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Upgrade Now", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
