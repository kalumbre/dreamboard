import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../models/dreamtoon_model.dart';
import '../../services/hive_service.dart';

class UploadDreamToonScreen extends StatefulWidget {
  final DreamToonModel? dreamtoon; // Si no es null = editar
  const UploadDreamToonScreen({this.dreamtoon, super.key});
  @override
  State<UploadDreamToonScreen> createState() => _UploadDreamToonScreenState();
}

class _UploadDreamToonScreenState extends State<UploadDreamToonScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _picker = ImagePicker();
  String? _coverPath;
  final List<String> _selectedGenres = [];
  bool _isEditing = false;

  final _allGenres = ['Fantasía', 'Romance', 'Aventura', 'Drama',
      'Comedia', 'Slice of Life', 'Ciencia Ficción', 'Terror', 'Misterio'];

  @override
  void initState() {
    super.initState();
    // Si es edición, cargar datos existentes
    if (widget.dreamtoon != null) {
      _isEditing = true;
      _titleCtrl.text = widget.dreamtoon!.title;
      _descCtrl.text = widget.dreamtoon!.description;
      _coverPath = widget.dreamtoon!.coverImagePath;
      _selectedGenres.addAll(widget.dreamtoon!.genres);
    }
  }

  Future<void> _pickCover() async {
    final img = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (img != null) setState(() => _coverPath = img.path);
  }

  void _publish() {
    if (_titleCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega un título')));
      return;
    }

    if (_isEditing && widget.dreamtoon != null) {
      // EDITAR dreamtoon existente
      widget.dreamtoon!.title = _titleCtrl.text;
      widget.dreamtoon!.description = _descCtrl.text;
      widget.dreamtoon!.coverImagePath = _coverPath;
      widget.dreamtoon!.genres = _selectedGenres;
      widget.dreamtoon!.save();
    } else {
      // CREAR nuevo dreamtoon
      final userId = HiveService.getCurrentUserId() ?? '';
      final user = HiveService.users.get(userId);
      final dt = DreamToonModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleCtrl.text,
        description: _descCtrl.text,
        artistId: userId,
        artistName: user?.username ?? 'Artista',
        coverImagePath: _coverPath,
        genres: _selectedGenres,
      );
      HiveService.dreamtoons.put(dt.id, dt);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEditing
            ? '✅ DreamToon actualizado'
            : '✨ DreamToon publicado'),
        backgroundColor: AppColors.purplePastel,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
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
              // Header
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
                Text(_isEditing ? 'Editar DreamToon ✏️' : 'Subir DreamToon 🎨',
                    style: GoogleFonts.pacifico(
                        fontSize: 20, color: AppColors.textDark)),
              ]),
              const SizedBox(height: 24),

              // Selector de portada
              GestureDetector(
                onTap: _pickCover,
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: _coverPath != null && _coverPath!.isNotEmpty
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(File(_coverPath!),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _coverPlaceholder()),
                              // Botón cambiar encima
                              Positioned(
                                bottom: 12, right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.edit_rounded,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text('Cambiar',
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 12)),
                                  ]),
                                ),
                              ),
                            ],
                          )
                        : _coverPlaceholder(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text('Toca la portada para elegir imagen',
                    style: GoogleFonts.poppins(
                        color: AppColors.textLight, fontSize: 12)),
              ),
              const SizedBox(height: 20),

              // Título
              _label('Título del DreamToon'),
              const SizedBox(height: 8),
              TextField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                    hintText: 'El nombre de tu historia'),
              ),
              const SizedBox(height: 16),

              // Descripción
              _label('Descripción'),
              const SizedBox(height: 8),
              TextField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    hintText: 'Cuenta de qué trata tu historia...'),
              ),
              const SizedBox(height: 16),

              // Géneros
              _label('Géneros'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: _allGenres.map((g) {
                  final sel = _selectedGenres.contains(g);
                  return GestureDetector(
                    onTap: () => setState(() {
                      sel ? _selectedGenres.remove(g)
                          : _selectedGenres.add(g);
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.purplePastel : AppColors.softGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(g,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: sel ? Colors.white : AppColors.textMedium,
                              fontWeight: sel
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Botón publicar/guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _publish,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.purplePastel,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    _isEditing ? '💾 Guardar cambios' : '✨ Publicar DreamToon',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.purplePastel, AppColors.pinkPastel],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_photo_alternate_rounded,
              color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text('Agregar portada',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Desde tu galería',
              style: GoogleFonts.poppins(
                  color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: GoogleFonts.poppins(
          color: AppColors.textDark, fontWeight: FontWeight.w600));
}