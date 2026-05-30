import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../../models/board_model.dart';
import '../../models/dreamtoon_model.dart';
import '../../models/image_post_model.dart';
import '../../services/hive_service.dart';
import '../../widgets/dreamtoon_card.dart';
import '../../widgets/image_card.dart';

class BoardsScreen extends StatefulWidget {
  const BoardsScreen({super.key});
  @override
  State<BoardsScreen> createState() => _BoardsScreenState();
}

class _BoardsScreenState extends State<BoardsScreen> {
  final _nameCtrl = TextEditingController();

  void _crearTablero() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Nuevo tablero 🗂️',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: AppColors.textDark)),
        content: TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(hintText: 'Nombre del tablero'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar',
                style: GoogleFonts.poppins(color: AppColors.textLight)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameCtrl.text.isNotEmpty) {
                final userId = HiveService.getCurrentUserId() ?? '';
                final board = BoardModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: userId,
                  name: _nameCtrl.text,
                );
                HiveService.boards.put(board.id, board);
                _nameCtrl.clear();
                Navigator.pop(context);
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.purplePastel),
            child: Text('Crear',
                style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = HiveService.getCurrentUserId() ?? '';
    final boards = HiveService.getUserBoards(userId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text('Mis Tableros 🗂️',
                      style: GoogleFonts.pacifico(
                          fontSize: 26, color: AppColors.textDark)),
                  const Spacer(),
                  GestureDetector(
                    onTap: _crearTablero,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.purplePastel, AppColors.pinkPastel],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: boards.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🗂️', style: TextStyle(fontSize: 60)),
                          const SizedBox(height: 16),
                          Text('No tienes tableros',
                              style: GoogleFonts.poppins(
                                  color: AppColors.textMedium, fontSize: 18)),
                          const SizedBox(height: 8),
                          Text('Toca + para crear uno',
                              style: GoogleFonts.poppins(
                                  color: AppColors.textLight, fontSize: 13)),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: boards.length,
                      itemBuilder: (_, i) => GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) =>
                                BoardDetailScreen(board: boards[i])))
                            .then((_) => setState(() {})),
                        child: _BoardCard(board: boards[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BoardCard extends StatelessWidget {
  final BoardModel board;
  const _BoardCard({required this.board});

  Widget _buildPreviewImage(String path) {
    if (path.startsWith('assets/')) {
      return Image.asset(path, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultBg());
    } else if (path.startsWith('http')) {
      return Image.network(path, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultBg());
    } else {
      return Image.file(File(path), fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultBg());
    }
  }

  Widget _defaultBg() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.lavender, AppColors.purplePastel],
        ),
      ),
      child: const Center(
        child: Text('🗂️', style: TextStyle(fontSize: 36)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allImages = HiveService.getAllImages();
    final firstImage = board.imageIds.isNotEmpty
        ? allImages.where((i) => i.id == board.imageIds.first).firstOrNull
        : null;
    final hasPreview = firstImage != null &&
        firstImage.imagePath != 'demo';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
          color: AppColors.purplePastel.withOpacity(0.2),
          blurRadius: 10,
        )],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            hasPreview
                ? _buildPreviewImage(firstImage!.imagePath)
                : _defaultBg(),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 12, left: 12, right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(board.name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(
                      '${board.dreamtoonIds.length} dreamtoons • ${board.imageIds.length} imágenes',
                      style: GoogleFonts.poppins(
                          fontSize: 10, color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BoardDetailScreen extends StatefulWidget {
  final BoardModel board;
  const BoardDetailScreen({required this.board, super.key});
  @override
  State<BoardDetailScreen> createState() => _BoardDetailScreenState();
}

class _BoardDetailScreenState extends State<BoardDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _agregarDreamtoon() {
    final all = HiveService.getAllDreamtoons()
        .where((d) => !widget.board.dreamtoonIds.contains(d.id))
        .toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _AddItemSheet(
        title: 'Agregar DreamToon 📚',
        items: all.map((d) => _SheetItem(
          id: d.id, title: d.title,
          subtitle: '@${d.artistName}', emoji: '📚',
        )).toList(),
        onAdd: (id) {
          widget.board.dreamtoonIds.add(id);
          widget.board.save();
          setState(() {});
        },
      ),
    );
  }

  void _agregarImagen() {
    final all = HiveService.getAllImages()
        .where((i) => !widget.board.imageIds.contains(i.id))
        .toList();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _AddItemSheet(
        title: 'Agregar Imagen 🖼️',
        items: all.map((i) => _SheetItem(
          id: i.id, title: i.title,
          subtitle: i.category, emoji: '🖼️',
        )).toList(),
        onAdd: (id) {
          widget.board.imageIds.add(id);
          widget.board.save();
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dreamtoons = HiveService.getAllDreamtoons()
        .where((d) => widget.board.dreamtoonIds.contains(d.id))
        .toList();
    final images = HiveService.getAllImages()
        .where((i) => widget.board.imageIds.contains(i.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.board.name,
                        style: GoogleFonts.pacifico(
                            fontSize: 22, color: AppColors.textDark)),
                  ),
                  GestureDetector(
                    onTap: _tabCtrl.index == 0
                        ? _agregarDreamtoon
                        : _agregarImagen,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.purplePastel, AppColors.pinkPastel],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  onTap: (_) => setState(() {}),
                  indicator: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.purplePastel, AppColors.pinkPastel],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textMedium,
                  labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  dividerColor: Colors.transparent,
                  tabs: [
                    Tab(text: '📚 DreamToons (${dreamtoons.length})'),
                    Tab(text: '🖼️ Imágenes (${images.length})'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  dreamtoons.isEmpty
                      ? _emptyState('📚', 'No hay dreamtoons', 'Toca + para agregar')
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  images.isEmpty
                      ? _emptyState('🖼️', 'No hay imágenes', 'Toca + para agregar del feed')
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: images.asMap().entries
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
                                    ...images.asMap().entries
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
          ],
        ),
      ),
    );
  }

  Widget _emptyState(String emoji, String title, String sub) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 50)),
          const SizedBox(height: 12),
          Text(title, style: GoogleFonts.poppins(
              color: AppColors.textMedium, fontSize: 18)),
          const SizedBox(height: 4),
          Text(sub, style: GoogleFonts.poppins(
              color: AppColors.textLight, fontSize: 13)),
        ],
      ),
    );
  }
}

class _SheetItem {
  final String id, title, subtitle, emoji;
  _SheetItem({required this.id, required this.title,
      required this.subtitle, required this.emoji});
}

class _AddItemSheet extends StatelessWidget {
  final String title;
  final List<_SheetItem> items;
  final Function(String) onAdd;
  const _AddItemSheet({required this.title, required this.items, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.all(20),
      child: Column(
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
          Text(title, style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.bold,
              color: AppColors.textDark)),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? Center(child: Text('No hay elementos disponibles',
                    style: GoogleFonts.poppins(color: AppColors.textLight)))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(
                            color: AppColors.purplePastel.withOpacity(0.08),
                            blurRadius: 6,
                          )],
                        ),
                        child: Row(children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.purplePastel.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(child: Text(item.emoji,
                                style: const TextStyle(fontSize: 22))),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.title, style: GoogleFonts.poppins(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w600, fontSize: 14),
                                    maxLines: 1, overflow: TextOverflow.ellipsis),
                                Text(item.subtitle, style: GoogleFonts.poppins(
                                    color: AppColors.textLight, fontSize: 12)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              onAdd(item.id);
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.purplePastel, AppColors.pinkPastel],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text('+ Agregar', style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ]),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}