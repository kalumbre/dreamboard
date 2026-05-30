import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../models/chapter_model.dart';
import '../../models/dreamtoon_model.dart';
import '../../services/hive_service.dart';

class UploadChapterScreen extends StatefulWidget {
  final DreamToonModel dreamtoon;
  const UploadChapterScreen({required this.dreamtoon, super.key});

  @override
  State<UploadChapterScreen> createState() => _UploadChapterScreenState();
}

class _UploadChapterScreenState extends State<UploadChapterScreen> {
  final _titleCtrl = TextEditingController();
  final _picker = ImagePicker();
  final List<String> _imagePaths = [];

  Future<void> _pickImages() async {
    final imgs = await _picker.pickMultiImage();
    setState(() => _imagePaths.addAll(imgs.map((i) => i.path)));
  }

  void _publish() {
    if (_titleCtrl.text.isEmpty || _imagePaths.isEmpty) return;
    final chapterCount = HiveService.chapters.values
        .where((c) => c.dreamtoonId == widget.dreamtoon.id)
        .length;
    final chapter = ChapterModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      dreamtoonId: widget.dreamtoon.id,
      title: _titleCtrl.text,
      chapterNumber: chapterCount + 1,
      imagePaths: _imagePaths,
    );
    HiveService.chapters.put(chapter.id, chapter);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📖 Capítulo ${chapter.chapterNumber} publicado'),
        backgroundColor: AppColors.purplePastel,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  Text('Subir Capítulo 📖',
                      style: GoogleFonts.pacifico(
                          fontSize: 22, color: AppColors.textDark)),
                ],
              ),
              const SizedBox(height: 24),

              Text('DreamToon: ${widget.dreamtoon.title}',
                  style: GoogleFonts.poppins(
                      color: AppColors.textMedium, fontSize: 13)),
              const SizedBox(height: 20),

              _label('Título del capítulo'),
              const SizedBox(height: 8),
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(hintText: 'Capítulo 1: El comienzo'),
              ),
              const SizedBox(height: 24),

              // Agregar imágenes
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.softGray,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.purplePastel.withOpacity(0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_photo_alternate_rounded,
                          color: AppColors.purplePastel, size: 28),
                      const SizedBox(width: 12),
                      Text('Agregar páginas del capítulo',
                          style: GoogleFonts.poppins(color: AppColors.textMedium)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_imagePaths.isNotEmpty) ...[
                Text('${_imagePaths.length} páginas agregadas',
                    style: GoogleFonts.poppins(
                        color: AppColors.textMedium, fontSize: 13)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _imagePaths.length,
                    itemBuilder: (_, i) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(_imagePaths[i])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _publish,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.pinkPastel,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Publicar Capítulo 📖',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textDark)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: GoogleFonts.poppins(
          color: AppColors.textDark, fontWeight: FontWeight.w600));
}