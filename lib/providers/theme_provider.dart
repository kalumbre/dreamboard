import 'package:flutter/material.dart';
import '../services/hive_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const List<Map<String, dynamic>> paleta = [
    {
      'nombre': 'Morado Dream',
      'primary': Color(0xFFD4B8F0),
      'secondary': Color(0xFFB8D4F0),
      'background': Color(0xFFF5F0FF),
    },
    {
      'nombre': 'Rosa Pastel',
      'primary': Color(0xFFF0B8D4),
      'secondary': Color(0xFFF0D4B8),
      'background': Color(0xFFFFF0F5),
    },
    {
      'nombre': 'Azul Cielo',
      'primary': Color(0xFFB8D4F0),
      'secondary': Color(0xFFB8F0D4),
      'background': Color(0xFFF0F5FF),
    },
    {
      'nombre': 'Menta',
      'primary': Color(0xFFB8F0D4),
      'secondary': Color(0xFFB8D4F0),
      'background': Color(0xFFF0FFF5),
    },
    {
      'nombre': 'Durazno',
      'primary': Color(0xFFF0D4B8),
      'secondary': Color(0xFFF0B8D4),
      'background': Color(0xFFFFF8F0),
    },
    {
      'nombre': 'Lavanda',
      'primary': Color(0xFFE8D5F5),
      'secondary': Color(0xFFD4B8F0),
      'background': Color(0xFFFAF5FF),
    },
  ];

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  Color get primaryColor => paleta[_selectedIndex]['primary'] as Color;
  Color get secondaryColor => paleta[_selectedIndex]['secondary'] as Color;
  Color get backgroundColor => paleta[_selectedIndex]['background'] as Color;

  ThemeProvider() {
    _selectedIndex = HiveService.settings.get('themeIndex', defaultValue: 0);
  }

  void setTheme(int index) {
    _selectedIndex = index;
    HiveService.settings.put('themeIndex', index);
    notifyListeners();
  }
}