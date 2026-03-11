import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import '../widgets/header.dart'; 
import '../widgets/filter_sidebar.dart';
import '../widgets/player_card.dart';
import '../widgets/stat_card.dart';

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
    try {
      final players = await _apiService.getPlayers();
      setState(() {
        _allPlayers = players;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Laden: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;
    final isTablet = screenWidth > 600;

    // --- VOLLSTÄNDIGE FILTER-LOGIK ---
    List<Player> filteredPlayers = _allPlayers.where((p) {
      // 1. Suche
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery) || 
                            p.club.toLowerCase().contains(_searchQuery);
      
      // 2. Sidebar Filter
      bool matchesSidebar = true;

      // Bundesland
      if (_activeFilters['bundesland'] != null) {
        matchesSidebar = matchesSidebar && p.region == _activeFilters['bundesland'];
      }
      
      // Liga
      if (_activeFilters['liga'] != null) {
        matchesSidebar = matchesSidebar && p.leagueName == _activeFilters['liga'];
      }

      // Position
      if (_activeFilters['position'] != null) {
        matchesSidebar = matchesSidebar && p.position == _activeFilters['position'];
      }

      // // Alter (Range)
      // if (_activeFilters['ageMin'] != null && _activeFilters['ageMax'] != null) {
      //   matchesSidebar = matchesSidebar && 
      //                    p.age >= _activeFilters['ageMin'] && 
      //                    p.age <= _activeFilters['ageMax'];
      // }

      // Tore (Range)
      if (_activeFilters['goalsMin'] != null && _activeFilters['goalsMax'] != null) {
        matchesSidebar = matchesSidebar && 
                         p.goals >= _activeFilters['goalsMin'] && 
                         p.goals <= _activeFilters['goalsMax'];
      }

      return matchesSearch && matchesSidebar;
    }).toList();

    // --- SORTIERUNG ---
    if (_sortBy == 'goals') {
      filteredPlayers.sort((a, b) => b.goals.compareTo(a.goals));
    } else {
      filteredPlayers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }

    final displayedPlayers = filteredPlayers.take(_visibleCount).toList();

    // Stats
    final totalPlayers = filteredPlayers.length;
    final totalGoals = filteredPlayers.fold<int>(0, (sum, p) => sum + p.goals);
    final avgGoals = totalPlayers > 0 ? (totalGoals / totalPlayers).toStringAsFixed(1) : "0";
    final activeClubs = filteredPlayers.map((p) => p.club).toSet().length;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isDesktop ? null : FilterSidebar(
        onFilterApplied: (filters) => setState(() {
          _activeFilters = filters;
          _visibleCount = 100;
          Navigator.pop(context);
        }),
      ),
      body: Row(
        children: [
          if (isDesktop) 
            FilterSidebar(
              onFilterApplied: (filters) => setState(() {
                _activeFilters = filters;
                _visibleCount = 100;
              }),
            ),
          
          Expanded(
            child: Column(
              children: [
                AppHeader(
                  onMenuPressed: isDesktop ? null : () => _scaffoldKey.currentState?.openDrawer(),
                  onSearchChanged: (value) => setState(() {
                    _searchQuery = value.toLowerCase();
                    _visibleCount = 100;
                  }),
                ),
                
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatsGrid(isDesktop, totalPlayers, totalGoals, avgGoals, activeClubs),
                            
                            const SizedBox(height: 32),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Entdecke Talente', 
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.foreground)),
                                    Text('$totalPlayers Ergebnisse gefunden', 
                                      style: const TextStyle(color: AppColors.mutedForeground)),
                                  ],
                                ),
                                _buildSortDropdown(),
                              ],
                            ),
                            
                            const SizedBox(height: 24),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 1),
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio: 0.75, // Leicht angepasst für Button Platz
                              ),
                              itemCount: displayedPlayers.length,
                              itemBuilder: (context, index) => PlayerCard(player: displayedPlayers[index]),
                            ),
                            
                            const SizedBox(height: 40),

                            if (_visibleCount < filteredPlayers.length)
                              _buildLoadMoreButton(),
                          ],
                        ),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isDesktop, int total, int goals, String avg, int clubs) {
    final stats = [
      {'label': 'Spieler', 'value': total.toString(), 'icon': LucideIcons.users, 'color': AppColors.primary},
      {'label': 'Tore gesamt', 'value': goals.toString(), 'icon': LucideIcons.trophy, 'color': AppColors.accent},
      {'label': 'Schnitt', 'value': avg, 'icon': LucideIcons.trendingUp, 'color': AppColors.primary},
      {'label': 'Vereine', 'value': clubs.toString(), 'icon': LucideIcons.shield, 'color': AppColors.mutedForeground},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isDesktop ? 1.8 : 1.4,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final s = stats[index];
        return StatCard(
          label: s['label'] as String,
          value: s['value'] as String,
          change: "", 
          icon: s['icon'] as IconData,
          iconColor: s['color'] as Color,
        );
      },
    );
  }

  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.input, 
        borderRadius: BorderRadius.circular(10), 
        border: Border.all(color: AppColors.border)
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sortBy,
          dropdownColor: AppColors.card,
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
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => setState(() => _visibleCount += 100),
        icon: const Icon(LucideIcons.plus, size: 18),
        label: const Text('Weitere 100 laden'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}