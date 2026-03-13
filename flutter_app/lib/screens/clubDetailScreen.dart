import 'package:amateur_scout_at/screens/coachDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../models/club.dart';
import '../models/coach.dart';
import '../services/api_service.dart';

class ClubDetailScreen extends StatefulWidget {
  final Club club;

  const ClubDetailScreen({
    super.key,
    required this.club,
    
  });

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {

  final ApiService api = ApiService();

  Coach? coach;
  bool isLoadingCoach = true;

  @override
  void initState() {
    super.initState();
    _loadCoach();
  }

  Future<void> _loadCoach() async {
    if (widget.club.coachId == null) {
      setState(() {
        isLoadingCoach = false;
      });
      return;
    }

    final loadedCoach = await api.getCoachById(widget.club.coachId!);

    setState(() {
      coach = loadedCoach;
      isLoadingCoach = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final club = widget.club;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuickStats(),
                  const SizedBox(height: 32),

                  _buildSectionTitle("Trainer"),
                  _buildCoachCard(),
                  const SizedBox(height: 32),

                  _buildSectionTitle("Dauerbrenner"),
                  _buildTopPlayerCard(),
                  const SizedBox(height: 32),

                  _buildSectionTitle("Formkurve"),
                  _buildResultsRow(),
                  const SizedBox(height: 32),

                  _buildPlaceholderSection(
                    "Tabelle & Spielplan",
                    "Daten werden in Kürze synchronisiert...",
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    final club = widget.club;

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      backgroundColor: AppColors.card,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          club.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            club.stadiumImage.isNotEmpty
                ? Image.network(club.stadiumImage, fit: BoxFit.cover)
                : Container(
                    color: AppColors.muted.withOpacity(0.3),
                    child: const Icon(LucideIcons.map, size: 50),
                  ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, AppColors.background],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final club = widget.club;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSimpleStat("Rang", "#${club.rank}"),
        _buildSimpleStat("Punkte", "${club.points}"),
        _buildSimpleStat("Region", club.region),
      ],
    );
  }

  Widget _buildSimpleStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.mutedForeground, fontSize: 12)),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(title,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCoachCard() {

    if (isLoadingCoach) {
      return const Center(child: CircularProgressIndicator());
    }

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: coach == null
          ? null
          : () {
// Korrekte Navigation
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrainerDetailScreen(coach: coach!), 
              ),
            );
            },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardTransparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppColors.muted,
              backgroundImage: coach?.image.isNotEmpty == true
                  ? NetworkImage(coach!.image)
                  : null,
              child: coach?.image.isEmpty ?? true
                  ? const Icon(LucideIcons.user,
                      color: AppColors.mutedForeground)
                  : null,
            ),
            const SizedBox(width: 16),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coach?.name ?? "Kein Trainer hinterlegt",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  coach?.coachingLicense ?? "Haupttrainer",
                  style: const TextStyle(
                    color: AppColors.mutedForeground,
                    fontSize: 13,
                  ),
                ),
              ],
            ),

            const Spacer(),

            const Icon(
              LucideIcons.chevronRight,
              color: AppColors.mutedForeground,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPlayerCard() {
    final club = widget.club;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.2), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.timer, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Meiste Einsätze",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  club.playerWithMostMissions,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsRow() {
    return Row(
      children: List.generate(5, (index) {
        return Container(
          margin: const EdgeInsets.only(right: 8),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: index % 2 == 0
                ? Colors.green.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              index % 2 == 0 ? "S" : "N",
              style: TextStyle(
                color: index % 2 == 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPlaceholderSection(String title, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardTransparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.border,
              style: BorderStyle.none,
            ),
          ),
          child: Column(
            children: [
              const Icon(
                LucideIcons.database,
                color: AppColors.mutedForeground,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



}