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
  
  // NEU: Status für den ersten Start der App (SplashScreen)
  bool _isInitializing = true;
  bool get isInitializing => _isInitializing;

  /// NEU: Diese Methode wird in der main.dart beim App-Start aufgerufen
  Future<void> loadInitialData() async {
    _isInitializing = true;
    notifyListeners();

    try {
      // Wir laden alle Basisdaten
      await loadAllData();
    } catch (e) {
      debugPrint("Fehler bei der Initialisierung: $e");
    } finally {
      // Sobald fertig (auch bei Fehler), blenden wir den SplashScreen aus
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Lädt alle Daten nacheinander und speichert sie automatisch
  Future<void> loadAllData() async {
    isLoading = true;
    notifyListeners();

    try {
      // Parallelisiertes Laden für bessere Performance
      await Future.wait([
        loadPlayers(),
        // loadCoaches(),
        loadClubs(),
      ]);
    } catch (e) {
      debugPrint("Fehler beim Laden aller Daten: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPlayers() async {
    try {
      final loadedPlayers = await api.getPlayers();
      players = loadedPlayers;
      notifyListeners();
    } catch (e) {
      debugPrint("Fehler beim Laden der Spieler: $e");
    }
  }

  Future<void> loadClubs() async {
    try {
      final loadedClubs = await api.getClubs();
      clubs = loadedClubs;
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