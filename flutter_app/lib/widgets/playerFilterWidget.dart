import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class PlayerFilterWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterChanged;

  const PlayerFilterWidget({
    super.key,
    required this.onFilterChanged,
  });

  @override
  State<PlayerFilterWidget> createState() => _PlayerFilterWidgetState();
}

class _PlayerFilterWidgetState extends State<PlayerFilterWidget> {
  final Map<String, List<String>> bundeslandDaten = {
    "Salzburg": ["Salzburger Liga", "1. Landesliga", "2. Landesliga Nord", "2. Landesliga Süd"],
    "Wien": ["Stadtliga", "2. Landesliga", "Oberliga"],
    "Steiermark": ["Landesliga", "Oberliga", "Unterliga"],
    "Oberösterreich": ["OÖ Liga", "Landesliga"],
  };

  String? selectedRegion;
  String? selectedLeague;
  String searchName = "";
  Set<String> selectedPositions = {};

  RangeValues ageRange = const RangeValues(18, 30);
  RangeValues ratingRange = const RangeValues(50, 90);
  RangeValues gamesRange = const RangeValues(10, 50);
  RangeValues goalsRange = const RangeValues(5, 25);

  /// Diese Funktion sammelt alle aktuellen Daten und schickt sie ans Parent
  void _triggerFilter() {
    widget.onFilterChanged({
      "searchName": searchName,
      "region": selectedRegion,
      "league": selectedLeague,
      "positions": selectedPositions.toList(),
      "ageMin": ageRange.start.round(),
      "ageMax": ageRange.end.round(),
      "ratingMin": ratingRange.start.round(),
      "ratingMax": ratingRange.end.round(),
      "gamesMin": gamesRange.start.round(),
      "gamesMax": gamesRange.end.round(),
      "goalsMin": goalsRange.start.round(),
      "goalsMax": goalsRange.end.round(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- HEADER & SEARCH ---
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  "Region",
                  selectedRegion,
                  bundeslandDaten.keys.toList(),
                  (v) => setState(() {
                    selectedRegion = v;
                    selectedLeague = null; // Reset Liga wenn Region sich ändert
                    _triggerFilter();
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  "Liga",
                  selectedLeague,
                  bundeslandDaten[selectedRegion] ?? [],
                  (v) => setState(() {
                    selectedLeague = v;
                    _triggerFilter();
                  }),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (v) {
                    searchName = v;
                    _triggerFilter();
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Suche nach Spielern oder Vereinen...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(LucideIcons.search, size: 20, color: Colors.white38),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- SPIELFELD (LINKS) ---
              _buildTacticalField(),

              const SizedBox(width: 40),

              /// --- SLIDER GRID (RECHTS) ---
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 40,
                  childAspectRatio: 2.5,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildRangeSlider("Alter", ageRange, 15, 45, (v) {
                      setState(() => ageRange = v);
                      _triggerFilter();
                    }),
                    _buildRangeSlider("Rating", ratingRange, 0, 99, (v) {
                      setState(() => ratingRange = v);
                      _triggerFilter();
                    }),
                    _buildRangeSlider("Spiele", gamesRange, 0, 100, (v) {
                      setState(() => gamesRange = v);
                      _triggerFilter();
                    }),
                    _buildRangeSlider("Tore", goalsRange, 0, 100, (v) {
                      setState(() => goalsRange = v);
                      _triggerFilter();
                    }),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTacticalField() {
    return Container(
      width: 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 2),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: 140,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10, width: 2),
              ),
            ),
          ),
          
          _posBtn("ST", 0.1, 0.5),
          _posBtn("LF", 0.2, 0.15),
          _posBtn("RF", 0.2, 0.85),
          _posBtn("ZOM", 0.35, 0.5),
          _posBtn("ZM", 0.55, 0.5),
          _posBtn("LV", 0.75, 0.15),
          _posBtn("IV", 0.8, 0.5),
          _posBtn("RV", 0.75, 0.85),
          _posBtn("TW", 0.92, 0.5),
        ],
      ),
    );
  }

  Widget _posBtn(String label, double top, double left) {
    bool isSelected = selectedPositions.contains(label);
    return Align(
      alignment: Alignment(left * 2 - 1, top * 2 - 1),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isSelected ? selectedPositions.remove(label) : selectedPositions.add(label);
          });
          _triggerFilter();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              if (isSelected) 
                BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 8)
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRangeSlider(String title, RangeValues values, double min, double max, Function(RangeValues) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
            Text(
              "${values.start.round()} - ${values.end.round()}",
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.border,
            thumbColor: Colors.white,
            overlayColor: AppColors.primary.withOpacity(0.1),
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String hint, String? value, List<String> items, Function(String?) onChanged) {
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