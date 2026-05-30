import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../models/image_post_model.dart';
import '../../services/hive_service.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});
  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _picker = ImagePicker();
  String? _imagePath;
  String _category = 'Arte';

  final _categories = ['Arte', 'Personajes', 'Referencias',
      'Paisajes', 'Icons', 'Aesthetic'];

  Future<void> _pickImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => _imagePath = img.path);
  }

  void _publish() {
    if (_titleCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega un título')),
      );
      return;
    }
    final userId = HiveService.getCurrentUserId() ?? '';
    final user = HiveService.users.get(userId);
    final post = ImagePostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      username: user?.username ?? 'Usuaria',
      imagePath: _imagePath ?? 'demo',
      title: _titleCtrl.text,
      description: _descCtrl.text,
      category: _category,
    );
    HiveService.imagePosts.put(post.id, post);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🖼️ Imagen publicada'),
        backgroundColor: AppColors.pinkPastel,
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
              Row(children: [
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
                Text('Subir imagen 🖼️',
                    style: GoogleFonts.pacifico(
                        fontSize: 22, color: AppColors.textDark)),
              ]),
              const SizedBox(height: 24),

              // Selector de imagen
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.pinkPastel, AppColors.purplePastel],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(File(_imagePath!),
                              fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_photo_alternate_rounded,
                                color: Colors.white, size: 48),
                            const SizedBox(height: 12),
                            Text('Toca para elegir imagen',
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Desde tu galería',
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Título
              Text('Título',
                  style: GoogleFonts.poppins(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                    hintText: 'Dale un nombre a tu imagen'),
              ),
              const SizedBox(height: 16),

              // Descripción
              Text('Descripción (opcional)',
                  style: GoogleFonts.poppins(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(
                    hintText: 'Cuéntanos sobre esta imagen...'),
              ),
              const SizedBox(height: 16),

              // Categoría
              Text('Categoría',
                  style: GoogleFonts.poppins(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _categories.map((cat) {
                  final sel = _category == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.purplePastel : AppColors.softGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(cat,
                          style: GoogleFonts.poppins(
                              color: sel ? Colors.white : AppColors.textMedium,
                              fontSize: 13,
                              fontWeight: sel
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ),
                  );
                }).toList(),
              ),
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
                  child: Text('Publicar imagen 🖼️',
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
}