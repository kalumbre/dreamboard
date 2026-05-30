import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/dreamtoon_model.dart';
import '../../models/image_post_model.dart';
import '../../providers/theme_provider.dart';
import '../../services/hive_service.dart';
import '../../widgets/dreamtoon_card.dart';
import '../../widgets/image_card.dart';
import '../pinterest/upload_image_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  String _categoria = 'Todos';
  String _imgCategoria = 'Todos';

  final _dtCategorias = ['Todos', 'Fantasía', 'Romance', 'Aventura',
      'Drama', 'Comedia', 'Slice of Life'];
  final _imgCategorias = ['Todos', 'Arte', 'Personajes', 'Referencias',
      'Paisajes', 'Icons', 'Aesthetic'];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<DreamToonModel> get _dtFiltrados {
    final all = HiveService.getAllDreamtoons();
    if (_categoria == 'Todos') return all;
    return all.where((d) => d.genres.contains(_categoria)).toList();
  }

  List<ImagePostModel> get _imgFiltradas {
    return HiveService.getImagesByCategory(_imgCategoria);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final primary = theme.primaryColor;
    final bg = theme.backgroundColor;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header con fondo del color del tema
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: bg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('DreamBoard ✨',
                            style: GoogleFonts.pacifico(
                                fontSize: 26, color: AppColors.textDark)),
                        Text('Descubre y guarda lo que amas',
                            style: GoogleFonts.poppins(
                                color: AppColors.textMedium, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (_tabCtrl.index == 0)
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const UploadImageScreen()))
                          .then((_) => setState(() {})),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primary, theme.secondaryColor],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add_photo_alternate_rounded,
                            color: Colors.white, size: 22),
                      ),
                    ),
                ],
              ),
            ),

            // TabBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.softGray,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TabBar(
                  controller: _tabCtrl,
                  indicator: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, theme.secondaryColor],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textMedium,
                  labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 13),
                  unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: '🖼️  Imágenes'),
                    Tab(text: '📚  DreamToons'),
                  ],
                ),
              ),
            ),

            // Categorías
            SizedBox(
              height: 38,
              child: _tabCtrl.index == 0
                  ? _buildCategoryList(_imgCategorias, _imgCategoria,
                      (c) => setState(() => _imgCategoria = c), primary)
                  : _buildCategoryList(_dtCategorias, _categoria,
                      (c) => setState(() => _categoria = c), primary),
            ),
            const SizedBox(height: 8),

            // Contenido
            Expanded(
              child: TabBarView(
                controller: _tabCtrl,
                children: [
                  _imgFiltradas.isEmpty
                      ? _emptyState('🖼️', 'No hay imágenes aquí',
                          'Sé la primera en subir algo bonito')
                      : _pinterestGrid(_imgFiltradas),
                  _dtFiltrados.isEmpty
                      ? _emptyState('📚', 'No hay dreamtoons',
                          'Prueba otra categoría')
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: _dtFiltrados.length,
                          itemBuilder: (_, i) =>
                              DreamToonCard(dreamtoon: _dtFiltrados[i]),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pinterestGrid(List<ImagePostModel> images) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: images
                  .asMap()
                  .entries
                  .where((e) => e.key % 2 == 0)
                  .map((e) => ImageCard(image: e.value,
                      height: e.key % 4 == 0 ? 220 : 170))
                  .toList(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 40),
                ...images
                    .asMap()
                    .entries
                    .where((e) => e.key % 2 == 1)
                    .map((e) => ImageCard(image: e.value,
                        height: e.key % 4 == 1 ? 190 : 160))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(List<String> cats, String selected,
      Function(String) onSelect, Color primary) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: cats.length,
      itemBuilder: (_, i) {
        final sel = cats[i] == selected;
        return GestureDetector(
          onTap: () => onSelect(cats[i]),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: sel ? primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(
                color: primary.withOpacity(0.15),
                blurRadius: 6,
              )],
            ),
            child: Text(cats[i],
                style: GoogleFonts.poppins(
                    color: sel ? Colors.white : AppColors.textMedium,
                    fontSize: 12,
                    fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
          ),
        );
      },
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