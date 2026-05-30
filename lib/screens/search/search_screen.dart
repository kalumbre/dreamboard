import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../services/hive_service.dart';
import '../../widgets/dreamtoon_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _ctrl = TextEditingController();
  var _results = HiveService.getAllDreamtoons();

  void _search(String q) {
    setState(() {
      _results = q.isEmpty ? HiveService.getAllDreamtoons() : HiveService.searchDreamtoons(q);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Buscar 🔍',
                      style: GoogleFonts.pacifico(fontSize: 26, color: AppColors.textDark)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _ctrl,
                    onChanged: _search,
                    decoration: InputDecoration(
                      hintText: 'Busca dreamtoons, géneros...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.purplePastel),
                      suffixIcon: _ctrl.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () { _ctrl.clear(); _search(''); },
                              child: const Icon(Icons.close_rounded, color: AppColors.textLight),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('${_results.length} resultados',
                      style: GoogleFonts.poppins(color: AppColors.textLight, fontSize: 12)),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: _results.length,
                itemBuilder: (_, i) => DreamToonCard(dreamtoon: _results[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}