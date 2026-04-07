import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import 'club_resuslts_view.dart'; // Wichtig für ligenMap

class ClubFilterWidget extends StatelessWidget {
  final String? selectedRegion;
  final String? selectedLeague;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final Function(String?) onRegionChanged;
  final Function(String?) onLeagueChanged;
  final VoidCallback onReset;

  const ClubFilterWidget({
    super.key,
    required this.selectedRegion,
    required this.selectedLeague,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onRegionChanged,
    required this.onLeagueChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card, // Nutzt dein Theme
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.filter, size: 20, color: AppColors.primary),
              const SizedBox(width: 10),
              const Text(
                "Vereins-Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                onPressed: onReset,
                icon: const Icon(LucideIcons.rotateCcw, size: 18, color: Colors.white38),
                tooltip: "Filter zurücksetzen",
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // REGION
              Expanded(
                child: _buildDropdown(
                  context,
                  "Region",
                  selectedRegion,
                  ClubResultsView.ligenMap.keys.toList(),
                  onRegionChanged,
                ),
              ),
              const SizedBox(width: 16),

              // LIGA
              Expanded(
                child: _buildDropdown(
                  context,
                  "Liga",
                  selectedLeague,
                  selectedRegion == null ? [] : ClubResultsView.ligenMap[selectedRegion]!,
                  onLeagueChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // SUCHE
          TextField(
            onChanged: onSearchChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Nach Vereinsname oder Stadion suchen...",
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(LucideIcons.search, size: 20, color: Colors.white38),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(BuildContext context, String hint, String? value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(fontSize: 14, color: Colors.white38)),
          isExpanded: true,
          dropdownColor: AppColors.card,
          iconEnabledColor: AppColors.primary,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}