import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/coach.dart';
import '../models/club.dart';
import 'api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService api = ApiService();

  List<Player> players = [];
  List<Coach> coaches = [];
  List<Club> clubs = [];

  bool isLoading = false;

  /// Lädt alle Daten nacheinander und speichert sie automatisch
  Future<void> loadAllData() async {
    isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        loadPlayers(),
       // loadCoaches(),
        loadClubs(),
      ]);
    } catch (e) {
      debugPrint("Fehler beim Laden aller Daten: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadPlayers() async {
    try {
      final loadedPlayers = await api.getPlayers();
      players = loadedPlayers; // direkt speichern
      notifyListeners();
    } catch (e) {
      debugPrint("Fehler beim Laden der Spieler: $e");
    }
  }

  // Future<void> loadCoaches() async {
  //   try {
  //     final loadedCoaches = await api.getCoaches();
  //     coaches = loadedCoaches; // direkt speichern
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint("Fehler beim Laden der Coaches: $e");
  //   }
  // }

  Future<void> loadClubs() async {
    try {
      final loadedClubs = await api.getClubs();
      clubs = loadedClubs; // direkt speichern
      notifyListeners();
    } catch (e) {
      debugPrint("Fehler beim Laden der Vereine: $e");
    }
  }



  Future<Coach?> getCoachById(int id) async {
    try {
      final coach = await api.getCoachById(id);
      return coach;
    } catch (e) {
      debugPrint("Fehler beim Laden des Coaches mit ID $id: $e");
      return null;
    }
  }

  /// Hilfsmethode: Club anhand des Namens suchen
  Club? getClubByName(String name) {
    try {
      return clubs.firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }
}