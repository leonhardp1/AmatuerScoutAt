import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // 1. Import hinzufügen
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jibztjmmlvtoicxprxoz.supabase.co',
    anonKey: 'sb_publishable_Ns8FITmYF8RTPf3rxxAhZw__zHRub0b',
  );

  runApp(const AmateurScoutApp());
}

class AmateurScoutApp extends StatelessWidget {
  const AmateurScoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amateur Scout AT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const DashboardScreen(),
    );
  }
}