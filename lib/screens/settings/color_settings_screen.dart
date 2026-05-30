import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/theme_provider.dart';

class ColorSettingsScreen extends StatelessWidget {
  const ColorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
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
                  Text('Mi Color 🎨',
                      style: GoogleFonts.pacifico(
                          fontSize: 24, color: AppColors.textDark)),
                ],
              ),
              const SizedBox(height: 8),
              Text('Elige el color de tu DreamBoard',
                  style: GoogleFonts.poppins(
                      color: AppColors.textMedium, fontSize: 14)),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: ThemeProvider.paleta.length,
                  itemBuilder: (_, i) {
                    final p = ThemeProvider.paleta[i];
                    final selected = themeProvider.selectedIndex == i;
                    return GestureDetector(
                      onTap: () {
                        // Cambia el tema en toda la app
                        context.read<ThemeProvider>().setTheme(i);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✨ Tema ${p['nombre']} aplicado'),
                            backgroundColor: p['primary'] as Color,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              p['primary'] as Color,
                              p['secondary'] as Color,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: selected
                              ? Border.all(color: AppColors.textDark, width: 3)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: (p['primary'] as Color).withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (selected)
                                const Icon(Icons.check_circle_rounded,
                                    color: Colors.white, size: 30),
                              Text(p['nombre'] as String,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}