import 'package:amateur_scout_at/models/club.dart';
import 'package:amateur_scout_at/models/coach.dart';
import 'package:amateur_scout_at/models/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  final _supabase = Supabase.instance.client;

  // Spieler laden
  Future<List<Player>> getPlayers() async {
    try {
      final data = await _supabase.from('players_testing').select();
      final players = data
          .map((item) => Player.fromMap(item))
          .toList();

      return players;
    } catch (e) {
      print("Fehler beim Laden der Spieler: $e");
      return [];
    }
  }

  // Vereine laden
  Future<List<Club>> getClubs() async {
    try {
      final data = await _supabase.from('club_testing').select();
      final clubs = data
          .map((item) => Club.fromMap(item))
          .toList();

      print("Geladene Vereine: ${clubs.length}");
      return clubs;
    } catch (e) {
      print("Fehler beim Laden der Vereine: $e");
      return [];
    }
  }




//Coach mit Id laden
  Future<Coach?> getCoachById(int id) async {
    try {
      final data = await _supabase
          .from('coach_testing')
          .select()
          .eq('id', id)
          .single(); 

      final coach = Coach.fromMap(data as Map<String, dynamic>);
      print("Geladener Coach: ${coach.name}");
      return coach;
        } catch (e) {
      print("Fehler beim Laden des Coaches mit ID $id: $e");
      return null;
    }
  }




  // // Coaches laden
  // Future<List<Coach>> getCoaches() async {
  //   try {
  //     final data = await _supabase.from('coaches').select();
  //     final coaches = data
  //         .map((item) => Coach.fromMap(item as Map<String, dynamic>))
  //         .toList();

  //     print("Geladene Coaches: ${coaches.length}");
  //     return coaches;
  //   } catch (e) {
  //     print("Fehler beim Laden der Coaches: $e");
  //     return [];
  //   }
  // }

  // Optionale Hilfsmethode für Positionen
  Future<List<String>> getPositions() async {
    try {
      final data =
          await _supabase.from('players_weweb_options_position').select();
      final positions =
          data.map((item) => item['position'] as String).toList();
      print("Geladene Positionen: $positions");
      return positions;
    } catch (e) {
      print("Fehler beim Laden der Positionen: $e");
      return [];
    }
  }























  // Top Torschützen laden
  Future<List<Player>> getTopScorers() async {
    try {
      final data = await _supabase
          .from('players_testing')
          .select()
          .order('goals', ascending: false)
          .limit(20);
      final topScorers = data
          .map((item) => Player.fromMap(item))
          .toList();

      print("Geladene Top Torschützen: ${topScorers.length}");
    //  print("Top Torschützen: ${topScorers.map((p) => p.name).join(', ')}");
      return topScorers;
    } catch (e) {
      print("Fehler beim Laden der Top Torschützen: $e");
      return [];
    }
  }



  // Spieler mit höchsten Ratings laden
  Future<List<Player>> getTopRatedPlayers() async {
    try {
      final data = await _supabase
          .from('players_testing')
          .select()
          .order('rating', ascending: false)
          .limit(20);
      final topRatedPlayers = data
          .map((item) => Player.fromMap(item))
          .toList();

      print("Geladene Spieler mit höchsten Ratings: ${topRatedPlayers.length}");
      // spieler mit dem höchsten Rating ausgeben und das rating mit angeben
      print("Spieler mit höchsten Ratings: ${topRatedPlayers.map((p) => '${p.name} (${p.rating})').join(', ')}");

      return topRatedPlayers;
    } catch (e) {
      print("Fehler beim Laden der Spieler mit höchsten Ratings: $e");
      return [];
    }
  }



Future<List<Club>> getFormStrongestTeams() async {
  try {
    final data = await _supabase.from('club_testing').select();
    final formStrongestTeams = data.map((item) {
      final club = Club.fromMap(item);

      // form_strength ist ein List<String>
      final form = club.lastFiveResults; // ["W","W","D","L","W"]
      club.formScore = form.fold<int>(0, (prev, result) {
        if (result == 'W') return prev + 3;
        if (result == 'D') return prev + 1;
        return prev; // L = 0
      });

      return club;
    }).toList();

    // Nach formScore sortieren
    formStrongestTeams.sort((a, b) => b.formScore.compareTo(a.formScore));

    // Nur Top 20 zurückgeben
    final top20 = formStrongestTeams.take(20).toList();

    print("Geladene formstärkste Teams: ${top20.length}");
    return top20;
  } catch (e) {
    print("Fehler beim Laden der formstärksten Teams: $e");
    return [];
  }
}


  // Spieler mit den meisten Karten Laden
  Future<List<Player>> getMostCardedPlayers() async { 
    try {
      final data = await _supabase
          .from('players_testing')
          .select()
          .order('yellow_cards', ascending: false)
          .limit(20);
      final mostCardedPlayers = data
          .map((item) => Player.fromMap(item))
          .toList();

      print("Geladene Spieler mit den meisten Karten: ${mostCardedPlayers.length}");
      return mostCardedPlayers;
    } catch (e) {
      print("Fehler beim Laden der Spieler mit den meisten Karten: $e");
      return [];
    }
  }


  // Teams mit meisten TOren Laden
  Future<List<Club>> getTeamsWithMostGoals() async {
    try {
      final data = await _supabase
          .from('club_testing')
          .select()
          .order('goals_scored', ascending: false)
          .limit(20);
      final teamsWithMostGoals = data
          .map((item) => Club.fromMap(item))
          .toList();

      print("Geladene Teams mit den meisten Toren: ${teamsWithMostGoals.length}");
      return teamsWithMostGoals;
    } catch (e) {
      print("Fehler beim Laden der Teams mit den meisten Toren: $e");
      return [];
    }
  }

  // Teams mit meisten Gegentoren Laden
  Future<List<Club>> getTeamsWithMostConcededGoals() async {
    try {
      final data = await _supabase
          .from('club_testing')
          .select()
          .order('goals_conceded', ascending: false)
          .limit(20);
      final teamsWithMostConcededGoals = data
          .map((item) => Club.fromMap(item))
          .toList();

      print("Geladene Teams mit den meisten Gegentoren: ${teamsWithMostConcededGoals.length}");
      return teamsWithMostConcededGoals;
    } catch (e) {
      print("Fehler beim Laden der Teams mit den meisten Gegentoren: $e");
      return [];
    }
  }


/// clubs with conditions













  /// --- NEU: Erweiterte Suche mit Filterbedingungen ---
  /// Diese Methode nimmt eine Map mit Filterbedingungen entgegen und gibt die passenden Spieler zurück
  static Future<List<Player>> searchPlayersWithConditions(
  Map<String, dynamic> filters, {
  int offset = 0, 
  int limit = 20,
}) async {
  try {
    final client = Supabase.instance.client;
    var query = client.from('players_testing').select();

    // --- FILTER ---
    if (filters['positions'] != null && (filters['positions'] as List).isNotEmpty) {
      query = query.inFilter('position', List<String>.from(filters['positions'])); 
    }

    if (filters['league'] != null && filters['league'] != "Alle Ligen") {
      query = query.eq('league_name', filters['league']);
    }

    final currentYear = DateTime.now().year;
    if (filters['ageMin'] != null) {
      query = query.lte('birth_year', currentYear - (filters['ageMin'] as int));
    }
    if (filters['ageMax'] != null) {
      query = query.gte('birth_year', currentYear - (filters['ageMax'] as int));
    }

    if (filters['ratingMin'] != null) {
      query = query.gte('rating', filters['ratingMin']);
    }
    if (filters['goalsMin'] != null) {
      query = query.gte('goals', filters['goalsMin']);
    }

    if (filters['searchName'] != null && filters['searchName'].toString().isNotEmpty) {
      query = query.ilike('full_name', '%${filters['searchName']}%');
    }

    // --- EXECUTION ---
    // .range(0, 19) holt 20 Datensätze. .range(20, 39) holt die nächsten 20.
    final List<dynamic> data = await query
        .order('full_name', ascending: true)
        .range(offset, offset + limit - 1);

    return data.map((item) => Player.fromMap(item)).toList();
  } catch (e) {
    print("Fehler bei der Supabase Suche: $e");
    return [];
  }
}






static Future<List<Coach>> searchCoachesWithConditions(Map<String, dynamic> filters) async {
  try {
    final client = Supabase.instance.client;
    
    // 1. Erstelle die Query ohne sie sofort auszuführen
    // Wichtig: Wir deklarieren 'query' so, dass wir Filter anhängen können.
    var query = client.from('coach_testing').select();

    // 2. Filter anhängen (wie gehabt)
    final search = filters['search'] ?? filters['searchName'];
    if (search != null && search.toString().trim().isNotEmpty) {
      query = query.ilike('full_name', '%${search.toString().trim()}%');
    }

    if (filters['region'] != null && filters['region'] != "Alle Regionen") {
      query = query.eq('region', filters['region']);
    }

    if (filters['liga'] != null && filters['liga'] != "Alle Ligen") {
      query = query.eq('league', filters['liga']);
    }

    if (filters['lizenz'] != null && filters['lizenz'] != "Alle Lizenzen") {
      query = query.eq('license', filters['lizenz']);
    }

    // 3. SORTIERUNG (Hier lag der Fehler)
    // .order() muss am Ende der Filter-Kette stehen, bevor das 'await' kommt.
    final List<dynamic> data = await query.order('full_name', ascending: true);

    return data.map((item) => Coach.fromMap(item)).toList();
  } catch (e) {
    print("Fehler bei der Supabase Coach Suche: $e");
    return [];
  }
}













static Future<List<Club>> searchClubsWithConditions({
  String? query,
  String? region,
  String? league,
}) async {
  try {
    final client = Supabase.instance.client;
    var supabaseQuery = client.from('club_testing').select();

    if (query != null && query.trim().isNotEmpty) {
      supabaseQuery = supabaseQuery.ilike('name', '%${query.trim()}%');
    }

    if (region != null && region != "Alle Regionen") {
      supabaseQuery = supabaseQuery.eq('region', region);
    }

    if (league != null && league != "Alle Ligen") {
      supabaseQuery = supabaseQuery.eq('league_name', league);
    }

    final List<dynamic> data = await supabaseQuery.order('name', ascending: true);

    return data.map((item) => Club.fromMap(item)).toList();
  } catch (e) {
    print("Fehler bei der Supabase Club Suche: $e");
    return [];
  }
}



}

