import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_model.dart';
import '../../services/hive_service.dart';
import '../home/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _userType = 'user';
  String? _error;

  void _register() {
    if (_userCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _passCtrl.text.isEmpty) {
      setState(() => _error = 'Completa todos los campos');
      return;
    }
    if (HiveService.emailExists(_emailCtrl.text.trim())) {
      setState(() => _error = 'El correo ya está registrado');
      return;
    }
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: _userCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      userType: _userType,
    );
    HiveService.saveUser(user);
    HiveService.setCurrentUserId(user.id);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textDark, size: 18),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Crear cuenta ✨',
                    style: GoogleFonts.pacifico(fontSize: 32, color: AppColors.textDark)),
                const SizedBox(height: 8),
                Text('Únete a DreamBoard',
                    style: GoogleFonts.poppins(color: AppColors.textMedium)),
                const SizedBox(height: 32),

                _label('Nombre de usuario'),
                const SizedBox(height: 8),
                TextField(
                  controller: _userCtrl,
                  decoration: const InputDecoration(
                    hintText: '@tunombre',
                    prefixIcon: Icon(Icons.person_rounded, color: AppColors.pinkPastel),
                  ),
                ),
                const SizedBox(height: 16),

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

                _label('Contraseña'),
                const SizedBox(height: 8),
                TextField(
                  controller: _passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: Icon(Icons.lock_rounded, color: AppColors.bluePastel),
                  ),
                ),
                const SizedBox(height: 20),

                // Tipo de usuario
                _label('Tipo de cuenta'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _typeBtn('user', '🌸 Lectora'),
                    const SizedBox(width: 12),
                    _typeBtn('artist', '🎨 Artista'),
                  ],
                ),

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ],

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pinkPastel,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text('Crear cuenta',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _typeBtn(String type, String label) {
    final selected = _userType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _userType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.purplePastel : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? AppColors.purplePastel : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(label,
                style: GoogleFonts.poppins(
                    color: AppColors.textDark,
                    fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: GoogleFonts.poppins(color: AppColors.textDark, fontWeight: FontWeight.w600));
}