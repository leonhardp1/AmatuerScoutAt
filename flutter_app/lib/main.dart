import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart'; // Provider importieren
import 'screens/dashboard_screen.dart';
import 'services/app_state.dart'; // AppState importieren
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase initialisieren
  await Supabase.initialize(
    url: 'https://jibztjmmlvtoicxprxoz.supabase.co',
    anonKey: 'sb_publishable_Ns8FITmYF8RTPf3rxxAhZw__zHRub0b',
  );

  // App starten mit AppState als ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const AmateurScoutApp(),
    ),
  );
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