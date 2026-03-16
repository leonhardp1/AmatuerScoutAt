import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

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