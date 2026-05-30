import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../models/image_post_model.dart';
import '../services/hive_service.dart';
import '../screens/pinterest/image_detail_screen.dart';

const _demoColors = [
  [Color(0xFFD4B8F0), Color(0xFFB8D4F0)],
  [Color(0xFFF0B8D4), Color(0xFFF0D4B8)],
  [Color(0xFFB8F0D4), Color(0xFFB8D4F0)],
  [Color(0xFFE8D5F5), Color(0xFFD4B8F0)],
  [Color(0xFFF0D4B8), Color(0xFFF0B8D4)],
];
const _demoEmojis = ['🌸', '✨', '🎨', '🌙', '💜', '🌺', '🎀', '⭐'];

class ImageCard extends StatefulWidget {
  final ImagePostModel image;
  final double height;
  const ImageCard({required this.image, this.height = 180, super.key});
  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _liked = false;

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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
      );
    } else if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
          ));
    } else if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
          ));
    } else {
      return Image.file(File(path), fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 48))),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final idNum = widget.image.id.hashCode.abs();
    final colors = _demoColors[idNum % _demoColors.length];
    final emoji = _demoEmojis[idNum % _demoEmojis.length];

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) =>
              ImageDetailScreen(image: widget.image)))
          .then((_) => setState(() {})),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildImage(widget.image.imagePath, colors, emoji),

              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(widget.image.title,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      GestureDetector(
                        onTap: _toggleLike,
                        child: Row(children: [
                          Icon(
                            _liked ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: _liked ? Colors.pinkAccent : Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text('${widget.image.likes}',
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 11)),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(widget.image.category,
                      style: GoogleFonts.poppins(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}