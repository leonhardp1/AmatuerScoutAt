import 'package:amateur_scout_at/models/club.dart';
import 'package:amateur_scout_at/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import '../widgets/header.dart'; 
import '../widgets/player_card.dart';
import '../widgets/stat_card.dart';
import 'package:provider/provider.dart';

// --- HIER IST DEIN FILTERBAR WIDGET ---
class FilterBar extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterApplied;

  const FilterBar({super.key, required this.onFilterApplied});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String? selectedBundesland;
  String? selectedLiga;
  String? selectedPosition;

  final Map<String, List<String>> bundeslandDaten = {
    "Salzburg": ["Salzburger Liga", "1. Landesliga", "2. Landesliga Nord", "2. Landesliga Süd"],
    "Wien": ["Stadtliga", "2. Landesliga", "Oberliga"],
    "Oberösterreich": ["OÖ Liga", "Landesliga Ost", "Landesliga West"],
    "Niederösterreich": ["1. Landesliga", "2. Landesliga Ost", "2. Landesliga West"],
    "Steiermark": ["Landesliga", "Oberliga Nord", "Oberliga Mitte"],
    "Kärnten": ["Kärntner Liga", "Unterliga West", "Unterliga Ost"],
    "Tirol": ["Tiroler Liga", "Landesliga West", "Landesliga Ost"],
    "Burgenland": ["Burgenlandliga", "II. Liga Nord", "II. Liga Mitte"],
    "Vorarlberg": ["Vorarlberg-Liga", "Landesliga"],
  };

  void _notifyChange() {
    widget.onFilterApplied({
      'bundesland': selectedBundesland,
      'liga': selectedLiga,
      'position': selectedPosition,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Icon(LucideIcons.slidersHorizontal, size: 18, color: AppColors.primary),
            const SizedBox(width: 20),
            
            _buildCompactDropdown(
              hint: "Region",
              value: selectedBundesland,
              items: bundeslandDaten.keys.toList(),
              onChanged: (val) => setState(() {
                selectedBundesland = val;
                selectedLiga = null;
                _notifyChange();
              }),
            ),
            const SizedBox(width: 12),
            _buildCompactDropdown(
              hint: "Liga",
              value: selectedLiga,
              items: selectedBundesland != null ? bundeslandDaten[selectedBundesland]! : [],
              onChanged: selectedBundesland == null ? null : (val) => setState(() {
                selectedLiga = val;
                _notifyChange();
              }),
            ),
            const SizedBox(width: 12),
            _buildCompactDropdown(
              hint: "Position",
              value: selectedPosition,
              items: ["Tor", "Verteidigung", "Mittelfeld", "Sturm"],
              onChanged: (val) => setState(() {
                selectedPosition = val;
                _notifyChange();
              }),
            ),
            if (selectedBundesland != null || selectedPosition != null) ...[
              const SizedBox(width: 20),
              TextButton.icon(
                onPressed: () => setState(() {
                  selectedBundesland = null;
                  selectedLiga = null;
                  selectedPosition = null;
                  _notifyChange();
                }),
                icon: const Icon(LucideIcons.x, size: 14),
                label: const Text("Reset"),
                style: TextButton.styleFrom(foregroundColor: AppColors.accent),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDropdown({required String hint, required String? value, required List<String> items, required ValueChanged<String?>? onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.input,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(fontSize: 13, color: AppColors.mutedForeground)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: onChanged,
          dropdownColor: AppColors.card,
          icon: const Icon(LucideIcons.chevronDown, size: 14),
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

 Future<void> _loadInitialData() async {
  final appState = Provider.of<AppState>(context, listen: false);

  setState(() => _isLoading = true);

  try {
    // Lädt alles und speichert automatisch in AppState
    await appState.loadAllData();

    // Spieler in lokale Liste kopieren, damit Filter/Search funktioniert
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

    List<Player> filteredPlayers = _allPlayers.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery) || 
                            p.club.toLowerCase().contains(_searchQuery);
      bool matchesFilters = true;
      if (_activeFilters['bundesland'] != null) matchesFilters = matchesFilters && p.region == _activeFilters['bundesland'];
      if (_activeFilters['liga'] != null) matchesFilters = matchesFilters && p.leagueName == _activeFilters['liga'];
      if (_activeFilters['position'] != null) matchesFilters = matchesFilters && p.position == _activeFilters['position'];
      return matchesSearch && matchesFilters;
    }).toList();

    if (_sortBy == 'goals') {
      filteredPlayers.sort((a, b) => b.goals.compareTo(a.goals));
    } else {
      filteredPlayers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

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
          
          // JETZT RICHTIG EINGEBUNDEN:
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
                      GridView.builder(
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
                      ),
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
        _buildSortDropdown(),
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

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.input, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          items: const [
            DropdownMenuItem(value: 'name', child: Text('Name A-Z', style: TextStyle(fontSize: 13))),
            DropdownMenuItem(value: 'goals', child: Text('Meiste Tore', style: TextStyle(fontSize: 13))),
          ],
          onChanged: (value) => setState(() => _sortBy = value!),
        ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return ElevatedButton(
      onPressed: () => setState(() => _visibleCount += 100),
      child: const Text('Mehr laden'),
    );
  }
}