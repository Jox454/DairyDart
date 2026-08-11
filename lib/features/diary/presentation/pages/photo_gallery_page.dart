import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'full_screen_image_page.dart';
import '../cubit/diary_cubit.dart';
import '../cubit/diary_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/glass_card.dart';

class PhotoGalleryPage extends StatelessWidget {
  const PhotoGalleryPage({super.key});

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
          "Photo Gallery",
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
                  final entriesWithImages = state.allEntries
                      .where((e) => e.imageUrls.isNotEmpty)
                      .toList();

                  if (entriesWithImages.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: entriesWithImages.length,
                    itemBuilder: (context, index) {
                      final entry = entriesWithImages[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              DateFormat('MMMM d, yyyy').format(entry.createdAt),
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
                              childAspectRatio: 1.3,
                            ),
                            itemCount: entry.imageUrls.length,
                            itemBuilder: (context, gridIndex) {
                              final imageUrl = entry.imageUrls[gridIndex];
                              final isNetwork = imageUrl.startsWith('http');
                              
                              return GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => FullScreenImagePage(imageUrl: imageUrl)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    color: AppColors.surfaceVariant.withOpacity(0.1),
                                    child: isNetwork 
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child, loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Container(
                                              color: AppColors.surfaceVariant,
                                              child: const Center(
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            );
                                          },
                                          errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
                                        )
                                      : Image.file(
                                          File(imageUrl),
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
                                        ),
                                  ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_photography_outlined, size: 64, color: AppColors.outline.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            "No photos yet",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add photos to your mood entries to see them here.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return const Center(
      child: Icon(Icons.cloud_off_outlined, color: AppColors.outline, size: 24),
    );
  }
}
