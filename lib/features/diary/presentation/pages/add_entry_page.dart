import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../cubit/diary_cubit.dart';
import '../../domain/entities/mood_entry_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/glass_card.dart';

class AddEntryPage extends StatefulWidget {
  final MoodEntryEntity? existingEntry;
  const AddEntryPage({super.key, this.existingEntry});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  String? _selectedMoodId;
  final List<String> _selectedActivities = [];
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _selectedMoodId = widget.existingEntry?.moodId;
    if (widget.existingEntry != null) {
      _selectedActivities.addAll(widget.existingEntry!.activities);
    }
    _noteController = TextEditingController(text: widget.existingEntry?.note);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            right: -100,
            top: 200,
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
            child: Column(
              children: [
                // Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mood Section
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "How do you feel?",
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _MoodSelector(
                                selectedId: _selectedMoodId,
                                onSelect: (id) => setState(() => _selectedMoodId = id),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Activities
                        const Text("Activities", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _ActivitiesGrid(
                          selectedList: _selectedActivities,
                          onToggle: (label) {
                            setState(() {
                              if (_selectedActivities.contains(label)) {
                                _selectedActivities.remove(label);
                              } else {
                                _selectedActivities.add(label);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 32),
                        // Note
                        const Text("Note", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        GlassCard(
                          borderRadius: 16,
                          padding: EdgeInsets.zero,
                          child: TextField(
                            controller: _noteController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: "Add a note...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Photo
                        const Text("Photo", style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        if (widget.existingEntry != null && widget.existingEntry!.imageUrls.isNotEmpty) ...[
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.existingEntry!.imageUrls.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, imgIndex) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    widget.existingEntry!.imageUrls[imgIndex],
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        Row(
                          children: [
                            Expanded(child: _PhotoBtn(icon: Icons.photo_camera, label: "Take a photo")),
                            const SizedBox(width: 12),
                            Expanded(child: _PhotoBtn(icon: Icons.image, label: "From gallery")),
                          ],
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Save Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _SaveBtn(
                onTap: () {
                  if (_selectedMoodId != null) {
                    final now = DateTime.now();
                    final entry = MoodEntryEntity(
                      id: widget.existingEntry?.id ?? const Uuid().v4(),
                      moodTitle: _getMoodTitle(_selectedMoodId!),
                      moodId: _selectedMoodId!,
                      date: widget.existingEntry?.date ?? DateFormat('MMMM d').format(now),
                      time: widget.existingEntry?.time ?? DateFormat('HH:mm').format(now),
                      note: _noteController.text,
                      activities: List.from(_selectedActivities),
                      imageUrls: widget.existingEntry?.imageUrls ?? [],
                      createdAt: widget.existingEntry?.createdAt ?? now,
                    );
                    if (widget.existingEntry != null) {
                      context.read<DiaryCubit>().updateEntry(entry);
                    } else {
                      context.read<DiaryCubit>().addEntry(entry);
                    }
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMoodTitle(String id) {
    switch (id) {
      case "super": return "Super";
      case "good": return "Good";
      case "neutral": return "Neutral";
      case "bad": return "Bad";
      case "awful": return "Awful";
      default: return "Neutral";
    }
  }
}

class _MoodSelector extends StatelessWidget {
  final String? selectedId;
  final Function(String) onSelect;

  const _MoodSelector({required this.selectedId, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'id': 'super', 'icon': Icons.sentiment_very_satisfied, 'label': 'Super'},
      {'id': 'good', 'icon': Icons.sentiment_satisfied, 'label': 'Good'},
      {'id': 'neutral', 'icon': Icons.mood, 'label': 'Neutral'},
      {'id': 'bad', 'icon': Icons.sentiment_dissatisfied, 'label': 'Bad'},
      {'id': 'awful', 'icon': Icons.sentiment_very_dissatisfied, 'label': 'Awful'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: moods.map((m) {
        final isSelected = selectedId == m['id'];
        return GestureDetector(
          onTap: () => onSelect(m['id'] as String),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : AppColors.glassBackground,
                  border: isSelected ? null : Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Icon(m['icon'] as IconData, color: isSelected ? Colors.black : AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                m['label'] as String,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ActivitiesGrid extends StatelessWidget {
  final List<String> selectedList;
  final Function(String) onToggle;

  const _ActivitiesGrid({required this.selectedList, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final activities = [
      {'label': 'Family', 'icon': Icons.family_restroom},
      {'label': 'Friends', 'icon': Icons.group},
      {'label': 'Date', 'icon': Icons.favorite},
      {'label': 'Sport', 'icon': Icons.fitness_center},
      {'label': 'Work', 'icon': Icons.work},
      {'label': 'Movie', 'icon': Icons.movie},
      {'label': 'Shop', 'icon': Icons.shopping_basket},
      {'label': 'Other', 'icon': Icons.more_horiz},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final act = activities[index];
        final isSelected = selectedList.contains(act['label']);
        return GestureDetector(
          onTap: () => onToggle(act['label'] as String),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.glassBackground,
                  border: Border.all(color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.05)),
                ),
                child: Icon(act['icon'] as IconData, color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                act['label'] as String,
                style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PhotoBtn extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PhotoBtn({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

class _SaveBtn extends StatelessWidget {
  final VoidCallback onTap;
  const _SaveBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
            ),
            child: const Icon(Icons.check, size: 32, color: Colors.black),
          ),
          const SizedBox(height: 8),
          const Text(
            "SAVE",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
