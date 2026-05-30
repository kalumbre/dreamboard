import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../models/dreamtoon_model.dart';
import '../../models/chapter_model.dart';
import '../../services/hive_service.dart';
import '../artist/artist_profile_screen.dart';
import 'reader_screen.dart';
import 'upload_chapter_screen.dart';
import 'upload_dreamtoon_screen.dart';

class DreamToonDetailScreen extends StatefulWidget {
  final DreamToonModel dreamtoon;
  const DreamToonDetailScreen({required this.dreamtoon, super.key});
  @override
  State<DreamToonDetailScreen> createState() => _DreamToonDetailScreenState();
}

class _DreamToonDetailScreenState extends State<DreamToonDetailScreen> {
  bool _liked = false;
  bool _following = false;
  final _picker = ImagePicker();

  List<ChapterModel> get _chapters => HiveService.chapters.values
      .where((c) => c.dreamtoonId == widget.dreamtoon.id)
      .toList()
    ..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));

  bool get _isMyDreamtoon =>
      widget.dreamtoon.artistId == HiveService.getCurrentUserId();

  @override
  void initState() {
    super.initState();
    final userId = HiveService.getCurrentUserId();
    if (userId != null) {
      final user = HiveService.users.get(userId);
      _liked = user?.favoriteIds.contains(widget.dreamtoon.id) ?? false;
      _following = user?.followingIds.contains(widget.dreamtoon.id) ?? false;
    }
  }

  void _toggleLike() {
    final userId = HiveService.getCurrentUserId();
    if (userId == null) return;
    final user = HiveService.users.get(userId);
    if (user == null) return;
    setState(() {
      if (_liked) user.favoriteIds.remove(widget.dreamtoon.id);
      else user.favoriteIds.add(widget.dreamtoon.id);
      _liked = !_liked;
      user.save();
    });
  }

  void _toggleFollow() {
    final userId = HiveService.getCurrentUserId();
    if (userId == null) return;
    final user = HiveService.users.get(userId);
    if (user == null) return;
    setState(() {
      if (_following) user.followingIds.remove(widget.dreamtoon.id);
      else user.followingIds.add(widget.dreamtoon.id);
      _following = !_following;
      user.save();
    });
  }

  // Cambiar portada manualmente
  Future<void> _changeCover() async {
    final img = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (img != null) {
      setState(() {
        widget.dreamtoon.coverImagePath = img.path;
        widget.dreamtoon.save();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('🖼️ Portada actualizada'),
          backgroundColor: AppColors.purplePastel,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dt = widget.dreamtoon;
    final hasImage = dt.coverImagePath != null &&
        dt.coverImagePath!.isNotEmpty &&
        dt.coverImagePath != 'demo';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header con portada
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Imagen de portada o gradiente
                  hasImage
                      ? Image.file(
                          File(dt.coverImagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _gradientHeader(),
                        )
                      : _gradientHeader(),

                  // Overlay oscuro
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black38, Colors.black54],
                      ),
                    ),
                  ),

                  // Botones superiores
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                          const Spacer(),
                          // Botón editar (solo artista dueño)
                          if (_isMyDreamtoon) ...[
                            GestureDetector(
                              onTap: _changeCover,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                    Icons.photo_camera_rounded,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>
                                      UploadDreamToonScreen(
                                          dreamtoon: dt)))
                                  .then((_) => setState(() {})),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(children: [
                                  const Icon(Icons.edit_rounded,
                                      color: Colors.white, size: 16),
                                  const SizedBox(width: 4),
                                  Text('Editar',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 12)),
                                ]),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Título en portada
                  Positioned(
                    bottom: 20, left: 20, right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dt.title,
                            style: GoogleFonts.pacifico(
                                fontSize: 26, color: Colors.white)),
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  ArtistProfileScreen(
                                      artistId: dt.artistId,
                                      artistName: dt.artistName))),
                          child: Text('@${dt.artistName}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white70, fontSize: 14)),
                        ),
                      ],
                    ),
                  ),

                  // Hint cambiar portada si es artista y no tiene imagen
                  if (_isMyDreamtoon && !hasImage)
                    Positioned(
                      bottom: 20, right: 20,
                      child: GestureDetector(
                        onTap: _changeCover,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.purplePastel.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(children: [
                            const Icon(Icons.add_photo_alternate_rounded,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text('Agregar portada',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Info y géneros
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Géneros
                  if (dt.genres.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children: dt.genres.map((g) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.purplePastel.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(g,
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textMedium)),
                      )).toList(),
                    ),
                  const SizedBox(height: 12),

                  // Descripción
                  Text(dt.description,
                      style: GoogleFonts.poppins(
                          color: AppColors.textMedium,
                          fontSize: 14,
                          height: 1.6)),
                  const SizedBox(height: 16),

                  // Acciones
                  Row(children: [
                    _actionBtn(
                      icon: _liked ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      label: _liked ? 'Guardado' : 'Favorito',
                      color: _liked ? Colors.pinkAccent : AppColors.textLight,
                      onTap: _toggleLike,
                    ),
                    const SizedBox(width: 10),
                    _actionBtn(
                      icon: _following ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      label: _following ? 'Siguiendo' : 'Seguir',
                      color: _following
                          ? AppColors.purplePastel
                          : AppColors.textLight,
                      onTap: _toggleFollow,
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // Header capítulos
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Capítulos (${_chapters.length})',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark)),
                      if (_isMyDreamtoon)
                        GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  UploadChapterScreen(dreamtoon: dt)))
                              .then((_) => setState(() {})),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.purplePastel.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('+ Capítulo',
                                style: GoogleFonts.poppins(
                                    color: AppColors.purplePastel,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Lista capítulos
          _chapters.isEmpty
              ? SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(children: [
                        const Text('📖', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text('No hay capítulos aún',
                            style: GoogleFonts.poppins(
                                color: AppColors.textLight)),
                        if (_isMyDreamtoon)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>
                                      UploadChapterScreen(dreamtoon: dt)))
                                  .then((_) => setState(() {})),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.purplePastel),
                              child: Text('Subir primer capítulo',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white)),
                            ),
                          ),
                      ]),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) {
                      final ch = _chapters[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                ReaderScreen(chapter: ch))),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
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
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.purplePastel,
                                    AppColors.pinkPastel],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text('${ch.chapterNumber}',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ch.title,
                                      style: GoogleFonts.poppins(
                                          color: AppColors.textDark,
                                          fontWeight: FontWeight.w600)),
                                  Text('${ch.imagePaths.length} páginas',
                                      style: GoogleFonts.poppins(
                                          color: AppColors.textLight,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            const Icon(Icons.play_circle_rounded,
                                color: AppColors.purplePastel, size: 28),
                          ]),
                        ),
                      );
                    },
                    childCount: _chapters.length,
                  ),
                ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 30)),
        ],
      ),
    );
  }

  Widget _gradientHeader() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.dreamGradient),
      child: const Center(child: Text('✨', style: TextStyle(fontSize: 80))),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.poppins(color: color, fontSize: 13)),
        ]),
      ),
    );
  }
}