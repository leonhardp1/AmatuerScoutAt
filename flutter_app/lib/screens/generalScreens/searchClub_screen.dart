import 'dart:async';
import 'package:amateur_scout_at/widgets/club_resuslts_view.dart';
import 'package:amateur_scout_at/widgets/club_filter_widget.dart'; // Importieren!
import 'package:flutter/material.dart';
import '../../models/club.dart';
import '../../services/api_service.dart'; 
import '../../theme/app_theme.dart';
import '../../widgets/header.dart';

class SearchClubScreen extends StatefulWidget {
  const SearchClubScreen({super.key});

  @override
  State<SearchClubScreen> createState() => _SearchClubScreenState();
}

class _SearchClubScreenState extends State<SearchClubScreen> {
  List<Club> _clubs = [];
  bool _isLoading = false;
  bool _isLoadMoreLoading = false;
  bool _hasMoreData = true;

  String _searchQuery = "";
  String? _selectedRegion;
  String? _selectedLeague;
  
  int _currentOffset = 0;
  final int _pageSize = 20;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _performSearch(isInitialSearch: true);
  }

  Future<void> _performSearch({bool isInitialSearch = true}) async {
    if (isInitialSearch) {
      setState(() {
        _isLoading = true;
        _currentOffset = 0;
        _hasMoreData = true;
        _clubs = [];
      });
    } else {
      setState(() => _isLoadMoreLoading = true);
    }
    
    try {
      final results = await ApiService.searchClubsWithConditions(
        query: _searchQuery, 
        region: _selectedRegion, 
        league: _selectedLeague,
        
      );
      
      if (mounted) {
        setState(() {
          if (isInitialSearch) {
            _clubs = results;
          } else {
            _clubs.addAll(results);
          }
          _isLoading = false;
          _isLoadMoreLoading = false;
          if (results.length < _pageSize) _hasMoreData = false;
          _currentOffset += results.length;
        });
      }
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _isLoadMoreLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      body: Column(
        children: [
          AppHeader(
            currentPage: "vereine",
            onSearchChanged: (val) {
              _searchQuery = val;
              _performSearch(isInitialSearch: true);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Vereine", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 8),
                  Text("${_clubs.length} Vereine gefunden", style: const TextStyle(color: Colors.white54)),
                  const SizedBox(height: 24),

                  // HIER WIRD DAS NEUE WIDGET EINGESETZT
                  ClubFilterWidget(
                    selectedRegion: _selectedRegion,
                    selectedLeague: _selectedLeague,
                    searchQuery: _searchQuery,
                    onSearchChanged: (val) {
                      _searchQuery = val;
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () => _performSearch(isInitialSearch: true));
                    },
                    onRegionChanged: (val) {
                      setState(() {
                        _selectedRegion = val;
                        _selectedLeague = null;
                      });
                      _performSearch(isInitialSearch: true);
                    },
                    onLeagueChanged: (val) {
                      setState(() => _selectedLeague = val);
                      _performSearch(isInitialSearch: true);
                    },
                    onReset: () {
                      setState(() {
                        _selectedRegion = null;
                        _selectedLeague = null;
                        _searchQuery = "";
                      });
                      _performSearch(isInitialSearch: true);
                    },
                  ),

                  const SizedBox(height: 32),
                  _buildResultsArea(screenWidth),

                  if (_hasMoreData && _clubs.isNotEmpty)
                    _buildLoadMoreButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: _isLoadMoreLoading
            ? const CircularProgressIndicator(color: AppColors.primary)
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _performSearch(isInitialSearch: false),
                child: const Text("Mehr Vereine laden", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
      ),
    );
  }

  Widget _buildResultsArea(double screenWidth) {
    if (_isLoading && _clubs.isEmpty) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    return ClubResultsView(
      clubs: _clubs,
      isGridView: false,
      isDesktop: screenWidth > 1024,
      sortColumn: "name",
      sortAscending: true,
      onSort: (col) {},
    );
  }
}