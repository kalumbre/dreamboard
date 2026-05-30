import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/image_post_model.dart';
import '../../services/hive_service.dart';
import '../artist/artist_profile_screen.dart';

const _demoColors = [
  [Color(0xFFD4B8F0), Color(0xFFB8D4F0)],
  [Color(0xFFF0B8D4), Color(0xFFF0D4B8)],
  [Color(0xFFB8F0D4), Color(0xFFB8D4F0)],
  [Color(0xFFE8D5F5), Color(0xFFD4B8F0)],
];
const _demoEmojis = ['🌸', '✨', '🎨', '🌙', '💜', '🌺', '🎀', '⭐'];

class ImageDetailScreen extends StatefulWidget {
  final ImagePostModel image;
  const ImageDetailScreen({required this.image, super.key});
  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  bool _liked = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final userId = HiveService.getCurrentUserId();
    if (userId != null) {
      _liked = widget.image.likedByIds.contains(userId);
    }
  }

  void _toggleLike() {
    final userId = HiveService.getCurrentUserId();
    if (userId == null) return;
    setState(() {
      if (_liked) {
        widget.image.likedByIds.remove(userId);
        widget.image.likes--;
      } else {
        widget.image.likedByIds.add(userId);
        widget.image.likes++;
      }
      _liked = !_liked;
      widget.image.save();
    });
  }

  Widget _buildImage(String path, List<Color> colors, String emoji) {
    if (path == 'demo') {
      return Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 80))),
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 80))),
          ));
    } else if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 80))),
          ));
    } else {
      return Image.file(File(path), fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 80))),
          ));
    }
  }

  void _saveToBoard() {
    final userId = HiveService.getCurrentUserId() ?? '';
    final boards = HiveService.getUserBoards(userId);
    if (boards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Primero crea un tablero en la pestaña Tableros'),
          backgroundColor: AppColors.purplePastel,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.textLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            )),
            const SizedBox(height: 16),
            Text('Guardar en tablero',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark)),
            const SizedBox(height: 12),
            ...boards.map((board) => ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.purplePastel, AppColors.pinkPastel],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text('🗂️')),
              ),
              title: Text(board.name,
                  style: GoogleFonts.poppins(color: AppColors.textDark)),
              subtitle: Text('${board.dreamtoonIds.length} elementos',
                  style: GoogleFonts.poppins(
                      color: AppColors.textLight, fontSize: 12)),
              onTap: () {
                if (!board.imageIds.contains(widget.image.id)) {
                  board.imageIds.add(widget.image.id);
                  board.save();
                }
                setState(() => _saved = true);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📌 Guardado en ${board.name}'),
                    backgroundColor: AppColors.purplePastel,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final idNum = widget.image.id.hashCode.abs();
    final colors = _demoColors[idNum % _demoColors.length];
    final emoji = _demoEmojis[idNum % _demoEmojis.length];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: _buildImage(widget.image.imagePath, colors, emoji),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textDark, size: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.image.title,
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.purplePastel.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(widget.image.category,
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.textMedium)),
                  ),
                  if (widget.image.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(widget.image.description,
                        style: GoogleFonts.poppins(
                            color: AppColors.textMedium,
                            fontSize: 14,
                            height: 1.6)),
                  ],
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) =>
                            ArtistProfileScreen(
                                artistId: widget.image.userId,
                                artistName: widget.image.username))),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(
                          color: AppColors.purplePastel.withOpacity(0.1),
                          blurRadius: 8,
                        )],
                      ),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.purplePastel.withOpacity(0.2),
                          child: Text(
                            widget.image.username[0].toUpperCase(),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                                fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('@${widget.image.username}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark)),
                              Text('Ver perfil →',
                                  style: GoogleFonts.poppins(
                                      color: AppColors.textLight,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        _FollowButton(artistId: widget.image.userId),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _toggleLike,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _liked
                                ? Colors.pinkAccent.withOpacity(0.15)
                                : AppColors.softGray,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _liked ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: _liked ? Colors.pinkAccent : AppColors.textLight,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text('${widget.image.likes}',
                                  style: GoogleFonts.poppins(
                                      color: _liked ? Colors.pinkAccent : AppColors.textMedium,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _saveToBoard,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _saved
                                ? AppColors.purplePastel.withOpacity(0.2)
                                : AppColors.softGray,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _saved ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                color: _saved ? AppColors.purplePastel : AppColors.textLight,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(_saved ? 'Guardado' : 'Guardar',
                                  style: GoogleFonts.poppins(
                                      color: _saved ? AppColors.purplePastel : AppColors.textMedium,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends StatefulWidget {
  final String artistId;
  const _FollowButton({required this.artistId});
  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> {
  bool _following = false;

  @override
  void initState() {
    super.initState();
    final userId = HiveService.getCurrentUserId();
    if (userId != null) {
      _following = HiveService.isFollowing(userId, widget.artistId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = HiveService.getCurrentUserId();
    if (userId == widget.artistId) return const SizedBox();
    return GestureDetector(
      onTap: () {
        if (userId == null) return;
        HiveService.toggleFollow(userId, widget.artistId);
        setState(() => _following = !_following);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_following ? '✨ Siguiendo' : 'Dejaste de seguir'),
            backgroundColor: _following ? AppColors.purplePastel : AppColors.textLight,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: _following ? null : const LinearGradient(
              colors: [AppColors.purplePastel, AppColors.pinkPastel]),
          color: _following ? AppColors.softGray : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _following ? 'Siguiendo ✓' : 'Seguir',
          style: GoogleFonts.poppins(
            color: _following ? AppColors.textMedium : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}