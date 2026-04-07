import 'package:amateur_scout_at/screens/extendetScreens/coachDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/coach.dart';
import '../theme/app_theme.dart';
import 'coach_card.dart';

class CoachResultsView extends StatelessWidget {
  final List<Coach> coaches;
  final bool isGridView;
  final bool isDesktop;
  final bool isTablet;
  final String sortColumn;
  final bool sortAscending;
  final Function(String key) onSort;

  const CoachResultsView({
    super.key,
    required this.coaches,
    required this.isGridView,
    required this.isDesktop,
    required this.isTablet,
    required this.sortColumn,
    required this.sortAscending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    if (isGridView) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 1),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          mainAxisExtent: 240, 
        ),
        itemCount: coaches.length,
        itemBuilder: (context, index) => CoachCard(coach: coaches[index]),
      );
    } else {
      return _buildCoachTable(context);
    }
  }

  Widget _buildCoachTable(BuildContext context) {
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
          // Zwingt die Tabelle auf Bildschirmbreite (minus Padding)
          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 48),
          child: DataTable(
            showCheckboxColumn: false,
            columnSpacing: isDesktop ? 40 : 20,
            headingRowColor: WidgetStateProperty.all(AppColors.muted.withOpacity(0.15)),
            columns: [
              _buildSortableHeader("Name", "name"),
              const DataColumn(label: Text("VEREIN", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mutedForeground))),
              _buildSortableHeader("Lizenz", "coachingLicense"),
              _buildSortableHeader("S", "wins"),
              _buildSortableHeader("U", "draws"),
              _buildSortableHeader("N", "losses"),
              _buildSortableHeader("Erfahrung", "yearsExperience"),
              _buildSortableHeader("Quote", "winRate"),
            ],
            rows: coaches.map((c) {
              return DataRow(
                onSelectChanged: (_) {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => TrainerDetailScreen(coach: c)));

                },
                cells: [
                  // Name mit Avatar
                  DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                    CircleAvatar(
                      radius: 14, 
                      backgroundImage: c.image.isNotEmpty ? NetworkImage(c.image) : null,
                      child: c.image.isEmpty ? Text(c.name[0]) : null,
                    ),
                    const SizedBox(width: 12),
                    Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                  ])),
                  // Vereinsname
                  DataCell(Text(c.currentClub, style: const TextStyle(color: Colors.white70))),
                  // Lizenz
                  DataCell(Text(c.coachingLicense)),
                  // Siege
                  DataCell(Text(c.wins.toString())),
                  // Unentschieden
                  DataCell(Text(c.draws.toString())),
                  // Niederlagen
                  DataCell(Text(c.losses.toString())),
                  // Erfahrung
                  DataCell(Text("${c.yearsExperience} J.")),
                  // Siegquote (Badge)
                  DataCell(_buildWinRateBadge(c.winRate)),
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
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, color: isSelected ? AppColors.primary : AppColors.mutedForeground)),
          if (isSelected) Icon(sortAscending ? LucideIcons.arrowUp : LucideIcons.arrowDown, size: 14, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildWinRateBadge(double winRate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(20)
      ),
      child: Text(
        "${winRate.toInt()}%", 
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
      ),
    );
  }
}