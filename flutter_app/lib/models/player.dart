class Player {
  final int id;
  final String name;
  final String position;
  final int age;
  final String club;
  final String clubLogo;
  final String image;
  final int goals;
  final int matches;
  final double rating;
  // NEU: Diese Felder brauchen wir für die Sidebar-Filter
  final String region;
  final String leagueName;

  const Player({
    required this.id,
    required this.name,
    required this.position,
    required this.age,
    required this.club,
    required this.clubLogo,
    required this.image,
    required this.goals,
    required this.matches,
    required this.rating,
    required this.region,     // Neu
    required this.leagueName, // Neu
  });

  factory Player.fromMap(Map<String, dynamic> map) {
  return Player(
    id: map['id'] ?? 0,
    name: map['full_name'] ?? 'Unbekannt',
    position: map['position'] ?? '-',
    age: map['birth_year'] != null ? (DateTime.now().year - (map['birth_year'] as int)) : 0, 
    club: map['current_club_name'] ?? 'Kein Verein',
    region: map['bundesland'] ?? 'Unbekannt', // WICHTIG: 'bundesland' statt 'region_name'
    leagueName: map['league_name'] ?? 'Keine Liga', // 'league_name' passt
    clubLogo: '', 
    image: '',
    goals: map['goals'] ?? 0,
    matches: map['matches'] ?? 0,
    rating: 0.0,
  );
}
}