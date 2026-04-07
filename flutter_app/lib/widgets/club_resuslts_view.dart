import 'package:amateur_scout_at/screens/extendetScreens/clubDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/club.dart';
import '../theme/app_theme.dart';

class ClubResultsView extends StatelessWidget {
  final List<Club> clubs;
  final bool isGridView;
  final bool isDesktop;
  final String sortColumn;
  final bool sortAscending;
  final Function(String key) onSort;

  // Die zentrale Ligen-Map direkt im Widget
  static const Map<String, List<String>> ligenMap = {
    "Burgenland": ["Burgenlandliga", "2. Landesliga", "1. Klasse", "2. Klasse"],
    "Kärnten": ["Kärntner Liga", "Unterliga", "1. Klasse", "2. Klasse"],
    "Niederösterreich": ["1. Landesliga", "2. Landesliga", "Gebietsliga", "1. Klasse", "2. Klasse"],
    "Oberösterreich": ["OÖ Liga", "Landesliga", "Bezirksliga", "1. Klasse", "2. Klasse"],
    "Salzburg": ["Salzburger Liga", "Landesliga", "1. Landesliga", "2. Landesliga"],
    "Steiermark": ["Landesliga", "Oberliga", "Unterliga", "Gebietsliga", "1. Klasse"],
    "Tirol": ["Tiroler Liga", "Landesliga", "Gebietsliga", "Bezirksliga", "1. Klasse"],
    "Vorarlberg": ["Vorarlberg-Liga", "Landesliga", "1. Landesklasse", "2. Landesklasse", "3. Landesklasse"],
    "Wien": ["Wiener Stadtliga", "2. Landesliga", "Oberliga", "1. Klasse", "2. Klasse"],
  };

  const ClubResultsView({
    super.key,
    required this.clubs,
    required this.isGridView,
    required this.isDesktop,
    required this.sortColumn,
    required this.sortAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    // Aktuell nur Tabellenansicht (analog zum Figma Design)
    return _buildClubTable(context);
  }

  Widget _buildClubTable(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 48,
          ),
          child: DataTable(
            showCheckboxColumn: false,
            columnSpacing: 25,
            headingRowColor: WidgetStateProperty.all(AppColors.muted.withOpacity(0.15)),
            columns: [
              _buildSortableHeader("Vereinsname", "name"),
              _buildSortableHeader("Region", "region"),
              _buildSortableHeader("Liga", "leagueName"),
              _buildSortableHeader("Stadion", "stadiumName"),
              _buildSortableHeader("Rang", "rank"),
              const DataColumn(label: Text("TORE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.mutedForeground))),
              _buildSortableHeader("Punkte", "points"),
            ],
            rows: clubs.map((club) {
              final goalDiff = club.scoredGoals - club.goals_conceded;

              return DataRow(
                onSelectChanged: (_) {
                  // Navigation zum Detail-Screen
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ClubDetailScreen(club: club)));
                },
                cells: [
                  // Logo + Name
                  DataCell(Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: club.logo.isNotEmpty
                            ? Image.network(club.logo, fit: BoxFit.contain, 
                                errorBuilder: (c, e, s) => const Icon(LucideIcons.shield, size: 16, color: Colors.white24))
                            : const Icon(LucideIcons.shield, size: 16, color: Colors.white24),
                      ),
                      const SizedBox(width: 12),
                      Text(club.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  )),
                  DataCell(Text(club.region, style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(club.leagueName, style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(club.stadiumName, style: const TextStyle(color: Colors.white70))),
                  DataCell(Text("#${club.rank}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  // Tore Formatierung (Tore:Gegentore)
                  DataCell(Text("${club.scoredGoals}:${club.goals_conceded} (${goalDiff > 0 ? '+' : ''}$goalDiff)", 
                    style: TextStyle(color: goalDiff >= 0 ? Colors.greenAccent.withOpacity(0.8) : Colors.redAccent.withOpacity(0.8)))),
                  // Punkte Badge
                  DataCell(_buildPointsBadge(club.points)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  DataColumn _buildSortableHeader(String label, String key) {
    bool isSelected = sortColumn == key;
    return DataColumn(
      onSort: (_, __) => onSort(key),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.primary : AppColors.mutedForeground)),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(sortAscending ? LucideIcons.arrowUp : LucideIcons.arrowDown,
                  size: 14, color: AppColors.primary),
            ),
        ],
      ),
    );
  }

  Widget _buildPointsBadge(int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$points Pkt",
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}