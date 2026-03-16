import 'package:amateur_scout_at/screens/playerDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../services/app_state.dart';
import '../models/player.dart';
import '../widgets/header.dart';
import '../widgets/player_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/filter_sidebar.dart';

// --- DASHBOARD SCREEN ---
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ApiService _apiService = ApiService();

  List<Player> _allPlayers = [];
  bool _isLoading = true;
  int _visibleCount = 100;
  String _searchQuery = "";
  String _sortBy = 'name';
  Map<String, dynamic> _activeFilters = {};

  // FÜR DIE NEUE ANSICHT
  bool _isGridView = true; // true = Grid, false = Tabelle
  String _sortColumn = 'name'; // Spalte nach der sortiert wird
  bool _sortAscending = true; // Auf- oder Absteigend

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final appState = Provider.of<AppState>(context, listen: false);
    setState(() => _isLoading = true);

    try {
      await appState.loadAllData();
      setState(() {
        _allPlayers = appState.players;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Fehler beim Initialen Laden: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 600;

    // Filter anwenden
    List<Player> filteredPlayers = _allPlayers.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery) ||
          p.club.toLowerCase().contains(_searchQuery);
      bool matchesFilters = true;
      if (_activeFilters['bundesland'] != null) matchesFilters = matchesFilters && p.region == _activeFilters['bundesland'];
      if (_activeFilters['liga'] != null) matchesFilters = matchesFilters && p.leagueName == _activeFilters['liga'];
      if (_activeFilters['position'] != null) matchesFilters = matchesFilters && p.position == _activeFilters['position'];
      return matchesSearch && matchesFilters;
    }).toList();

    // Sortieren nach Spalte
    filteredPlayers.sort((a, b) {
      int cmp;
      switch (_sortColumn) {
        case 'goals': cmp = a.goals.compareTo(b.goals); break;
        case 'matches': cmp = a.matches.compareTo(b.matches); break;
        case 'age': cmp = a.age.compareTo(b.age); break;
        case 'rating': cmp = a.rating.compareTo(b.rating); break;
        default: cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return _sortAscending ? cmp : -cmp;
    });

    final displayedPlayers = filteredPlayers.take(_visibleCount).toList();

    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          AppHeader(
            onMenuPressed: isDesktop ? null : () => _scaffoldKey.currentState?.openDrawer(),
            onSearchChanged: (value) => setState(() {
              _searchQuery = value.toLowerCase();
              _visibleCount = 100;
            }),
          ),
          FilterBar(
            onFilterApplied: (filters) => setState(() {
              _activeFilters = filters;
              _visibleCount = 100;
            }),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        _buildStatsGrid(isDesktop, filteredPlayers.length),
                        const SizedBox(height: 32),
                        _buildResultsHeader(filteredPlayers.length),
                        const SizedBox(height: 24),
                        // Grid oder Tabelle
                        _isGridView
                            ? GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 1),
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: displayedPlayers.length,
                                itemBuilder: (context, index) => PlayerCard(player: displayedPlayers[index]),
                              )
                            : _buildPlayerTable(displayedPlayers),
                        const SizedBox(height: 40),
                        if (_visibleCount < filteredPlayers.length) _buildLoadMoreButton(),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Entdecke Talente', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('$count Ergebnisse gefunden', style: const TextStyle(color: AppColors.mutedForeground)),
          ],
        ),
        Row(
          children: [
            // _buildSortDropdown(),
            const SizedBox(width: 12),
            _buildViewToggleButton(LucideIcons.layoutGrid, true),
            _buildViewToggleButton(LucideIcons.list, false),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDesktop, int total) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: isDesktop ? 4 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.8,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StatCard(label: "Spieler", value: total.toString(), icon: LucideIcons.users, iconColor: AppColors.primary, change: ""),
        const StatCard(label: "Tore", value: "842", icon: LucideIcons.trophy, iconColor: AppColors.accent, change: ""),
        const StatCard(label: "Schnitt", value: "1.2", icon: LucideIcons.trendingUp, iconColor: AppColors.primary, change: ""),
        const StatCard(label: "Vereine", value: "24", icon: LucideIcons.shield, iconColor: AppColors.mutedForeground, change: ""),
      ],
    );
  }

  // Widget _buildSortDropdown() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     decoration: BoxDecoration(
  //         color: AppColors.input, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<String>(
  //         value: _sortBy,
  //         items: const [
  //           DropdownMenuItem(value: 'name', child: Text('Name A-Z', style: TextStyle(fontSize: 13))),
  //           DropdownMenuItem(value: 'goals', child: Text('Meiste Tore', style: TextStyle(fontSize: 13))),
  //         ],
  //         onChanged: (value) => setState(() => _sortBy = value!),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildLoadMoreButton() {
    return ElevatedButton(
      onPressed: () => setState(() => _visibleCount += 100),
      child: const Text('Mehr laden'),
    );
  }

  Widget _buildViewToggleButton(IconData icon, bool isGridButton) {
    bool isActive = _isGridView == isGridButton;

    return GestureDetector(
      onTap: () => setState(() => _isGridView = isGridButton),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isActive ? Colors.white : AppColors.mutedForeground,
        ),
      ),
    );
  }



  Widget _buildPlayerTable(List<Player> players) {
    return Container(
      clipBehavior: Clip.antiAlias, // Rundet auch den Inhalt (Header) ab
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Theme(
          // Entfernt die Standard-Divider von Flutter für einen cleanen Look
          data: Theme.of(context).copyWith(
            dividerColor: AppColors.border.withOpacity(0.5),
          ),
          child: DataTable(
            horizontalMargin: 24,
            columnSpacing: 40,
            dataRowMaxHeight: 64,
            dataRowMinHeight: 48,
            headingRowColor: MaterialStateProperty.all(
              AppColors.muted.withOpacity(0.15),
            ),
            // Zebra-Effekt oder Hover-Farbe
            showCheckboxColumn: false,
            columns: [
              _buildSortableHeader("Name", "name"),
              _buildSortableHeader("Alter", "age"),
              _buildSortableHeader("Spiele", "matches"),
              _buildSortableHeader("Tore", "goals"),
              _buildSortableHeader("Rating", "rating"),
              const DataColumn(
                label: Text("Club", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.mutedForeground)
                )
              ),
            ],
           // ... innerhalb von DataTable in _buildPlayerTable
rows: players.map((p) {
  return DataRow(
    // Hier passiert die Magie: Die gesamte Zeile wird klickbar
    onSelectChanged: (selected) {
      if (selected != null && selected) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerDetailScreen(player: p),
          ),
        );
      }
    },
    cells: [
      DataCell(
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(p.name[0], 
                style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)
              ),
            ),
            const SizedBox(width: 12),
            Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ],
        ),
      ),
      // ... die restlichen DataCells bleiben gleich
      DataCell(Text(p.age.toString(), style: const TextStyle(color: AppColors.mutedForeground))),
      DataCell(Text(p.matches.toString(), style: const TextStyle(fontWeight: FontWeight.w500))),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: p.goals > 10 ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(p.goals.toString(), 
            style: TextStyle(
              color: p.goals > 10 ? AppColors.accent : AppColors.foreground,
              fontWeight: p.goals > 10 ? FontWeight.bold : FontWeight.normal
            )
          ),
        ),
      ),
      DataCell(_buildRatingBadge(p.rating)),
      DataCell(Text(p.club, style: const TextStyle(fontSize: 13))),
    ],
  );
}).toList(),
          ),
        ),
      ),
    );
  }

  // Hilfs-Widget für ein schickes Rating-Badge
  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Text(
        rating.toStringAsFixed(1),
        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  // Verbessertes Header-Styling mit Sortier-Indikator
  DataColumn _buildSortableHeader(String label, String key) {
    bool isSelected = _sortColumn == key;

    return DataColumn(
      onSort: (_, __) {
        setState(() {
          if (_sortColumn == key) {
            _sortAscending = !_sortAscending;
          } else {
            _sortColumn = key;
            _sortAscending = false; // Meistens will man die höchsten Werte zuerst sehen (z.B. Tore)
          }
        });
      },
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.1,
              fontWeight: FontWeight.bold,
              color: isSelected ? AppColors.primary : AppColors.mutedForeground,
            ),
          ),
          const SizedBox(width: 4),
          if (isSelected)
            Icon(
              _sortAscending ? LucideIcons.arrowUp : LucideIcons.arrowDown,
              size: 14,
              color: AppColors.primary,
            )
          else
            Icon(LucideIcons.chevronsUpDown, size: 12, color: AppColors.mutedForeground.withOpacity(0.3)),
        ],
      ),
    );
  }
}