import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/coach.dart';
import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header.dart';
import '../../widgets/coach_results_view.dart';
import '../../widgets/trainer_filter.dart';

class SearchCoachScreen extends StatefulWidget {
  const SearchCoachScreen({super.key});

  @override
  State<SearchCoachScreen> createState() => _SearchCoachScreenState();
}

class _SearchCoachScreenState extends State<SearchCoachScreen> {
  List<Coach> _coaches = [];
  bool _isLoading = false;
  
  // Zentrale Filter-Map (Suche, Lizenz, Region etc.)
  Map<String, dynamic> _filters = {};
  
  // State für die Ansicht (Grid oder Liste)
  bool _isGrid = true;
  
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _performSearch();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Die zentrale Methode, um die API mit den aktuellen Filtern aufzurufen
  Future<void> _performSearch() async {
    setState(() => _isLoading = true);
    
    try {
      // Nutzt deine searchCoachesWithConditions Methode im ApiService
      final results = await ApiService.searchCoachesWithConditions(_filters);
      
      if (mounted) {
        setState(() {
          _coaches = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Fehler beim Laden der Trainer: $e");
      if (mounted) {
        setState(() {
          _coaches = [];
          _isLoading = false;
        });
      }
    }
  }

  /// Wird aufgerufen, wenn sich Filter im TrainerFilter-Widget 
  /// oder die Suche im AppHeader ändert.
  void _onFilterChanged(Map<String, dynamic> newFilters) {
    setState(() {
      _filters = newFilters;
    });

    // Debounce, um die Datenbank bei schnellen Eingaben zu schonen
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: Column(
        children: [
          // Header mit integrierter Suche
          AppHeader(
            currentPage: "trainer",
            onSearchChanged: (val) {
              // Aktualisiert den "search" Key in den Filtern
              _onFilterChanged({..._filters, "search": val});
            },
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Trainer finden",
                    style: TextStyle(
                      fontSize: 26, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Trefferanzeige & Loader
                  Row(
                    children: [
                      Text(
                        "${_coaches.length} Trainer gefunden",
                        style: const TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(width: 12),
                      if (_isLoading)
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, 
                            color: AppColors.primary
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Filter-Sektion (Weißes Card-Design)
                  TrainerFilter(onFilterChanged: _onFilterChanged),

                  const SizedBox(height: 32),

                  // Ansichts-Umschalter (Grid/List)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildViewToggle(LucideIcons.layoutGrid, true),
                      const SizedBox(width: 8),
                      _buildViewToggle(LucideIcons.list, false),
                    ],
                  ),
                  
                  const SizedBox(height: 24),

                  // Ergebnis-Bereich
                  _buildResultsArea(width),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(IconData icon, bool isGridMode) {
    final bool active = _isGrid == isGridMode;
    return GestureDetector(
      onTap: () => setState(() => _isGrid = isGridMode),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? AppColors.primary : Colors.white.withOpacity(0.05),
          ),
        ),
        child: Icon(
          icon, 
          size: 20, 
          color: active ? AppColors.primary : Colors.white38
        ),
      ),
    );
  }

  Widget _buildResultsArea(double width) {
    if (_isLoading && _coaches.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_isLoading && _coaches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Column(
            children: [
              Icon(LucideIcons.userX, size: 60, color: Colors.white.withOpacity(0.1)),
              const SizedBox(height: 16),
              const Text(
                "Keine Trainer mit diesen Kriterien gefunden.",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    // Nutzt dein CoachResultsView Widget zur Darstellung
    return CoachResultsView(
      coaches: _coaches,
      isGridView: _isGrid,
      isDesktop: width > 1024,
      isTablet: width > 600,
      sortColumn: "name", 
      sortAscending: true,
      onSort: (key) {
        // Optionale lokale Sortierung
        setState(() {
          _coaches.sort((a, b) => a.name.compareTo(b.name));
        });
      },
    );
  }
}