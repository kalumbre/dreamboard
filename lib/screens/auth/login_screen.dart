import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import '../../services/hive_service.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  String? _error;

  void _login() {
    try {
      final user = HiveService.getUserByEmail(_emailCtrl.text.trim());
      if (user != null && user.password == _passCtrl.text) {
        HiveService.setCurrentUserId(user.id);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (user == null) {
        setState(() => _error = 'Usuario no encontrado');
      } else {
        setState(() => _error = 'Contraseña incorrecta');
      }
    } catch (e) {
      setState(() => _error = 'Error al iniciar sesión');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Logo
                Center(
                  child: Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.purplePastel, AppColors.pinkPastel],
                      ),
                      boxShadow: [BoxShadow(
                        color: AppColors.purplePastel.withValues(alpha: 0.3),
                        blurRadius: 20,
                      )],
                    ),
                    child: const Center(child: Text('✨', style: TextStyle(fontSize: 36))),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Bienvenida ✨',
                    style: GoogleFonts.pacifico(fontSize: 32, color: AppColors.textDark)),
                const SizedBox(height: 8),
                Text('Inicia sesión para continuar',
                    style: GoogleFonts.poppins(color: AppColors.textMedium)),
                const SizedBox(height: 40),

                // Email
                _label('Correo electrónico'),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'tu@correo.com',
                    prefixIcon: Icon(Icons.email_rounded, color: AppColors.purplePastel),
                  ),
                ),
                const SizedBox(height: 16),

                // Contraseña
                _label('Contraseña'),
                const SizedBox(height: 8),
                TextField(
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_rounded, color: AppColors.purplePastel),
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _obscure = !_obscure),
                      child: Icon(
                        _obscure ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!,
                      style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 13)),
                ],

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purplePastel,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('Iniciar sesión',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen())),
                    child: RichText(
                      text: TextSpan(
                        text: '¿No tienes cuenta? ',
                        style: GoogleFonts.poppins(color: AppColors.textMedium),
                        children: [
                          TextSpan(
                            text: 'Regístrate',
                            style: GoogleFonts.poppins(
                                color: AppColors.purplePastel,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: GoogleFonts.poppins(
          color: AppColors.textDark, fontWeight: FontWeight.w600));
}