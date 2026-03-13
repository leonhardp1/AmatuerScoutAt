import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../models/coach.dart'; // Achte auf deinen Pfad

class TrainerDetailScreen extends StatelessWidget {
  final Coach coach;

  const TrainerDetailScreen({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.foreground),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildCoachHeroHeader(),
              const SizedBox(height: 24),
              _buildTabBar(),
              Builder(
                builder: (context) {
                  final tabController = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: tabController,
                    builder: (context, child) {
                      switch (tabController.index) {
                        case 0:
                          return _buildOverviewTab();
                        case 1:
                          return _buildStatsTab();
                        case 2:
                          return _buildMediaTab();
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

  Widget _buildCoachHeroHeader() {
    bool isUnemployed = coach.currentClub.toLowerCase() == "vereinslos" || coach.currentClub.isEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Trainer Foto
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
            child: const Icon(LucideIcons.user, size: 60, color: AppColors.mutedForeground),
          ),
          const SizedBox(width: 24),
          // Info Sektion
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isUnemployed ? Colors.redAccent.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isUnemployed ? "VEREINSLOS" : coach.currentClub.toUpperCase(),
                    style: TextStyle(
                      color: isUnemployed ? Colors.redAccent : AppColors.primary, 
                      fontSize: 12, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(coach.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.foreground)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildSmallInfoChip(LucideIcons.flag, coach.nationality),
                    const SizedBox(width: 8),
                    _buildSmallInfoChip(LucideIcons.calendar, "BJ ${coach.birthYear}"),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSmallInfoChip(LucideIcons.award, coach.coachingLicense),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.mutedForeground),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
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
        Tab(text: "Stats"),
        Tab(text: "Medien"),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coaching-Style Row
          _buildCoachMetricsRow(),
          const SizedBox(height: 32),

          const Text("Bisherige Vereine", 
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          
          // Platzhalter für Historie
          _buildHistoryItem("Musterverein FC", "2021 - 2023", "45/12/10"),
          _buildHistoryItem("Alte Schmiede SV", "2018 - 2021", "30/20/15"),
        ],
      ),
    );
  }

  Widget _buildCoachMetricsRow() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardTransparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMetricItem(LucideIcons.layoutGrid, coach.preferredFormation, "Formation"),
          _buildVerticalDivider(),
          _buildMetricItem(LucideIcons.trendingUp, "${coach.winRate}%", "Win-Rate"),
          _buildVerticalDivider(),
          _buildMetricItem(LucideIcons.briefcase, "${coach.yearsExperience} J.", "Erfahrung"),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.foreground)),
        Text(label, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 11)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 40, color: AppColors.border);
  }

  Widget _buildHistoryItem(String club, String period, String record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardTransparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.card,
            child: Icon(LucideIcons.shield, size: 20, color: AppColors.mutedForeground),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(club, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.foreground)),
                Text(period, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(record, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              const Text("S/U/N", style: TextStyle(color: AppColors.mutedForeground, fontSize: 10)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    return const Padding(
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: [
            Icon(LucideIcons.clipboardList, size: 48, color: AppColors.mutedForeground),
            SizedBox(height: 16),
            Text("Detaillierte Spieleliste folgt...", style: TextStyle(color: AppColors.mutedForeground)),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 6, // Platzhalter
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage("https://via.placeholder.com/150"), // Später echte Bilder
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}