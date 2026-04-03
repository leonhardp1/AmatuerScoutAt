import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  final String currentPage;
  final Function(String)? onSearchChanged;

  const AppHeader({
    super.key,
    required this.currentPage,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1024;

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
   decoration: BoxDecoration(
  color: const Color(0xFF0B1220), // dunkles Blau wie im Design
  border: Border(
    bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
  ),
),
      child: Row(
        children: [
          // LOGO
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withOpacity(0.05),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/logo.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'ScoutBase',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(width: 40),

       Row(
  children: [
    _NavItem(
      title: "Dashboard",
      active: currentPage == "dashboard",
      onTap: () {
        Navigator.pushReplacementNamed(context, "/dashboard");
      },
    ),
    _NavItem(
      title: "Spieler",
      active: currentPage == "spieler",
      onTap: () {
        Navigator.pushReplacementNamed(context, "/spieler");
      },
    ),
    _NavItem(
      title: "Trainer",
      active: currentPage == "trainer",
      onTap: () {
        Navigator.pushReplacementNamed(context, "/trainer");
      },
    ),
    _NavItem(
      title: "Vereine",
      active: currentPage == "vereine",
      onTap: () {
        Navigator.pushReplacementNamed(context, "/vereine");
      },
    ),
    _NavItem(
      title: "Börse",
      active: currentPage == "boerse",
      onTap: () {
        Navigator.pushReplacementNamed(context, "/boerse");
      },
    ),
  ],
),
          const Spacer(),

          // SEARCH
          if (isDesktop)
            Container(
              width: 300,
              margin: const EdgeInsets.only(right: 20),
              child: TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Spieler suchen...',
                  prefixIcon: const Icon(LucideIcons.search, size: 18),
                  filled: true,
                  fillColor: AppColors.input,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),

          // LOGIN BUTTON
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Row(
              children: [
                Icon(LucideIcons.logIn, size: 16, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  "Anmelden",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap; // Neu: Die Aktion beim Klick

  const _NavItem({
    required this.title, 
    required this.onTap, // Neu
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell( // Macht das Item klickbar mit Wellen-Effekt
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: active ? Colors.white : AppColors.mutedForeground,
          ),
        ),
      ),
    );
  }
}
