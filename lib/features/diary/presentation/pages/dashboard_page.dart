import 'package:flutter/material.dart';
import 'mood_tab.dart';
import '../../../../core/theme/app_colors.dart';
import 'add_entry_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<String> _tabs = ["mood", "stats", "journal", "profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background Gradients
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Shared Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.calendar_month, color: AppColors.primary),
                      Text(
                        "MindDiary",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.settings, color: AppColors.primary),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildCurrentTab(_tabs[_currentIndex]),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCurrentTab(String tab) {
    switch (tab) {
      case "mood":
        return const MoodTab();
      case "journal":
        return const Center(child: Text("Journal Tab (Calendar)"));
      case "stats":
        return const Center(child: Text("Stats Tab"));
      case "profile":
        return const Center(child: Text("Profile Tab"));
      default:
        return const MoodTab();
    }
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.mood,
            label: "Mood",
            isSelected: _currentIndex == 0,
            onTap: () => setState(() => _currentIndex = 0),
          ),
          _BottomNavItem(
            icon: Icons.bar_chart,
            label: "Stats",
            isSelected: _currentIndex == 1,
            onTap: () => setState(() => _currentIndex = 1),
          ),
          const SizedBox(width: 64), // Space for FAB
          _BottomNavItem(
            icon: Icons.edit_note,
            label: "Journal",
            isSelected: _currentIndex == 2,
            onTap: () => setState(() => _currentIndex = 2),
          ),
          _BottomNavItem(
            icon: Icons.person,
            label: "Profile",
            isSelected: _currentIndex == 3,
            onTap: () => setState(() => _currentIndex = 3),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Padding(
      padding: const EdgeInsets.only(top: 30), // Adjust alignment manually
      child: SizedBox(
        width: 64,
        height: 64,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddEntryPage()),
            );
          },
          elevation: 8,
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32, color: Colors.black),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = AppColors.onSurfaceVariant;
    
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? activeColor : inactiveColor, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}
