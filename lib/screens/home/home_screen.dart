import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../feed/feed_screen.dart';
import '../search/search_screen.dart';
import '../boards/boards_screen.dart';
import '../profile/profile_screen.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  final List<Widget> _screens = [
    const FeedScreen(),
    const SearchScreen(),
    const BoardsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = context.watch<ThemeProvider>().primaryColor;

    return Scaffold(
      body: _screens[_tab],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(
            color: primary.withOpacity(0.2),
            blurRadius: 20,
          )],
        ),
        child: BottomNavigationBar(
          currentIndex: _tab,
          onTap: (i) => setState(() => _tab = i),
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: primary,
          unselectedItemColor: AppColors.textLight,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_rounded), label: 'Feed'),
            BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Buscar'),
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Tableros'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}