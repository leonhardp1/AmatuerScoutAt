import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:math' as math;

class PlayerComparisonScreen extends StatefulWidget {
  final Player? initialPlayer;

  const PlayerComparisonScreen({super.key, this.initialPlayer});

  @override
  State<PlayerComparisonScreen> createState() => _PlayerComparisonScreenState();
}

class _PlayerComparisonScreenState extends State<PlayerComparisonScreen>
    with TickerProviderStateMixin {
  Player? player1;
  Player? player2;

  late AnimationController _fadeController;
  late AnimationController _barController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _barAnimation;

  @override
  void initState() {
    super.initState();
    player1 = widget.initialPlayer;

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _barController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _barAnimation = CurvedAnimation(
      parent: _barController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _barController.dispose();
    super.dispose();
  }

  void _triggerBarAnimation() {
    _barController.reset();
    _barController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Spielervergleich',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Player Cards Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Row(
                  children: [
                    Expanded(child: _buildPlayerCard(1, player1)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildPlayerCard(2, player2)),
                  ],
                ),
              ),
            ),

            // Comparison Content
            if (player1 != null && player2 != null) ...[
              // Gesamtbewertung
              SliverToBoxAdapter(child: _buildOverallScore()),

              // Persoenliche Daten
              SliverToBoxAdapter(child: _buildSectionHeader('Persoenliche Daten', LucideIcons.user)),
              SliverToBoxAdapter(child: _buildInfoComparison()),

              // Leistungsdaten
              SliverToBoxAdapter(child: _buildSectionHeader('Leistungsdaten', LucideIcons.activity)),
              SliverToBoxAdapter(child: _buildPerformanceStats()),

              // Koerperliche Daten
              SliverToBoxAdapter(child: _buildSectionHeader('Koerperliche Daten', LucideIcons.ruler)),
              SliverToBoxAdapter(child: _buildPhysicalStats()),

              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ] else
              SliverFillRemaining(child: _buildEmptyState()),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerCard(int slot, Player? player) {
    final isEmpty = player == null;

    return GestureDetector(
      onTap: () => _showPlayerSelection(slot),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        height: 220,
        decoration: BoxDecoration(
          color: isEmpty ? AppColors.card.withOpacity(0.5) : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isEmpty ? AppColors.border.withOpacity(0.5) : AppColors.border,
            width: 1,
          ),
          boxShadow: isEmpty
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: isEmpty ? _buildEmptyCard(slot) : _buildFilledCard(player),
      ),
    );
  }

  Widget _buildEmptyCard(int slot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.muted.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            LucideIcons.userPlus,
            color: AppColors.mutedForeground.withOpacity(0.5),
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Spieler $slot',
          style: TextStyle(
            color: AppColors.mutedForeground.withOpacity(0.7),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Tippen zum Auswaehlen',
          style: TextStyle(
            color: AppColors.mutedForeground.withOpacity(0.5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildFilledCard(Player player) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar mit Club Logo
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.muted,
                  border: Border.all(color: AppColors.border, width: 2),
                  image: player.image.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(player.image),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: player.image.isEmpty
                    ? Icon(LucideIcons.user, color: AppColors.mutedForeground, size: 28)
                    : null,
              ),
              if (player.clubLogo.isNotEmpty)
                Positioned(
                  bottom: 0,
                  right: -4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ClipOval(
                      child: Image.network(player.clubLogo, fit: BoxFit.cover),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Name
          Text(
            player.name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Position & Club
          Text(
            '${player.exactPosition} - ${player.club}',
            style: TextStyle(
              color: AppColors.mutedForeground,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),

          // Rating
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getRatingColor(player.rating).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              player.rating.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: _getRatingColor(player.rating),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 8.0) return const Color(0xFF22C55E);
    if (rating >= 6.5) return const Color(0xFF84CC16);
    if (rating >= 5.0) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScore() {
    int p1Wins = 0;
    int p2Wins = 0;
    int total = 0;

    void compare(num v1, num v2, {bool lowerIsBetter = false}) {
      total++;
      if (lowerIsBetter) {
        if (v1 < v2) p1Wins++;
        else if (v2 < v1) p2Wins++;
      } else {
        if (v1 > v2) p1Wins++;
        else if (v2 > v1) p2Wins++;
      }
    }

    compare(player1!.rating, player2!.rating);
    compare(player1!.goals, player2!.goals);
    compare(player1!.matches, player2!.matches);
    compare(player1!.minutesPlayed, player2!.minutesPlayed);
    compare(player1!.height, player2!.height);
    compare(player1!.weight, player2!.weight);
    compare(player1!.age, player2!.age, lowerIsBetter: true);

    final p1Percent = total > 0 ? p1Wins / total : 0.5;
    final p2Percent = total > 0 ? p2Wins / total : 0.5;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.card,
            AppColors.card.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScoreColumn(player1!.name.split(' ').last, p1Wins, p1Wins > p2Wins),
              Column(
                children: [
                  Text(
                    'Vergleich',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.mutedForeground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$p1Wins : $p2Wins',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              _buildScoreColumn(player2!.name.split(' ').last, p2Wins, p2Wins > p1Wins),
            ],
          ),
          const SizedBox(height: 16),
          // Animated Progress Bar
          AnimatedBuilder(
            animation: _barAnimation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    children: [
                      Expanded(
                        flex: (p1Percent * 100 * _barAnimation.value).toInt().clamp(1, 100),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if ((1 - p1Percent - p2Percent) > 0)
                        Expanded(
                          flex: ((1 - p1Percent - p2Percent) * 100).toInt().clamp(1, 100),
                          child: Container(color: AppColors.muted),
                        ),
                      Expanded(
                        flex: (p2Percent * 100 * _barAnimation.value).toInt().clamp(1, 100),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.foreground.withOpacity(0.5),
                                AppColors.foreground.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String name, int wins, bool isWinner) {
    return Column(
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mutedForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isWinner ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$wins',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isWinner ? AppColors.primary : AppColors.foreground,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoComparison() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildTextRow('Nationalitaet', player1!.nationality, player2!.nationality),
          _buildDivider(),
          _buildTextRow('Verein', player1!.club, player2!.club),
          _buildDivider(),
          _buildTextRow('Liga', player1!.leagueName, player2!.leagueName),
          _buildDivider(),
          _buildTextRow('Region', player1!.region, player2!.region),
          _buildDivider(),
          _buildTextRow('Position', player1!.exactPosition, player2!.exactPosition),
          _buildDivider(),
          _buildTextRow('Starker Fuss', player1!.strongFoot, player2!.strongFoot),
          _buildDivider(),
          _buildNumericRow('Alter', player1!.age.toDouble(), player2!.age.toDouble(), 'Jahre', lowerIsBetter: true),
          _buildDivider(),
          _buildNumericRow('Jahrgang', player1!.birthYear.toDouble(), player2!.birthYear.toDouble(), '', higherIsBetter: true),
        ],
      ),
    );
  }

  Widget _buildPerformanceStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildAnimatedStatCard(
            'Rating',
            player1!.rating,
            player2!.rating,
            maxValue: 10,
            decimals: 1,
          ),
          const SizedBox(height: 12),
          _buildAnimatedStatCard(
            'Tore',
            player1!.goals.toDouble(),
            player2!.goals.toDouble(),
            maxValue: math.max(player1!.goals, player2!.goals).toDouble() * 1.2,
          ),
          const SizedBox(height: 12),
          _buildAnimatedStatCard(
            'Einsaetze',
            player1!.matches.toDouble(),
            player2!.matches.toDouble(),
            maxValue: math.max(player1!.matches, player2!.matches).toDouble() * 1.2,
          ),
          const SizedBox(height: 12),
          _buildAnimatedStatCard(
            'Minuten',
            player1!.minutesPlayed.toDouble(),
            player2!.minutesPlayed.toDouble(),
            maxValue: math.max(player1!.minutesPlayed, player2!.minutesPlayed).toDouble() * 1.2,
          ),
          const SizedBox(height: 12),
          _buildAnimatedStatCard(
            'Tore pro Spiel',
            player1!.matches > 0 ? player1!.goals / player1!.matches : 0,
            player2!.matches > 0 ? player2!.goals / player2!.matches : 0,
            maxValue: 2,
            decimals: 2,
          ),
          const SizedBox(height: 12),
          _buildAnimatedStatCard(
            'Min. pro Tor',
            player1!.goals > 0 ? player1!.minutesPlayed / player1!.goals : 0,
            player2!.goals > 0 ? player2!.minutesPlayed / player2!.goals : 0,
            maxValue: math.max(
              player1!.goals > 0 ? player1!.minutesPlayed / player1!.goals : 0,
              player2!.goals > 0 ? player2!.minutesPlayed / player2!.goals : 0,
            ) * 1.2,
            decimals: 0,
            lowerIsBetter: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildAnimatedStatCard(
            'Groesse',
            player1!.height.toDouble(),
            player2!.height.toDouble(),
            maxValue: 210,
            suffix: 'cm',
          ),
          const SizedBox(height: 12),
          _buildAnimatedStatCard(
            'Gewicht',
            player1!.weight.toDouble(),
            player2!.weight.toDouble(),
            maxValue: 100,
            suffix: 'kg',
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatCard(
    String label,
    double val1,
    double val2, {
    required double maxValue,
    int decimals = 0,
    String suffix = '',
    bool lowerIsBetter = false,
  }) {
    final p1Better = lowerIsBetter ? val1 < val2 : val1 > val2;
    final p2Better = lowerIsBetter ? val2 < val1 : val2 > val1;
    final isDraw = val1 == val2;

    return AnimatedBuilder(
      animation: _barAnimation,
      builder: (context, child) {
        final animVal1 = val1 * _barAnimation.value;
        final animVal2 = val2 * _barAnimation.value;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              // Label
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Values & Bars
              Row(
                children: [
                  // Player 1
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (p1Better && !isDraw)
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            Text(
                              '${decimals > 0 ? animVal1.toStringAsFixed(decimals) : animVal1.toInt()}$suffix',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: p1Better && !isDraw ? AppColors.primary : AppColors.foreground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: maxValue > 0 ? (animVal1 / maxValue).clamp(0, 1) : 0,
                            backgroundColor: AppColors.muted,
                            valueColor: AlwaysStoppedAnimation(
                              p1Better && !isDraw ? AppColors.primary : AppColors.foreground.withOpacity(0.4),
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 24),

                  // Player 2
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${decimals > 0 ? animVal2.toStringAsFixed(decimals) : animVal2.toInt()}$suffix',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: p2Better && !isDraw ? AppColors.primary : AppColors.foreground,
                              ),
                            ),
                            if (p2Better && !isDraw)
                              Container(
                                width: 6,
                                height: 6,
                                margin: const EdgeInsets.only(left: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: LinearProgressIndicator(
                              value: maxValue > 0 ? (animVal2 / maxValue).clamp(0, 1) : 0,
                              backgroundColor: AppColors.muted,
                              valueColor: AlwaysStoppedAnimation(
                                p2Better && !isDraw ? AppColors.primary : AppColors.foreground.withOpacity(0.4),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: AppColors.border.withOpacity(0.5));
  }

  Widget _buildTextRow(String label, String val1, String val2) {
    final isSame = val1.toLowerCase() == val2.toLowerCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              val1,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSame ? AppColors.foreground : AppColors.foreground,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              val2,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSame ? AppColors.foreground : AppColors.foreground,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumericRow(String label, double val1, double val2, String suffix,
      {bool lowerIsBetter = false, bool higherIsBetter = false}) {
    bool p1Better = false;
    bool p2Better = false;

    if (lowerIsBetter) {
      p1Better = val1 < val2;
      p2Better = val2 < val1;
    } else if (higherIsBetter) {
      p1Better = val1 > val2;
      p2Better = val2 > val1;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (p1Better)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                Text(
                  '${val1.toInt()}${suffix.isNotEmpty ? ' $suffix' : ''}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: p1Better ? FontWeight.w600 : FontWeight.w500,
                    color: p1Better ? AppColors.primary : AppColors.foreground,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${val2.toInt()}${suffix.isNotEmpty ? ' $suffix' : ''}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: p2Better ? FontWeight.w600 : FontWeight.w500,
                    color: p2Better ? AppColors.primary : AppColors.foreground,
                  ),
                ),
                if (p2Better)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.muted.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.gitCompare,
              size: 32,
              color: AppColors.mutedForeground.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Spieler auswaehlen',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Waehle zwei Spieler aus, um\nderen Statistiken zu vergleichen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.mutedForeground,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showPlayerSelection(int slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _PlayerSelectionSheet(
        onSelect: (player) {
          setState(() {
            if (slot == 1) player1 = player;
            else player2 = player;
          });
          _triggerBarAnimation();
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _PlayerSelectionSheet extends StatefulWidget {
  final Function(Player) onSelect;

  const _PlayerSelectionSheet({required this.onSelect});

  @override
  State<_PlayerSelectionSheet> createState() => _PlayerSelectionSheetState();
}

class _PlayerSelectionSheetState extends State<_PlayerSelectionSheet> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Spieler auswaehlen',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.muted.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Suchen...',
                    hintStyle: TextStyle(
                      color: AppColors.mutedForeground.withOpacity(0.5),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      color: AppColors.mutedForeground.withOpacity(0.5),
                      size: 18,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (val) => setState(() => searchQuery = val),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<AppState>(
                builder: (context, state, _) {
                  final filtered = state.players
                      .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();

                  return ListView.builder(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final player = filtered[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.muted,
                              border: Border.all(color: AppColors.border),
                              image: player.image.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(player.image),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: player.image.isEmpty
                                ? Icon(LucideIcons.user, color: AppColors.mutedForeground, size: 20)
                                : null,
                          ),
                          title: Text(
                            player.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          subtitle: Text(
                            '${player.exactPosition} - ${player.club}',
                            style: TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getRatingColor(player.rating).withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              player.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: _getRatingColor(player.rating),
                              ),
                            ),
                          ),
                          onTap: () => widget.onSelect(player),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 8.0) return const Color(0xFF22C55E);
    if (rating >= 6.5) return const Color(0xFF84CC16);
    if (rating >= 5.0) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}