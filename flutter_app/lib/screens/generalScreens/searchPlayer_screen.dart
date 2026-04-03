import 'dart:async';
import 'package:amateur_scout_at/widgets/header.dart';
import 'package:amateur_scout_at/widgets/playerFilterWidget.dart';
import 'package:amateur_scout_at/widgets/player_results_view.dart'; // Das neue Widget importieren
import 'package:amateur_scout_at/services/api_service.dart';
import 'package:amateur_scout_at/models/player.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:amateur_scout_at/theme/app_theme.dart'; // Falls deine Farben dort liegen

class SearchPlayerScreen extends StatefulWidget {
  const SearchPlayerScreen({super.key});

  @override
  State<SearchPlayerScreen> createState() => _SearchPlayerScreenState();
}

class _SearchPlayerScreenState extends State<SearchPlayerScreen> {
  List<Player> _players = [];
  bool _isLoading = false;
  Map<String, dynamic> _currentFilters = {};
  Timer? _debounce;

  // Zustände für das neue Result-Widget
  bool _isGridView = true;
  String _sortColumn = 'name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _performSearch(); // Initiales Laden beim Start
  }

  void _onFilterChanged(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  Future<void> _performSearch() async {
    setState(() => _isLoading = true);
    final results = await ApiService.searchPlayersWithConditions(_currentFilters);
    
    if (mounted) {
      setState(() {
        _players = results;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: Column(
        children: [
          AppHeader(
            currentPage: "spieler",
            onSearchChanged: (value) {
              _onFilterChanged({..._currentFilters, "searchName": value});
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Spieler suchen",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  PlayerFilterWidget(onFilterChanged: _onFilterChanged),

                  const SizedBox(height: 40),

                  /// --- ERGEBNISSE HEADER MIT TOGGLE BUTTON ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ergebnisse (${_players.length})",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Row(
                        children: [
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.only(right: 15),
                              child: SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          // Die Umschalt-Buttons
                          _buildViewToggleButton(LucideIcons.layoutGrid, true),
                          const SizedBox(width: 8),
                          _buildViewToggleButton(LucideIcons.list, false),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// --- SPIELER AREA (Grid oder Tabelle) ---
                  _buildResultsArea(screenWidth),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton(IconData icon, bool isGridButton) {
    bool isActive = _isGridView == isGridButton;
    return GestureDetector(
      onTap: () => setState(() => _isGridView = isGridButton),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3B82F6) : Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: isActive ? Colors.white : Colors.white54),
      ),
    );
  }

Widget _buildResultsArea(double width) {
  if (_isLoading && _players.isEmpty) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  if (!_isLoading && _players.isEmpty) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.white24),
            SizedBox(height: 16),
            Text(
              "Keine Spieler gefunden",
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Hier nutzen wir jetzt dein neues Widget!
  return PlayerResultsView(
    players: _players,
    isGridView: _isGridView,
    isDesktop: width > 1024,
    isTablet: width > 600,
    sortColumn: _sortColumn,
    sortAscending: _sortAscending,
    onSort: (key) {
      setState(() {
        if (_sortColumn == key) {
          _sortAscending = !_sortAscending;
        } else {
          _sortColumn = key;
          _sortAscending = false;
        }
        // Sortierung der Liste lokal
        _players.sort((a, b) {
          int cmp;
          switch (key) {
            case 'goals':
              cmp = a.goals.compareTo(b.goals);
              break;
            case 'matches':
              cmp = a.matches.compareTo(b.matches);
              break;
            case 'age':
              cmp = a.age.compareTo(b.age);
              break;
            case 'rating':
              cmp = a.rating.compareTo(b.rating);
              break;
            default:
              cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          }
          return _sortAscending ? cmp : -cmp;
        });
      });
    },
  );
}
}