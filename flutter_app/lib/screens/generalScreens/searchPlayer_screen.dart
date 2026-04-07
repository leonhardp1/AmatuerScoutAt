import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/header.dart';
import '../../widgets/playerFilterWidget.dart';
import '../../widgets/player_results_view.dart';
import '../../services/api_service.dart';
import '../../models/player.dart';

class SearchPlayerScreen extends StatefulWidget {
  const SearchPlayerScreen({super.key});

  @override
  State<SearchPlayerScreen> createState() => _SearchPlayerScreenState();
}

class _SearchPlayerScreenState extends State<SearchPlayerScreen> {
  List<Player> _players = [];
  bool _isLoading = false;
  bool _isLoadMoreLoading = false;
  bool _hasMoreData = true; // Steuert die Sichtbarkeit des Buttons
  
  Map<String, dynamic> _currentFilters = {};
  Timer? _debounce;

  int _currentOffset = 0;
  final int _pageSize = 20;

  bool _isGridView = true;
  String _sortColumn = 'name';
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _performSearch(isInitialSearch: true);
  }

  void _onFilterChanged(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _currentOffset = 0;
      _hasMoreData = true; // Wichtig: Zurücksetzen bei neuem Filter
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(isInitialSearch: true);
    });
  }

  Future<void> _performSearch({bool isInitialSearch = true}) async {
    if (isInitialSearch) {
      setState(() {
        _isLoading = true;
        _currentOffset = 0;
        _players = []; // Liste leeren für neue Suche
      });
    } else {
      setState(() => _isLoadMoreLoading = true);
    }

    final results = await ApiService.searchPlayersWithConditions(
      _currentFilters,
      offset: _currentOffset,
      limit: _pageSize,
    );
    
    if (mounted) {
      setState(() {
        if (isInitialSearch) {
          _players = results;
        } else {
          _players.addAll(results);
        }
        
        _isLoading = false;
        _isLoadMoreLoading = false;
        
        // --- DER ENTSCHEIDENDE CHECK ---
        // Wenn wir weniger bekommen als wir wollten, ist die DB leer.
        if (results.length < _pageSize) {
          _hasMoreData = false;
        } else {
          _hasMoreData = true;
        }
        
        // Erhöhe den Offset um die Anzahl der wirklich geladenen Spieler
        _currentOffset += results.length;
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
                  const Text("Spieler suchen", 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  PlayerFilterWidget(onFilterChanged: _onFilterChanged),
                  const SizedBox(height: 40),
                  
                  // Header Result Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Ergebnisse (${_players.length})",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      Row(
                        children: [
                          if (_isLoading) const SizedBox(width: 20, height: 20, 
                             child: CircularProgressIndicator(strokeWidth: 2)),
                          const SizedBox(width: 15),
                          _buildToggle(LucideIcons.layoutGrid, true),
                          const SizedBox(width: 8),
                          _buildToggle(LucideIcons.list, false),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Die Spieler-Liste / Grid
                  _buildResultsArea(screenWidth),

                  // --- MEHR LADEN BUTTON ---
                  if (_hasMoreData && _players.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: _isLoadMoreLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3B82F6),
                                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                onPressed: () => _performSearch(isInitialSearch: false),
                                child: const Text("Mehr Spieler laden", 
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                      ),
                    ),
                  
                  // "Ende der Liste" Hinweis
                  if (!_hasMoreData && _players.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text("Alle Spieler geladen", 
                        style: TextStyle(color: Colors.white24))),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(IconData icon, bool grid) {
    bool active = _isGridView == grid;
    return GestureDetector(
      onTap: () => setState(() => _isGridView = grid),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF3B82F6) : Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20, color: active ? Colors.white : Colors.white54),
      ),
    );
  }

  Widget _buildResultsArea(double width) {
    if (_isLoading && _players.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.only(top: 80), child: CircularProgressIndicator()));
    }
    if (!_isLoading && _players.isEmpty) {
      return const Center(child: Padding(padding: EdgeInsets.only(top: 80), 
        child: Text("Keine Spieler gefunden", style: TextStyle(color: Colors.white54))));
    }

    return PlayerResultsView(
      players: _players,
      isGridView: _isGridView,
      isDesktop: width > 1024,
      isTablet: width > 600,
      sortColumn: _sortColumn,
      sortAscending: _sortAscending,
      onSort: (key) {
        setState(() {
          if (_sortColumn == key) _sortAscending = !_sortAscending;
          else { _sortColumn = key; _sortAscending = true; }
          // Lokale Sortierung der bereits geladenen Spieler
          _players.sort((a, b) {
            return _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name);
          });
        });
      },
    );
  }
}