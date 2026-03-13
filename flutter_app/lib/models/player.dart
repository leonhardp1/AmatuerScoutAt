class Player {
  final int id;
  final String name;
  final String position;
  final String exactPosition;   
  final List<String> secondPositions; // Jetzt als Liste
  final int birthYear;          
  final String nationality;     
  final String club;
  final String clubLogo;
  final String image;
  final int goals;
  final int matches;
  final int minutesPlayed;      
  final double rating;
  final String region;
  final String leagueName;
  final String strongFoot;
  final int height;
  final int weight;

  const Player({
    required this.id,
    required this.name,
    required this.position,
    required this.exactPosition,
    required this.secondPositions,
    required this.birthYear,
    required this.nationality,
    required this.club,
    required this.clubLogo,
    required this.image,
    required this.goals,
    required this.matches,
    required this.minutesPlayed,
    required this.rating,
    required this.region,
    required this.leagueName,
    required this.strongFoot,
    required this.height,
    required this.weight,
  });

  int get age => DateTime.now().year - birthYear;

  factory Player.fromMap(Map<String, dynamic> map) {
    // Hier splitten wir den String "LF;RF" in eine Liste
    List<String> secondPosList = [];
    if (map['secondposition'] != null && map['secondposition'] is String) {
      secondPosList = (map['secondposition'] as String)
          .split(';')
          .map((e) => e.trim())
          .toList();
    }

    return Player(
      id: map['id'] ?? 0,
      name: map['full_name'] ?? 'Unbekannt',
      position: map['position'] ?? '-',
      exactPosition: map['exactposition'] ?? '-',
      secondPositions: secondPosList,   // Hier als Liste speichern
      birthYear: map['birth_year'] ?? DateTime.now().year,
      nationality: map['nationality'] ?? 'Österreich',
      club: map['current_club_name'] ?? 'Kein Verein',
      region: map['bundesland'] ?? 'Unbekannt',
      leagueName: map['league_name'] ?? 'Keine Liga',
      clubLogo: map['club_logo'] ?? '',
      image: map['player_image'] ?? '',
      goals: map['goals'] ?? 0,
      matches: map['matches'] ?? 0,
      minutesPlayed: map['minutes_played'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      strongFoot: map['strong_foot'] ?? 'Unbekannt',
      height: map['height'] ?? 0,
      weight: map['weight'] ?? 0,
    );
  }

  @override
  String toString() {
    return '''
---------- PLAYER DATA ----------
ID:             $id
Name:           $name
Position:       $position
Exakte Position: $exactPosition
Zweite Position: ${secondPositions.join(', ')}   
Jahrgang:       $birthYear (Alter: $age)
Nationalität:   $nationality
Verein:         $club
Liga:           $leagueName
Region:         $region
Spiele:         $matches
Tore:           $goals
Minuten:        $minutesPlayed
Rating:         $rating
Bild-URL:       $image
Logo-URL:       $clubLogo
Fuß:            $strongFoot
Größe:          $height cm
Gewicht:        $weight kg
---------------------------------
''';
  }
}