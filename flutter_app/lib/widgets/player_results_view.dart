import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import 'player_card.dart';
import '../screens/extendetScreens/playerDetailScreen.dart';

class PlayerResultsView extends StatelessWidget {
  final List<Player> players;
  final bool isGridView;
  final bool isDesktop;
  final bool isTablet;
  final String sortColumn;
  final bool sortAscending;
  final Function(String key) onSort;

  const PlayerResultsView({
    super.key,
    required this.players,
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
          childAspectRatio: 0.75,
        ),
        itemCount: players.length,
        itemBuilder: (context, index) => PlayerCard(player: players[index]),
      );
    } else {
      return _buildPlayerTable(context);
    }
  }

  Widget _buildPlayerTable(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: DataTable(
          showCheckboxColumn: false,
          headingRowColor: WidgetStateProperty.all(AppColors.muted.withOpacity(0.15)),
          columns: [
            _buildSortableHeader("Name", "name"),
            _buildSortableHeader("Alter", "age"),
            _buildSortableHeader("Spiele", "matches"),
            _buildSortableHeader("Tore", "goals"),
            _buildSortableHeader("Rating", "rating"),
            const DataColumn(label: Text("Club", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mutedForeground))),
          ],
          rows: players.map((p) {
            return DataRow(
              onSelectChanged: (_) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerDetailScreen(player: p)));
              },
              cells: [
                DataCell(Row(children: [
                  CircleAvatar(radius: 14, child: Text(p.name[0])),
                  const SizedBox(width: 12),
                  Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                ])),
                DataCell(Text(p.age.toString())),
                DataCell(Text(p.matches.toString())),
                DataCell(Text(p.goals.toString())),
                DataCell(_buildRatingBadge(p.rating)),
                DataCell(Text(p.club)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  DataColumn _buildSortableHeader(String label, String key) {
    bool isSelected = sortColumn == key;
    return DataColumn(
      onSort: (_, __) => onSort(key),
      label: Row(
        children: [
          Text(label.toUpperCase(), style: TextStyle(fontSize: 11, color: isSelected ? AppColors.primary : AppColors.mutedForeground)),
          if (isSelected) Icon(sortAscending ? LucideIcons.arrowUp : LucideIcons.arrowDown, size: 14, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(rating.toStringAsFixed(1), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
    );
  }
}