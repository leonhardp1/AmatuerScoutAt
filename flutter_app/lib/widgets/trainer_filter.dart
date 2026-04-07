import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class TrainerFilter extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterChanged;

  const TrainerFilter({super.key, required this.onFilterChanged});

  @override
  State<TrainerFilter> createState() => _TrainerFilterState();
}

class _TrainerFilterState extends State<TrainerFilter> {
  String? region;
  String? lizenz;
  String? liga;
  String search = "";

  final Map<String, List<String>> ligenMap = {
    "Burgenland": ["Burgenlandliga", "2. Landesliga", "1. Klasse", "2. Klasse"],
    "Kärnten": ["Kärntner Liga", "Unterliga", "1. Klasse", "2. Klasse"],
    "Niederösterreich": ["1. Landesliga", "2. Landesliga", "Gebietsliga", "1. Klasse", "2. Klasse"],
    "Oberösterreich": ["OÖ Liga", "Landesliga", "Bezirksliga", "1. Klasse", "2. Klasse"],
    "Salzburg": ["Salzburger Liga", "Landesliga", "1. Landesliga", "2. Landesliga"],
    "Steiermark": ["Landesliga", "Oberliga", "Unterliga", "Gebietsliga", "1. Klasse"],
    "Tirol": ["Tiroler Liga", "Landesliga", "Gebietsliga", "Bezirksliga", "1. Klasse"],
    "Vorarlberg": ["Vorarlberg-Liga", "Landesliga", "1. Landesklasse", "2. Landesklasse", "3. Landesklasse"],
    "Wien": ["Wiener Stadtliga", "2. Landesliga", "Oberliga", "1. Klasse", "2. Klasse"],
  };

  final List<String> regions = [
    "Burgenland", "Kärnten", "Niederösterreich", "Oberösterreich",
    "Salzburg", "Steiermark", "Tirol", "Vorarlberg", "Wien"
  ];

  final List<String> lizenzen = [
    "UEFA Pro", "UEFA A", "UEFA B", "UEFA C", "UEFA D", "Keine Lizenz"
  ];

  List<String> get _currentLigen => region == null ? [] : (ligenMap[region] ?? []);

  void _notify() {
    widget.onFilterChanged({
      "search": search,
      "region": region,
      "lizenz": lizenz,
      "liga": liga,
    });
  }

  void _reset() {
    setState(() {
      search = "";
      region = null;
      lizenz = null;
      liga = null;
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24), // Angepasst an Player-Widget
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- HEADER ---
          Row(
            children: [
              Icon(LucideIcons.filter, size: 20, color: AppColors.primary),
              const SizedBox(width: 10),
              const Text(
                "Trainer-Filter",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                onPressed: _reset,
                icon: const Icon(LucideIcons.rotateCcw, size: 18, color: Colors.white38),
                tooltip: "Filter zurücksetzen",
              ),
            ],
          ),
          const SizedBox(height: 24),

          /// --- FILTER ROW ---
          Row(
            children: [
              // REGION
              Expanded(
                child: _buildDropdown(
                  "Region",
                  region,
                  regions,
                  (val) => setState(() {
                    region = val;
                    liga = null;
                    _notify();
                  }),
                ),
              ),
              const SizedBox(width: 16),

              // LIGA (DYNAMISCH)
              Expanded(
                child: _buildDropdown(
                  "Liga",
                  liga,
                  _currentLigen,
                  (val) => setState(() {
                    liga = val;
                    _notify();
                  }),
                ),
              ),
              const SizedBox(width: 16),

              // LIZENZ
              Expanded(
                child: _buildDropdown(
                  "Lizenz",
                  lizenz,
                  lizenzen,
                  (val) => setState(() {
                    lizenz = val;
                    _notify();
                  }),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// --- SEARCH FIELD ---
          TextField(
            onChanged: (val) {
              search = val;
              _notify();
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Nach Trainernamen oder Lizenzen suchen...",
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