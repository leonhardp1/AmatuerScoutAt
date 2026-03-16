import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/splash_screen.dart'; // SplashScreen importieren
import 'services/app_state.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase initialisieren
  await Supabase.initialize(
    url: 'https://jibztjmmlvtoicxprxoz.supabase.co',
    anonKey: 'sb_publishable_Ns8FITmYF8RTPf3rxxAhZw__zHRub0b',
  );

  runApp(
    ChangeNotifierProvider(
      // WICHTIG: Wir rufen hier die Ladefunktion des AppState auf
      create: (_) => AppState()..loadInitialData(), 
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
      
      // LOGIK FÜR DEN START-BILDSCHIRM
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          // Wir prüfen, ob der AppState noch lädt
          if (appState.isInitializing) {
            return const SplashScreen(); // Zeige den SplashScreen
          } else {
            return const DashboardScreen(); // Wechsele zum Dashboard
          }
        },
      ),
    );
  }
}