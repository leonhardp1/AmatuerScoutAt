import 'package:amateur_scout_at/screens/generalScreens/searchPlayer_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'screens/generalScreens/dashboard_screen.dart';
  import 'screens/generalScreens/searchPlayer_screen.dart';
import 'screens/splash_screen.dart';

import 'services/app_state.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jibztjmmlvtoicxprxoz.supabase.co',
    anonKey: 'sb_publishable_Ns8FITmYF8RTPf3rxxAhZw__zHRub0b',
  );

  runApp(
    ChangeNotifierProvider(
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

      /// 🔥 ROUTES
      routes: {
        "/dashboard": (context) => const DashboardScreen(),
        "/spieler": (context) => const SearchPlayerScreen(),
      },

      /// 🔥 START LOGIK
      home: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isInitializing) {
            return const SplashScreen();
          } else {
            return const DashboardScreen();
          }
        },
      ),
    );
  }
}