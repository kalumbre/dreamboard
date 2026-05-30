import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'screens/auth/splash_screen.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const DreamBoardApp(),
    ),
  );
}

class DreamBoardApp extends StatelessWidget {
  const DreamBoardApp({super.key});
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'DreamBoard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeFromColor(themeProvider.primaryColor),
      home: const SplashScreen(),
    );
  }
}