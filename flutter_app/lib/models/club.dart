class Club {
  final int id;
  final String name;
  final String logo;         // URL zum Vereinswappen
  final String stadiumName;
  final String stadiumImage; // URL zum Stadionfoto (dein To-Do!)
  final String leagueName;
  final String region;       // z.B. Bundesland
  final String primaryColor; // Für das dynamische Design der Vereinsseite
  final int rank;            // Tabellenplatz
  final int points;
  final int? coachId;        // Optional: Verknüpfung zum Coach
  final String playerWithMostMissions;
  final List<String> lastFiveResults; 
   int formScore;
   final int scoredGoals; // Neu: Anzahl der erzielten Tore
   final int goals_conceded; // Neu: Anzahl der kassierten Tore
   Club({
    required this.id,
    required this.name,
    required this.logo,
    required this.stadiumName,
    required this.stadiumImage,
    required this.leagueName,
    required this.region,
    this.primaryColor = '#000000',
    this.rank = 0,
    this.points = 0,
    this.coachId,
    this.playerWithMostMissions = 'Kein Spieler',
    this.lastFiveResults = const [],
    this.formScore = 0,
    this.scoredGoals = 0,
    this.goals_conceded = 0,
  });

  // Factory für API-Daten (analog zum Player)
factory Club.fromMap(Map<String, dynamic> map) {
  return Club(
    id: map['id'] ?? 0,
    name: map['name'] ?? 'Unbekannter Verein',
    logo: map['logo'] ?? '',
    stadiumName: map['stadium_name'] ?? 'Heimstätte',
    stadiumImage: map['stadium_image'] ?? '',
    leagueName: map['league_name'] ?? 'Keine Liga',
    region: map['region'] ?? 'Unbekannt',
    primaryColor: map['primary_color'] ?? '#000000',
    rank: map['rank'] ?? 0,
    points: map['points'] ?? 0,
    coachId: map['coach_id'],
    playerWithMostMissions: map['player_with_most_missions'] ?? 'Kein Spieler',
    lastFiveResults: List<String>.from(map['last_five_results'] ?? []),
    formScore: map['form_score'] ?? 0,
    scoredGoals: map['goals_scored'] ?? 0,
    goals_conceded: map['goals_conceded'] ?? 0,
  );
}


@override
String toString() {
  return '''
---------- CLUB DATA ----------
ID:                   $id
Name:                 $name
Vereinslogo-URL:      $logo
Stadionname:          $stadiumName
Stadionbild-URL:      $stadiumImage
Liga:                 $leagueName
Region/Bundesland:    $region
Primärfarbe:          $primaryColor
Tabellenplatz:        $rank
Punkte:               $points
Coach-ID:             $coachId
Spieler mit meisten Missionen: $playerWithMostMissions
Letzte 5 Ergebnisse:  ${lastFiveResults.join(", ")}
---------------------------------
''';
}
}