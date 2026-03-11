import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class FilterSidebar extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFilterApplied;

  const FilterSidebar({super.key, this.onFilterApplied});

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  String? selectedBundesland;
  String? selectedLiga;
  String? selectedPosition;
  RangeValues ageRange = const RangeValues(16, 45);
  RangeValues goalsRange = const RangeValues(0, 50);

  // Datenstruktur für die Bundesländer und deren spezifische Ligen
  final Map<String, List<String>> bundeslandDaten = {
    "Kärnten": [
      "Regionalliga Mitte", "Kärntner Liga", "1. Klasse Mitte", "1. Klasse West", 
      "1. Klasse Ost", "2. Klasse A", "2. Klasse B", "2. Klasse C", "2. Klasse D"
    ],
    "Tirol": [
      "HYPO TIROL Liga", "Landesliga Ost", "Landesliga West", "tt.com Regionalliga Tirol", 
      "1. Klasse Ost", "1. Klasse West", "2. Klasse West", "2. Klasse Ost", "2. Klasse Mitte"
    ],
    "Burgenland": [
      "Burgenland Energie Landesliga", "Regionalliga Ost", "1. Klasse Nord", 
      "1. Klasse Mitte", "1. Klasse Süd", "II. Liga Nord", "II. Liga Mitte", 
      "II. Liga Süd", "2. Klasse Nord", "2. Klasse Süd A", "2. Klasse Süd B"
    ],
    "Niederösterreich": [
      "11teamsports 1. Landesliga", "2. Landesliga Ost", "2. Landesliga West", 
      "1. Klasse Waldviertel", "1. Klasse West", "1. Klasse Nord", "1. Klasse Ost", 
      "1. Klasse Nordwest", "1. Klasse West/Mitte", "1. Klasse Süd", 
      "1. Klasse Nordwest-Mitte", "2. Klasse Traisental", "2. Klasse Wachau/Donau", 
      "2. Klasse Ost/Mitte", "2. Klasse Thayatal", "2. Klasse Waldviertel Süd/Yspertal", 
      "2. Klasse Pulkau-, Schmidatal", "2. Klasse Steinfeld", "2. Klasse Ybbstal", 
      "2. Klasse Weinviertel", "2. Klasse Marchfeld", "2. Klasse Ost", 
      "2. Klasse Mostviertel", "2. Klasse Waldviertel Zentral", "2. Klasse Wechsel", 
      "2. Klasse Triestingtal"
    ],
    "Wien": [
      "2. Landesliga", "1. Klasse A", "1. Klasse B", "DSG LIGA", 
      "DSG 1. Klasse A", "DSG 1. Klasse B", "DSG 2. Klasse A", "DSG 2. Klasse B"
    ],
    "Salzburg": [
      "Regionalliga West", "Salzburger Liga", "1. Landesliga", "2. Landesliga Nord", 
      "2. Landesliga Süd", "1. Klasse Nord", "1. Klasse Süd", "2. Klasse Nord A", 
      "2. Klasse Nord B", "2. Klasse Süd - Grunddurchgang A", "2. Klasse Süd - Grunddurchgang B", 
      "2. Klasse Süd - Oberes Play-Off", "2. Klasse Süd - Unteres Play-Off"
    ],
    "Vorarlberg": ["Landesliga"],
    "Oberösterreich": [
      "LT1 OÖ Liga", "Landesliga Ost", "Landesliga West", "1. Mitte", "1. Mittewest", 
      "1. Nord", "1. Nordost", "1. Nordwest", "1. Ost", "1. Süd", "1. Südwest", 
      "2. Mitte", "2. Mittewest", "2. Nordmitte", "2. Nordost", "2. Nordwest", 
      "2. Ost", "2. Süd", "2. Südwest", "2. West", "2. Westnord"
    ],
    "Steiermark": [
      "Regionalliga Mitte", "Landesliga", "Oberliga", "Unterliga", "Gebietsliga", "1. Klasse"
    ],
  };

// In FilterSidebar.dart die Liste ändern:
final List<String> positions = ["Tor", "Verteidigung", "Mittelfeld", "Sturm"];
  void _applyFilters() {
    if (widget.onFilterApplied != null) {
      widget.onFilterApplied!({
        'bundesland': selectedBundesland,
        'liga': selectedLiga,
        'position': selectedPosition,
        'ageMin': ageRange.start.toInt(),
        'ageMax': ageRange.end.toInt(),
        'goalsMin': goalsRange.start.toInt(),
        'goalsMax': goalsRange.end.toInt(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Liste der Ligen basierend auf dem gewählten Bundesland
    List<String> aktuelleLigen = selectedBundesland != null 
        ? bundeslandDaten[selectedBundesland]! 
        : [];

    return Container(
      width: 300,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(right: BorderSide(color: AppColors.sidebarBorder)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.sidebarBorder)),
            ),
            child: Row(
              children: [
                Icon(LucideIcons.slidersHorizontal, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.foreground),
                ),
              ],
            ),
          ),

          // Scrollbare Sektionen
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _FilterSection(
                    title: 'Region & Wettbewerb',
                    icon: LucideIcons.mapPin,
                    iconColor: AppColors.primary,
                    children: [
                      _buildDropdown(
                        label: 'Bundesland',
                        value: selectedBundesland,
                        items: bundeslandDaten.keys.toList()..sort(),
                        onChanged: (value) => setState(() {
                          selectedBundesland = value;
                          selectedLiga = null; // Reset Liga bei Bundeslandwechsel
                        }),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        label: 'Liga',
                        value: selectedLiga,
                        items: aktuelleLigen,
                        // Deaktivieren, wenn kein Bundesland gewählt wurde
                        onChanged: selectedBundesland == null 
                            ? null 
                            : (value) => setState(() => selectedLiga = value),
                      ),
                    ],
                  ),
                  _FilterSection(
                    title: 'Spieler Profil',
                    icon: LucideIcons.user,
                    iconColor: AppColors.accent,
                    children: [
                      _buildDropdown(
                        label: 'Position',
                        value: selectedPosition,
                        items: positions,
                        onChanged: (value) => setState(() => selectedPosition = value),
                      ),
                      const SizedBox(height: 16),
                      _buildRangeSlider(
                        label: 'Alter',
                        values: ageRange,
                        min: 16,
                        max: 45,
                        onChanged: (values) => setState(() => ageRange = values),
                      ),
                    ],
                  ),
                  _FilterSection(
                    title: 'Statistiken',
                    icon: LucideIcons.trophy,
                    iconColor: Colors.orange,
                    children: [
                      _buildRangeSlider(
                        label: 'Tore',
                        values: goalsRange,
                        min: 0,
                        max: 100,
                        onChanged: (values) => setState(() => goalsRange = values),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Buttons am Ende
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.sidebarBorder)),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Filter anwenden', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedBundesland = null;
                      selectedLiga = null;
                      selectedPosition = null;
                      ageRange = const RangeValues(16, 45);
                      goalsRange = const RangeValues(0, 100);
                    });
                  },
                  child: const Text('Zurücksetzen', style: TextStyle(color: AppColors.mutedForeground)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label, 
    required String? value, 
    required List<String> items, 
    required ValueChanged<String?>? onChanged
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.input,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: AppColors.card,
              disabledHint: const Text("Zuerst Region wählen", style: TextStyle(fontSize: 13)),
              hint: Text("Alle $label", style: const TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
              items: items.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 14)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRangeSlider({
    required String label, 
    required RangeValues values, 
    required double min, 
    required double max, 
    required ValueChanged<RangeValues> onChanged
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground)),
            Text('${values.start.toInt()} - ${values.end.toInt()}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        RangeSlider(
          values: values,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _FilterSection extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _FilterSection({required this.title, required this.icon, required this.iconColor, required this.children});

  @override
  State<_FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<_FilterSection> {
  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => setState(() => isExpanded = !isExpanded),
          leading: Icon(widget.icon, size: 18, color: widget.iconColor),
          title: Text(widget.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          trailing: Icon(isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown, size: 16),
          dense: true,
        ),
        if (isExpanded) 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
            child: Column(children: widget.children),
          ),
        const Divider(color: AppColors.sidebarBorder, height: 1),
      ],
    );
  }
}