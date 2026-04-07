class Coach {
  final int id;
  final String name;
  final String image;
  final String nationality;
  final int birthYear;
  final String currentClub;
  final String preferredFormation;
  final String coachingLicense;
  final int yearsExperience;
  final double winRate;
  final int wins;
  final int losses;
  final int draws;
 


  const Coach({
    required this.id,
    required this.name,
    required this.image,
    required this.nationality,
    required this.birthYear,
    required this.currentClub,
    this.preferredFormation = '4-4-2',
    this.coachingLicense = 'B-Lizenz',
    this.yearsExperience = 0,
    this.winRate = 0.0,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
  });

  int get age => DateTime.now().year - birthYear;

  factory Coach.fromMap(Map<String, dynamic> map) {
    return Coach(
      id: map['id'] ?? 0,
      name: map['full_name'] ?? 'Unbekannter Trainer',
      image: map['coach_image'] ?? '',
      nationality: map['nationality'] ?? 'Österreich',
      birthYear: map['birth_year'] ?? 1980,
      currentClub: map['current_club_name'] ?? 'Vereinslos',
      preferredFormation: map['formation'] ?? '4-4-2',
      coachingLicense: map['coaching_license'] ?? 'B-Lizenz',
      yearsExperience: map['years_experience'] ?? 0,
      winRate: (map['win_rate'] ?? 0.0).toDouble(),

      wins: map['wins'] ?? 0,
      losses: map['losses'] ?? 0,
      draws: map['draws'] ?? 0,
    );
  }

  @override
  String toString() {
    return '''
---------- COACH DATA ----------
ID:                $id
Name:              $name
Nationalität:      $nationality
Geburtsjahr:       $birthYear (Alter: $age)
Aktueller Verein:  $currentClub
Formation:         $preferredFormation
Lizenz:            $coachingLicense
Erfahrung:         $yearsExperience Jahre
Winrate:           $winRate %
Bild:              $image
--------------------------------
''';
  }
}