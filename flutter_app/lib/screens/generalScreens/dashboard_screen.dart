import 'package:amateur_scout_at/models/club.dart';
import 'package:amateur_scout_at/widgets/leaderboard_card.dart';
import 'package:amateur_scout_at/widgets/leaderboard_modal.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../services/app_state.dart';
import '../../models/player.dart';
import '../../widgets/header.dart';
import '../../widgets/dashboard_hero.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();

  List<Player> _topScorers = [];
  List<Player> _topRatedPlayers = [];
  List<Club> _formStrongestTeams = [];
  List<Player> _mostCardedPlayers = [];
  List<Club> _teamswithMostGoals = [];
  List<Club> _teamswithMostGoalsagainst = [];

  bool _isLoading = true;
  String? _selectedRegion;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        appState.loadAllData(),
        _apiService.getTopScorers(),
        _apiService.getTopRatedPlayers(),
        _apiService.getFormStrongestTeams(),
        _apiService.getMostCardedPlayers(),
        _apiService.getTeamsWithMostGoals(),
        _apiService.getTeamsWithMostConcededGoals(),
      ]);

      if (mounted) {
        setState(() {
          _topScorers = results[1] as List<Player>;
          _topRatedPlayers = results[2] as List<Player>;
          _formStrongestTeams = results[3] as List<Club>;
          _mostCardedPlayers = results[4] as List<Player>;
          _teamswithMostGoals = results[5] as List<Club>;
          _teamswithMostGoalsagainst = results[6] as List<Club>;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Fehler beim Laden: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      body: Column(
        children: [
          // 1. FIXED HEADER
          AppHeader(
            currentPage: "dashboard",
            onSearchChanged: (value) {
              // Suche auf dem Dashboard deaktiviert oder optional
            },
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. WILLKOMMEN & REGION FILTER (DashboardHero)
                        DashboardHero(
                          selectedRegion: _selectedRegion ?? "Alle",
                          onRegionChanged: (val) {
                            setState(() {
                              _selectedRegion = val == "Alle" ? null : val;
                              // Hier könntest du optional die Leaderboards neu filtern
                            });
                          },
                        ),
                        
                        const SizedBox(height: 48),

                        // 3. DIE 6 LEADERBOARD WIDGETS
                        _buildLeaderboardSection(isDesktop),
                        
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardSection(bool isDesktop) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop ? 3 : 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: isDesktop ? 0.85 : 1.2,
      children: [
        // 1. TOP TORSCHÜTZEN
        _buildPlayerLeaderboard(
          "Top Torschützen", 
          LucideIcons.trophy, 
          _topScorers, 
          (p) => "${p.goals}"
        ),

        // 2. HÖCHSTES RATING
        _buildPlayerLeaderboard(
          "Höchstes Rating", 
          LucideIcons.star, 
          _topRatedPlayers, 
          (p) => p.rating.toStringAsFixed(0)
        ),

        // 3. FORMSTÄRKSTE TEAMS
        _buildClubLeaderboard(
          "Formstärkste Teams", 
          LucideIcons.flame, 
          _formStrongestTeams, 
          (c) {
            c.formScore = c.lastFiveResults.fold<int>(0, (prev, res) => prev + (res == 'W' ? 3 : (res == 'D' ? 1 : 0)));
            return c.formScore.toString();
          }
        ),

        // 4. MEISTE KARTEN
        _buildPlayerLeaderboard(
          "Meiste Karten", 
          LucideIcons.alertTriangle, 
          _mostCardedPlayers, 
          (p) => p.yellow_cards.toString()
        ),

        // 5. MEISTE TORE (TEAMS)
        _buildClubLeaderboard(
          "Meiste Tore (Teams)", 
          LucideIcons.target, 
          _teamswithMostGoals, 
          (c) => c.scoredGoals.toString()
        ),

        // 6. MEISTE GEGENTORE (TEAMS)
        _buildClubLeaderboard(
          "Abwehr-Sorgen", 
          LucideIcons.shieldAlert, 
          _teamswithMostGoalsagainst, 
          (c) => c.goals_conceded.toString()
        ),
      ],
    );
  }

  // Helper für Spieler-Leaderboards (DRY - Don't Repeat Yourself)
// 1. Helper für Spieler-Leaderboards
// --- AB HIER DIE KORRIGIERTEN HELPER-METHODEN ---

  // 1. Helper für Spieler-Leaderboards
  Widget _buildPlayerLeaderboard(String title, IconData icon, List<Player> list, String Function(Player) valueMapper) {
    return LeaderboardCard(
      title: title,
      icon: icon,
      items: list.take(5).map((p) {
        // Falls p.image in deinem Model 'player_image' heißt, hier anpassen!
        String imagePath = (p.image != null && p.image!.isNotEmpty)
            ? p.image!
            : "https://api.dicebear.com/7.x/avataaars/png?seed=${p.name}";

        return LeaderboardItem(
          name: p.name,
          subtitle: "${p.club} • ${p.leagueName}",
          value: valueMapper(p),
          imageUrl: imagePath,
        );
      }).toList(),
      onSeeAll: () => _showModal(title, list, valueMapper, true),
    );
  }

  // 2. Helper für Club-Leaderboards
  Widget _buildClubLeaderboard(String title, IconData icon, List<Club> list, String Function(Club) valueMapper) {
    return LeaderboardCard(
      title: title,
      icon: icon,
      items: list.take(5).map((c) {
        // Hier könntest du analog zu den Spielern auch c.logoUrl prüfen
        return LeaderboardItem(
          name: c.name,
          subtitle: c.leagueName,
          value: valueMapper(c),
          imageUrl: "https://api.dicebear.com/7.x/identicon/png?seed=${c.name}",
        );
      }).toList(),
      onSeeAll: () => _showModal(title, list, valueMapper, false),
    );
  }

  // 3. Die zentrale Modal-Funktion (NUR EINMAL DEFINIEREN)
  void _showModal(String title, List dynamicList, Function mapper, bool isPlayer) {
    showDialog(
      context: context,
      builder: (_) => LeaderboardModal(
        title: title,
        items: dynamicList.map((item) {
          String imagePath;
          if (isPlayer) {
            final p = item as Player;
            imagePath = (p.image != null && p.image!.isNotEmpty)
                ? p.image!
                : "https://api.dicebear.com/7.x/avataaars/png?seed=${p.name}";
          } else {
            imagePath = "https://api.dicebear.com/7.x/identicon/png?seed=${item.name}";
          }

          return LeaderboardItem(
            name: item.name,
            subtitle: isPlayer ? "${item.club} • ${item.leagueName}" : item.leagueName,
            value: mapper(item),
            imageUrl: imagePath,
          );
        }).toList(),
      ),
    );
  }
} // Ende der Klasse