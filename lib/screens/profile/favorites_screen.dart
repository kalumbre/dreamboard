import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../services/hive_service.dart';
import '../../widgets/dreamtoon_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = HiveService.getCurrentUserId() ?? '';
    final user = HiveService.users.get(userId);
    final favIds = user?.favoriteIds ?? [];
    final favs = HiveService.getAllDreamtoons()
        .where((d) => favIds.contains(d.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.softGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textDark, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text('Favoritos 🩷',
                      style: GoogleFonts.pacifico(
                          fontSize: 24, color: AppColors.textDark)),
                ],
              ),
            ),
            Expanded(
              child: favs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🩷', style: TextStyle(fontSize: 60)),
                          const SizedBox(height: 16),
                          Text('No tienes favoritos',
                              style: GoogleFonts.poppins(
                                  color: AppColors.textMedium, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text('Dale ❤️ a los dreamtoons que te gusten',
                              style: GoogleFonts.poppins(
                                  color: AppColors.textLight, fontSize: 13)),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: favs.length,
                      itemBuilder: (_, i) => DreamToonCard(dreamtoon: favs[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}