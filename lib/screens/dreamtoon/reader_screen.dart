import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/chapter_model.dart';
import '../../models/comment_model.dart';
import '../../services/hive_service.dart';

class ReaderScreen extends StatefulWidget {
  final ChapterModel chapter;
  const ReaderScreen({required this.chapter, super.key});
  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  bool _showUI = true;
  bool _liked = false;
  final _commentCtrl = TextEditingController();

  List<CommentModel> get _comments =>
      HiveService.getChapterComments(widget.chapter.id);

  void _addComment() {
    if (_commentCtrl.text.isEmpty) return;
    final userId = HiveService.getCurrentUserId() ?? '';
    final user = HiveService.users.get(userId);
    final comment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chapterId: widget.chapter.id,
      userId: userId,
      username: user?.username ?? 'Anónima',
      text: _commentCtrl.text,
    );
    HiveService.comments.put(comment.id, comment);
    _commentCtrl.clear();
    setState(() {});
  }

  void _showComments() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(ctx).size.height * 0.7,
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
                Text('Comentarios 💬',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentCtrl,
                        decoration: InputDecoration(
                          hintText: 'Escribe un comentario...',
                          hintStyle: GoogleFonts.poppins(
                              color: AppColors.textLight, fontSize: 13),
                          filled: true,
                          fillColor: AppColors.softGray,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        _addComment();
                        setModalState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.purplePastel, AppColors.pinkPastel],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.send_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _comments.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('💬', style: TextStyle(fontSize: 40)),
                              const SizedBox(height: 12),
                              Text('Sé la primera en comentar',
                                  style: GoogleFonts.poppins(
                                      color: AppColors.textLight)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _comments.length,
                          itemBuilder: (_, i) {
                            final c = _comments[i];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(
                                  color: AppColors.purplePastel.withOpacity(0.08),
                                  blurRadius: 8,
                                )],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.purplePastel.withOpacity(0.3),
                                        child: Text(c.username[0].toUpperCase(),
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textDark,
                                                fontSize: 12)),
                                      ),
                                      const SizedBox(width: 8),
                                      Text('@${c.username}',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: AppColors.textDark)),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          c.likes++;
                                          c.save();
                                          setModalState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.favorite_rounded,
                                                size: 14,
                                                color: Colors.pinkAccent.withOpacity(0.7)),
                                            const SizedBox(width: 4),
                                            Text('${c.likes}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    color: AppColors.textLight)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(c.text,
                                      style: GoogleFonts.poppins(
                                          color: AppColors.textMedium,
                                          fontSize: 13,
                                          height: 1.4)),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── CONTENIDO ──────────────────────────────────────────
  Widget _buildContent() {
    final hasImages = widget.chapter.imagePaths.isNotEmpty;
    final hasTexts = widget.chapter.demoTexts.isNotEmpty;

    if (hasImages) {
      return ListView.builder(
        itemCount: widget.chapter.imagePaths.length,
        itemBuilder: (_, i) {
          final path = widget.chapter.imagePaths[i];
          return path.startsWith('http')
              ? Image.network(path, fit: BoxFit.fitWidth, width: double.infinity)
              : Image.file(File(path), fit: BoxFit.fitWidth, width: double.infinity);
        },
      );
    }

    if (hasTexts) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 80, 20, 100),
        children: [
          // Portada del capítulo
          Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D1B69), Color(0xFF1A0533)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('✨', style: TextStyle(fontSize: 50)),
                  const SizedBox(height: 12),
                  Text('Capítulo ${widget.chapter.chapterNumber}',
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 14)),
                  Text(widget.chapter.title,
                      style: GoogleFonts.pacifico(
                          color: Colors.white, fontSize: 22),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
          // Páginas de texto
          ...widget.chapter.demoTexts.map((text) {
            final isDialogue = text.startsWith('—');
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDialogue
                    ? const Color(0xFF1A0533)
                    : const Color(0xFF0D0D0D),
                borderRadius: BorderRadius.circular(16),
                border: isDialogue
                    ? Border.all(
                        color: AppColors.purplePastel.withOpacity(0.5),
                        width: 1)
                    : null,
              ),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  color: isDialogue ? AppColors.lavender : Colors.white70,
                  fontSize: isDialogue ? 16 : 15,
                  fontStyle:
                      isDialogue ? FontStyle.italic : FontStyle.normal,
                  height: 1.8,
                ),
                textAlign:
                    isDialogue ? TextAlign.center : TextAlign.left,
              ),
            );
          }).toList(),
          // Fin del capítulo
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text('— Fin del capítulo —',
                  style: GoogleFonts.poppins(
                      color: Colors.white38, fontSize: 13)),
            ),
          ),
        ],
      );
    }

    // Sin contenido
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📖', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('Capítulo sin contenido',
              style: GoogleFonts.poppins(color: Colors.white54)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => setState(() => _showUI = !_showUI),
        child: Stack(
          children: [
            _buildContent(),
            AnimatedOpacity(
              opacity: _showUI ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Cap. ${widget.chapter.chapterNumber} - ${widget.chapter.title}',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black87, Colors.transparent],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _readerBtn(
                          icon: _liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          label: 'Like',
                          color: _liked ? Colors.pinkAccent : Colors.white,
                          onTap: () => setState(() => _liked = !_liked),
                        ),
                        const SizedBox(width: 20),
                        _readerBtn(
                          icon: Icons.chat_bubble_rounded,
                          label: 'Comentar',
                          color: Colors.white,
                          onTap: _showComments,
                        ),
                        const SizedBox(width: 20),
                        _readerBtn(
                          icon: Icons.share_rounded,
                          label: 'Compartir',
                          color: Colors.white,
                          onTap: () {},
                        ),
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

  Widget _readerBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label,
              style:
                  GoogleFonts.poppins(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}