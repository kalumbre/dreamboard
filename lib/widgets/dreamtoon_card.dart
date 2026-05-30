import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../models/dreamtoon_model.dart';
import '../services/hive_service.dart';
import '../screens/dreamtoon/dreamtoon_detail_screen.dart';

const _cardColors = [
  AppColors.bluePastel, AppColors.purplePastel,
  AppColors.pinkPastel, AppColors.orangePastel,
  AppColors.mintPastel, AppColors.lavender,
];

class DreamToonCard extends StatefulWidget {
  final DreamToonModel dreamtoon;
  const DreamToonCard({required this.dreamtoon, super.key});
  @override
  State<DreamToonCard> createState() => _DreamToonCardState();
}

class _DreamToonCardState extends State<DreamToonCard> {
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    final userId = HiveService.getCurrentUserId();
    if (userId != null) {
      final user = HiveService.users.get(userId);
      _liked = user?.favoriteIds.contains(widget.dreamtoon.id) ?? false;
    }
  }

  void _toggleLike() {
    final userId = HiveService.getCurrentUserId();
    if (userId == null) return;
    final user = HiveService.users.get(userId);
    if (user == null) return;
    setState(() {
      if (_liked) {
        user.favoriteIds.remove(widget.dreamtoon.id);
      } else {
        user.favoriteIds.add(widget.dreamtoon.id);
      }
      _liked = !_liked;
      user.save();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_liked ? '🩷 Guardado en favoritos' : 'Eliminado de favoritos'),
        backgroundColor: _liked ? AppColors.pinkPastel : AppColors.textLight,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildCoverImage(String path, Color color) {
    if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultCover(color));
    } else if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultCover(color));
    } else {
      return Image.file(File(path), fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultCover(color));
    }
  }

  @override
  Widget build(BuildContext context) {
    final idNum = widget.dreamtoon.id.hashCode.abs();
    final color = _cardColors[idNum % _cardColors.length];
    final hasImage = widget.dreamtoon.coverImagePath != null &&
        widget.dreamtoon.coverImagePath!.isNotEmpty &&
        widget.dreamtoon.coverImagePath != 'demo';

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) =>
              DreamToonDetailScreen(dreamtoon: widget.dreamtoon)))
          .then((_) => setState(() {})),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    hasImage
                        ? _buildCoverImage(widget.dreamtoon.coverImagePath!, color)
                        : _defaultCover(color),

                    if (widget.dreamtoon.isFeatured)
                      Positioned(
                        top: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('✨ Top',
                              style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark)),
                        ),
                      ),

                    Positioned(
                      top: 8, right: 8,
                      child: GestureDetector(
                        onTap: _toggleLike,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: _liked
                                ? Colors.pinkAccent.withOpacity(0.9)
                                : Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _liked ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: _liked ? Colors.white : AppColors.textLight,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.dreamtoon.title,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppColors.textDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text('@${widget.dreamtoon.artistName}',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textLight)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.favorite_rounded,
                        size: 12,
                        color: Colors.pinkAccent.withOpacity(0.7)),
                    const SizedBox(width: 4),
                    Text('${widget.dreamtoon.likes}',
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.textMedium)),
                    const SizedBox(width: 8),
                    if (widget.dreamtoon.genres.isNotEmpty)
                      Expanded(
                        child: Text(widget.dreamtoon.genres.first,
                            style: GoogleFonts.poppins(
                                fontSize: 10, color: AppColors.textLight),
                            overflow: TextOverflow.ellipsis),
                      ),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultCover(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withOpacity(0.5)],
        ),
      ),
      child: const Center(
        child: Text('✨', style: TextStyle(fontSize: 48)),
      ),
    );
  }
}