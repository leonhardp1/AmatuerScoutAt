import 'package:amateur_scout_at/screens/playerDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../models/player.dart'; // WICHTIG: Model importieren

class PlayerCard extends StatefulWidget {
  // GEÄNDERT: Wir nutzen jetzt das Model statt der Map
  final Player player; 

  const PlayerCard({
    super.key,
    required this.player,
  });

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // GEÄNDERT: Wir greifen direkt auf die Felder des Objekts zu
    // Kein widget.playerData['name'] ?? '...' mehr nötig!
    final p = widget.player; 

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered
            ? (Matrix4.identity()..scale(1.02))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: AppColors.cardTransparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.border,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _isHovered
                              ? AppColors.primary.withOpacity(0.5)
                              : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: p.image.isNotEmpty 
                          ? Image.network(
                              p.image,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildDefaultUserIcon(),
                            )
                          : _buildDefaultUserIcon(),
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: _buildRatingBadge(p.rating.toInt()), // p.rating ist double
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isHovered ? AppColors.primary : AppColors.foreground,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        p.position,
                        style: const TextStyle(fontSize: 14, color: AppColors.mutedForeground),
                      ),
                      const SizedBox(height: 8),
                      _buildClubRow(p.club, p.clubLogo),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatBox(
                  icon: LucideIcons.trophy,
                  iconColor: AppColors.primary,
                  value: p.goals.toString(),
                  label: 'Tore',
                ),
                const SizedBox(width: 12),
                _buildStatBox(
                  icon: LucideIcons.target,
                  iconColor: AppColors.accent,
                  value: p.matches.toString(),
                  label: 'Spiele',
                ),
                const SizedBox(width: 12),
                _buildStatBox(
                  icon: LucideIcons.calendar,
                  iconColor: AppColors.mutedForeground,
                  value: p.age.toString(),
                  label: 'Alter',
                ),
              ],
            ),
            const Spacer(),
            _buildViewProfileButton(),
          ],
        ),
      ),
    );
  }

  // --- Hilfs-Widgets (bleiben fast gleich, nur p. statt map) ---

  Widget _buildDefaultUserIcon() {
    return Container(
      color: AppColors.muted,
      child: const Icon(LucideIcons.user, color: AppColors.mutedForeground),
    );
  }

  Widget _buildRatingBadge(int rating) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
      child: Center(
        child: Text(
          rating.toString(),
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentForeground),
        ),
      ),
    );
  }

  Widget _buildClubRow(String club, String clubLogo) {
    return Row(
      children: [
        if (clubLogo.isNotEmpty)
          Container(
            width: 20, height: 20,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.muted),
            child: ClipOval(child: Image.network(clubLogo, fit: BoxFit.cover)),
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            club,
            style: const TextStyle(fontSize: 12, color: AppColors.mutedForeground),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
Widget _buildViewProfileButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {
        // HIER DIE NAVIGATION EINFÜGEN:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerDetailScreen(player: widget.player),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isHovered ? AppColors.primary : AppColors.muted,
        foregroundColor: _isHovered ? AppColors.primaryForeground : AppColors.foreground,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text('Profil ansehen', style: TextStyle(fontWeight: FontWeight.w500)),
    ),
  );
}

  Widget _buildStatBox({required IconData icon, required Color iconColor, required String value, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.muted.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.foreground)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.mutedForeground)),
          ],
        ),
      ),
    );
  }
}