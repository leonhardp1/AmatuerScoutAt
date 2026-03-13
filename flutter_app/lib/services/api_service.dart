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
          .map((item) => Player.fromMap(item as Map<String, dynamic>))
          .toList();

      print(players.toString()); // Debug-Ausgabe der geladenen Spieler
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
          .map((item) => Club.fromMap(item as Map<String, dynamic>))
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

      if (data != null) {
        final coach = Coach.fromMap(data as Map<String, dynamic>);
        print("Geladener Coach: ${coach.name}");
        return coach;
      } else {
        print("Kein Coach mit ID $id gefunden.");
        return null;
      }
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
}