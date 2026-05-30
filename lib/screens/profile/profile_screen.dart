import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../services/hive_service.dart';
import '../auth/login_screen.dart';
import '../settings/color_settings_screen.dart';
import '../dreamtoon/upload_dreamtoon_screen.dart';
import '../dreamtoon/dreamtoon_detail_screen.dart';
import 'favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = HiveService.getCurrentUserId();
    final user = userId != null ? HiveService.users.get(userId) : null;
    final myDreamtoons = HiveService.getAllDreamtoons()
        .where((d) => d.artistId == userId)
        .toList();
    // Contar tableros del usuario
    final myBoards = HiveService.getUserBoards(userId ?? '');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Banner
          SliverToBoxAdapter(
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: AppColors.dreamGradient,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 12, right: 16,
                      child: Row(children: [
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  const ColorSettingsScreen()))
                              .then((_) => setState(() {})),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.palette_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            HiveService.setCurrentUserId(null);
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                                    (_) => false);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.logout_rounded,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ]),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80, height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              )],
                            ),
                            child: const Center(
                                child: Text('✨', style: TextStyle(fontSize: 36))),
                          ),
                          const SizedBox(height: 8),
                          Text(user?.username ?? 'Invitada',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(user?.isArtist == true ? '🎨 Artista' : '🌸 Lectora',
                              style: GoogleFonts.poppins(
                                  color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Stats — ahora con tableros reales
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                _statCard('Favoritos',
                    '${user?.favoriteIds.length ?? 0}',
                    AppColors.pinkPastel),
                const SizedBox(width: 12),
                _statCard('Tableros',
                    '${myBoards.length}',
                    AppColors.purplePastel),
                const SizedBox(width: 12),
                _statCard('Siguiendo',
                    '${user?.followingIds.length ?? 0}',
                    AppColors.bluePastel),
              ]),
            ),
          ),

          // Opciones
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                _optionTile(
                  icon: Icons.favorite_rounded,
                  color: AppColors.pinkPastel,
                  label: 'Mis Favoritos',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FavoritesScreen()))
                      .then((_) => setState(() {})),
                ),
                _optionTile(
                  icon: Icons.palette_rounded,
                  color: AppColors.purplePastel,
                  label: 'Cambiar color de la app',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ColorSettingsScreen()))
                      .then((_) => setState(() {})),
                ),
                if (user?.isArtist == true) ...[
                  _optionTile(
                    icon: Icons.add_circle_rounded,
                    color: AppColors.orangePastel,
                    label: 'Publicar DreamToon',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const UploadDreamToonScreen()))
                        .then((_) => setState(() {})),
                  ),
                  _optionTile(
                    icon: Icons.auto_stories_rounded,
                    color: AppColors.mintPastel,
                    label: 'Mis DreamToons (${myDreamtoons.length})',
                    // ✅ AHORA SÍ FUNCIONA - abre lista de mis dreamtoons
                    onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: AppColors.background,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24))),
                      builder: (_) => Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 40, height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.textLight.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Mis DreamToons 🎨',
                                style: GoogleFonts.pacifico(
                                    fontSize: 22, color: AppColors.textDark)),
                            const SizedBox(height: 16),
                            Expanded(
                              child: myDreamtoons.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('📚', style: TextStyle(fontSize: 50)),
                                          const SizedBox(height: 12),
                                          Text('No has publicado nada aún',
                                              style: GoogleFonts.poppins(
                                                  color: AppColors.textLight)),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (_) =>
                                                      const UploadDreamToonScreen()));
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.purplePastel),
                                            child: Text('Publicar mi primer DreamToon',
                                                style: GoogleFonts.poppins(
                                                    color: AppColors.textDark)),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: myDreamtoons.length,
                                      itemBuilder: (_, i) {
                                        final dt = myDreamtoons[i];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) =>
                                                    DreamToonDetailScreen(dreamtoon: dt)));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(bottom: 12),
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [BoxShadow(
                                                color: AppColors.purplePastel.withOpacity(0.1),
                                                blurRadius: 8,
                                              )],
                                            ),
                                            child: Row(children: [
                                              Container(
                                                width: 56, height: 56,
                                                decoration: BoxDecoration(
                                                  gradient: const LinearGradient(
                                                    colors: [AppColors.purplePastel,
                                                      AppColors.pinkPastel],
                                                  ),
                                                  borderRadius: BorderRadius.circular(14),
                                                ),
                                                child: const Center(
                                                    child: Text('✨',
                                                        style: TextStyle(fontSize: 24))),
                                              ),
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(dt.title,
                                                        style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.bold,
                                                            color: AppColors.textDark)),
                                                    Text('${dt.chapterIds.length} capítulos • ${dt.likes} likes',
                                                        style: GoogleFonts.poppins(
                                                            color: AppColors.textLight,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                              const Icon(Icons.arrow_forward_ios_rounded,
                                                  color: AppColors.textLight, size: 16),
                                            ]),
                                          ),
                                        );
                                      }),
                            ),
                          ],
                        ),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                ],
              ]),
            ),
          ),

          // Mis publicaciones en grid
          if (user?.isArtist == true && myDreamtoons.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text('Mis publicaciones',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final dt = myDreamtoons[i];
                    return GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) =>
                              DreamToonDetailScreen(dreamtoon: dt)))
                          .then((_) => setState(() {})),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.lavender, AppColors.purplePastel],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 32)),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(dt.title,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: myDreamtoons.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
              ),
            ),
          ],

          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(children: [
          Text(value,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.textDark)),
          Text(label,
              style: GoogleFonts.poppins(
                  color: AppColors.textMedium, fontSize: 11)),
        ]),
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(
            color: AppColors.purplePastel.withOpacity(0.1),
            blurRadius: 8,
          )],
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(label,
                style: GoogleFonts.poppins(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500)),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              color: AppColors.textLight, size: 16),
        ]),
      ),
    );
  }
}