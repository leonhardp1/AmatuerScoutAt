import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Animation für den Text-Einblendeffekt
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    
    // Starte die Text-Animation nach einer kurzen Verzögerung
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Nutzt dein dunkles Theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // DEIN LOGO (mit Hero-Animation)
            Hero(
              tag: 'app_logo', // Gleicher Tag wie im AppHeader
              child: Container(
                width: 120, // Schön groß in der Mitte
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.03), 
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/logo.jpeg', // Dein rot-schwarzes ScoutBase Logo
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // UNTERSCHRIFT "ScoutBase"
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'ScoutBase',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: AppColors.foreground,
                  ),
                ),
              ),
            ),
            
            // Optional: Ein kleiner Ladeindikator
            const SizedBox(height: 60),
            const CircularProgressIndicator(
              color: AppColors.primary, // Nutzt deine grüne Primärfarbe
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}