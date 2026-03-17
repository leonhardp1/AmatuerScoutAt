import 'package:amateur_scout_at/screens/clubDetailScreen.dart';
import 'package:amateur_scout_at/screens/playerComparisonScreen.dart';
import 'package:amateur_scout_at/services/app_state.dart';
import 'package:amateur_scout_at/widgets/player_position_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../models/player.dart';
import 'package:provider/provider.dart';

class PlayerDetailScreen extends StatelessWidget {
  final Player player;

  const PlayerDetailScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: TextButton.icon(
                onPressed: () {


        Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerComparisonScreen(initialPlayer: player),
      ),
    );



                }, 
                icon: const Icon(LucideIcons.arrowLeftRight, size: 18, color: AppColors.primary),
                label: const Text("Vergleichen", style: TextStyle(color: AppColors.primary)),
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeroHeader(),
              const SizedBox(height: 24),
              _buildModernTabBar(),
              // Dynamischer Content-Bereich
              Builder(
                builder: (context) {
                  final tabController = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: tabController,
                    builder: (context, child) {
                      switch (tabController.index) {
                        case 0:
                          return _buildOverviewTab(context);
                        case 1:
                          return const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(child: Text("Statistik-Grafiken folgen", style: TextStyle(color: Colors.white))),
                          );
                        case 2:
                          return const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(child: Text("Timeline folgt", style: TextStyle(color: Colors.white))),
                          );
                        case 3:
                          return const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(child: Text("Medien Grid folgt", style: TextStyle(color: Colors.white))),
                          );
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildHeroHeader() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
      children: [
        Container(
          width: 120,
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 5,
              )
            ],
          ),
          // ClipRRect sorgt dafür, dass das Bild innerhalb der abgerundeten Ecken bleibt
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: player.image != null && player.image!.isNotEmpty
                ? Image.network(
                    player.image!,
                    fit: BoxFit.cover, // Füllt den Container komplett aus
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(LucideIcons.user, size: 60, color: AppColors.mutedForeground),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  )
                : const Icon(LucideIcons.user, size: 60, color: AppColors.mutedForeground),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  player.position.toUpperCase(),
                  style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Text(player.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.foreground)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(LucideIcons.mapPin, size: 16, color: AppColors.mutedForeground),
                  const SizedBox(width: 4),
                  Text(player.region, style: const TextStyle(color: AppColors.mutedForeground)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildSmallInfoChip(LucideIcons.flag, player.nationality),
                  const SizedBox(width: 8),
                  _buildSmallInfoChip(LucideIcons.calendar, "BJ ${player.birthYear}"),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildSmallInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.mutedForeground),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
        ],
      ),
    );
  }

  Widget _buildModernTabBar() {
    return const TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorColor: AppColors.primary,
      indicatorWeight: 3,
      dividerColor: Colors.transparent,
      labelColor: AppColors.foreground,
      unselectedLabelColor: AppColors.mutedForeground,
      tabs: [
        Tab(text: "Übersicht"),
        Tab(text: "Statistiken"),
        Tab(text: "Historie"),
        Tab(text: "Medien"),
      ],
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bio-Metrics Row: Höhe, Fuß, Gewicht
          _buildBioMetricsRow(),
          const SizedBox(height: 24),

          // Vereins-Karte
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _navigateToClubDetail(context, player.club),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardTransparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(LucideIcons.shield, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(player.club, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.foreground)),
                          Text(player.leagueName, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
                        ],
                      ),
                    ),
                    const Icon(LucideIcons.chevronRight, color: AppColors.mutedForeground, size: 18),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Leistungsdaten Grid
          Row(
            children: [
              _buildDetailStatCard("Spiele", player.matches.toString(), LucideIcons.target),
              const SizedBox(width: 12),
              _buildDetailStatCard("Tore", player.goals.toString(), LucideIcons.trophy),
              const SizedBox(width: 12),
              _buildDetailStatCard("Minuten", player.minutesPlayed.toString(), LucideIcons.clock),
            ],
          ),
          const SizedBox(height: 32),

          // Spielfeld-Visualisierung
          PlayerPositionField(
            exactPosition: player.exactPosition,
            secondPositions: player.secondPositions,
          ),
        ],
      ),
    );
  }

  Widget _buildBioMetricsRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.cardTransparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBioItem(LucideIcons.ruler, "${player.height} cm", "Größe"),
          _buildVerticalDivider(),
          _buildStrongFootIndicator(player.strongFoot),
          _buildVerticalDivider(),
          _buildBioItem(LucideIcons.scale, "${player.weight} kg", "Gewicht"),
        ],
      ),
    );
  }

  Widget _buildBioItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.foreground)),
        Text(label, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 11)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 35, color: AppColors.border.withOpacity(0.5));
  }

  Widget _buildStrongFootIndicator(String foot) {
    final f = foot.toLowerCase();
    bool isRight = f.contains('rechts') || f == 'right';
    bool isLeft = f.contains('links') || f == 'left';
    bool isBoth = f.contains('beide') || f == 'both';

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.footprints,
              color: (isLeft || isBoth) ? AppColors.primary : AppColors.mutedForeground.withOpacity(0.2),
              size: 24,
            ),
            const SizedBox(width: 4),
            Transform.flip(
              flipX: true,
              child: Icon(
                LucideIcons.footprints,
                color: (isRight || isBoth) ? AppColors.primary : AppColors.mutedForeground.withOpacity(0.2),
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          isBoth ? "Beidfüßig" : (isLeft ? "Linksfuß" : "Rechtsfuß"),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.foreground),
        ),
        const Text("Starker Fuß", style: TextStyle(color: AppColors.mutedForeground, fontSize: 11)),
      ],
    );
  }

  void _navigateToClubDetail(BuildContext context, String clubName) {
    final appState = Provider.of<AppState>(context, listen: false);
    try {
      final club = appState.clubs.firstWhere((c) => c.name == clubName);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClubDetailScreen(club: club)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Details für $clubName konnten nicht geladen werden."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildDetailStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardTransparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.foreground)),
            Text(label, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}