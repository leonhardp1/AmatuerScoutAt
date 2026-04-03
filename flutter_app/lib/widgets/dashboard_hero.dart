import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class DashboardHero extends StatelessWidget {
  final String selectedRegion;
  final Function(String?) onRegionChanged;

  const DashboardHero({
    super.key, 
    required this.selectedRegion, 
    required this.onRegionChanged
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // GRÜNER WILLKOMMENS-BANNER
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981), // Das kräftige Scoutbase-Grün
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Willkommen bei Scoutbase",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Ihre umfassende Plattform für Amateur-Fußball Scouting in Österreich",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // FILTER-LEISTE (REGION)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF111827), // Dunkler Navy-Ton aus dem Bild
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.mapPin, size: 18, color: Color(0xFF10B981)),
              const SizedBox(width: 12),
              const Text(
                "Region:",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: const Color(0xFF111827),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRegion,
                    icon: const Icon(LucideIcons.chevronDown, size: 16, color: Colors.white),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    items: ["Alle", "Wien", "NÖ", "OÖ", "Salzburg", "Steiermark", "Tirol", "Vbg", "Kärnten", "Burgenland"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: onRegionChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}