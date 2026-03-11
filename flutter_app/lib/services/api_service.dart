import 'package:amateur_scout_at/models/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  final _supabase = Supabase.instance.client;

  
  Future<List<Player>> getPlayers() async {
  try {
    final data = await _supabase.from('players_weweb_cache').select();
    
    // DAS HIER IST JETZT ENTSCHEIDEND:
    //print("DEBUG - Was kommt von Supabase?: $data"); 
      List<Player> players = 
      data.map((item) => Player.fromMap(item as Map<String, dynamic>)).toList();

      for (var p in players.take(20)) {
      print(
        "PLAYER -> ${p.name} | ${p.position} | ${p.region} | ${p.leagueName} | Goals:${p.goals} | Matches:${p.matches} | Age:${p.age}",
      );
    }

    return players;
  } catch (e) {
    print("Fehler beim Laden: $e");
    return [];
  }
}
}