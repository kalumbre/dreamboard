import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/image_post_model.dart';
import '../../services/hive_service.dart';
import '../../widgets/dreamtoon_card.dart';
import '../../widgets/image_card.dart';
import '../pinterest/image_detail_screen.dart';

class ArtistProfileScreen extends StatefulWidget {
  final String artistId;
  final String artistName;
  const ArtistProfileScreen({
    required this.artistId,
    required this.artistName,
    super.key,
  });
  @override
  State<ArtistProfileScreen> createState() => _ArtistProfileScreenState();
}

class _ArtistProfileScreenState extends State<ArtistProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  bool _following = false;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    final userId = HiveService.getCurrentUserId();
    if (userId != null) {
      _following = HiveService.isFollowing(userId, widget.artistId);
    }
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _toggleFollow() {
    final userId = HiveService.getCurrentUserId();
    if (userId == null) return;
    HiveService.toggleFollow(userId, widget.artistId);
    setState(() => _following = !_following);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_following ? '✨ Siguiendo a @${widget.artistName}'
            : 'Dejaste de seguir a @${widget.artistName}'),
        backgroundColor: _following
            ? AppColors.purplePastel
            : AppColors.textLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dreamtoons = HiveService.getAllDreamtoons()
        .where((d) => d.artistId == widget.artistId)
        .toList();
    final images = HiveService.getAllImages()
        .where((i) => i.userId == widget.artistId)
        .toList();
    final seguidores = HiveService.getFollowersCount(widget.artistId);
    final isMine = HiveService.getCurrentUserId() == widget.artistId;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.dreamGradient,
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30)),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Back button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Avatar
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.white,
                      child: Text(
                        widget.artistName[0].toUpperCase(),
                        style: GoogleFonts.pacifico(
                            fontSize: 32, color: AppColors.textDark),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('@${widget.artistName}',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    Text('🎨 Artista en DreamBoard',
                        style: GoogleFonts.poppins(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 16),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _stat('$seguidores', 'Seguidores'),
                        const SizedBox(width: 32),
                        _stat('${dreamtoons.length}', 'DreamToons'),
                        const SizedBox(width: 32),
                        _stat('${images.length}', 'Imágenes'),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Botón seguir
                    if (!isMine)
                      GestureDetector(
                        onTap: _toggleFollow,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: _following
                                ? null
                                : const LinearGradient(colors: [
                                    Colors.white,
                                    Colors.white,
                                  ]),
                            color: _following
                                ? Colors.white.withOpacity(0.3)
                                : null,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            _following ? '✓ Siguiendo' : '+ Seguir',
                            style: GoogleFonts.poppins(
                              color: _following
                                  ? Colors.white
                                  : AppColors.textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // TabBar
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TabBar(
                        controller: _tabCtrl,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: AppColors.textDark,
                        unselectedLabelColor: Colors.white70,
                        labelStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 13),
                        dividerColor: Colors.transparent,
                        tabs: const [
                          Tab(text: '📚 DreamToons'),
                          Tab(text: '🖼️ Imágenes'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            // DreamToons del artista
            dreamtoons.isEmpty
                ? Center(
                    child: Text('No ha publicado dreamtoons',
                        style: GoogleFonts.poppins(
                            color: AppColors.textLight)))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: dreamtoons.length,
                    itemBuilder: (_, i) =>
                        DreamToonCard(dreamtoon: dreamtoons[i]),
                  ),

            // Imágenes del artista - grid masonry
            images.isEmpty
                ? Center(
                    child: Text('No ha subido imágenes',
                        style: GoogleFonts.poppins(
                            color: AppColors.textLight)))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: images
                                .asMap()
                                .entries
                                .where((e) => e.key % 2 == 0)
                                .map((e) => ImageCard(
                                    image: e.value,
                                    height: e.key % 4 == 0 ? 200 : 160))
                                .toList(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              ...images
                                  .asMap()
                                  .entries
                                  .where((e) => e.key % 2 == 1)
                                  .map((e) => ImageCard(
                                      image: e.value,
                                      height: e.key % 4 == 1 ? 180 : 150))
                                  .toList(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        Text(label,
            style: GoogleFonts.poppins(
                color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}