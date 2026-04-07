import 'package:amateur_scout_at/screens/extendetScreens/coachDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../models/coach.dart';

class CoachCard extends StatefulWidget {
  final Coach coach;

  const CoachCard({
    super.key,
    required this.coach,
  });

  @override
  State<CoachCard> createState() => _CoachCardState();
}

class _CoachCardState extends State<CoachCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.coach;

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
        padding: const EdgeInsets.all(16), // Padding leicht reduziert (vorher 20)
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                /// --- PROFILBILD (Kompakter: 54 statt 64) ---
                Container(
                  width: 54,
                  height: 54,
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
                    child: c.image.isNotEmpty
                        ? Image.network(
                            c.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildDefaultUserIcon(),
                          )
                        : _buildDefaultUserIcon(),
                  ),
                ),
                const SizedBox(width: 12),

                /// --- NAME & LIZENZ ---
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        c.name,
                        style: TextStyle(
                          fontSize: 15, // Von 16 auf 15
                          fontWeight: FontWeight.bold,
                          color: _isHovered ? AppColors.primary : AppColors.foreground,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          c.coachingLicense,
                          style: const TextStyle(
                            fontSize: 10, // Von 11 auf 10
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            /// --- AKTUELLER VEREIN ---
            _buildInfoRow(LucideIcons.shield, c.currentClub),
            
            const SizedBox(height: 16),

            /// --- TRAINER STATS (Optimierte Paddings) ---
            Row(
              children: [
                _buildStatBox(
                  icon: LucideIcons.layers,
                  iconColor: AppColors.primary,
                  value: c.preferredFormation,
                  label: 'System',
                ),
                const SizedBox(width: 8),
                _buildStatBox(
                  icon: LucideIcons.briefcase,
                  iconColor: AppColors.accent,
                  value: '${c.yearsExperience}J',
                  label: 'Erf.', // Kürzeres Label spart Platz
                ),
                const SizedBox(width: 8),
                _buildStatBox(
                  icon: LucideIcons.trendingUp,
                  iconColor: Colors.greenAccent,
                  value: '${c.winRate.toInt()}%',
                  label: 'Winrate',
                ),
              ],
            ),
            
            // Flexibler Platzhalter statt hartem Spacer()
           // const Expanded(child: SizedBox(minHeight: 12)),

            /// --- AKTIONEN ---
            _buildViewProfileButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultUserIcon() {
    return Container(
      color: AppColors.muted,
      child: const Icon(LucideIcons.user, size: 24, color: AppColors.mutedForeground),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.mutedForeground),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => TrainerDetailScreen(coach: widget.coach)));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _isHovered ? AppColors.primary : AppColors.muted,
          foregroundColor: _isHovered ? AppColors.primaryForeground : AppColors.foreground,
          padding: const EdgeInsets.symmetric(vertical: 10), // Von 12 auf 10
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text('Profil ansehen', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildStatBox({
    required IconData icon, 
    required Color iconColor, 
    required String value, 
    required String label
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8), // Von 12 auf 8
        decoration: BoxDecoration(
          color: AppColors.muted.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor), // Von 16 auf 14
            const SizedBox(height: 4),
            Text(
              value, 
              style: const TextStyle(
                fontSize: 13, // Von 16 auf 13
                fontWeight: FontWeight.bold, 
                color: AppColors.foreground
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(label, style: const TextStyle(fontSize: 9, color: AppColors.mutedForeground)),
          ],
        ),
      ),
    );
  }
}