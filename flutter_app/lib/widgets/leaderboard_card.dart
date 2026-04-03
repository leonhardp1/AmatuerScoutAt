import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class LeaderboardItem {
  final String name;
  final String subtitle;
  final String value;
  final String imageUrl;

  LeaderboardItem({
    required this.name,
    required this.subtitle,
    required this.value,
    required this.imageUrl,
  });
}

class LeaderboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<LeaderboardItem> items;
  final VoidCallback? onSeeAll;

  const LeaderboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  "Alle anzeigen",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          // LISTE
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  // RANK
                  Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: AppColors.mutedForeground,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // AVATAR
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(item.imageUrl),
                  ),

                  const SizedBox(width: 10),

                  // NAME + SUBTITLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // VALUE (z.B. Tore / Rating)
                  Text(
                    item.value,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}