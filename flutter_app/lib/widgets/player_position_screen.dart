import 'package:flutter/material.dart';

class PlayerPositionField extends StatelessWidget {
  final String exactPosition;
  final List<String> secondPositions;

  const PlayerPositionField({
    super.key,
    required this.exactPosition,
    required this.secondPositions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Positionierung",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            // Begrenzt die Breite auf dem Desktop, damit es nicht "unendlich" breit wird
            constraints: const BoxConstraints(maxWidth: 450),
            // AspectRatio 0.8 sorgt für ein schönes Hochformat (Fußballfeld-Optik)
            child: AspectRatio(
              aspectRatio: 0.8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[900],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.green[800]!, Colors.green[900]!],
                  ),
                ),
                child: Stack(
                  children: [
                    // Spielfeld-Markierungen (Mittelkreis & Strafräume angedeutet)
                    _buildFieldLines(),

                    // Zweitpositionen (Gelb) zuerst zeichnen
                    ...secondPositions.map((pos) =>
                        _buildPositionIndicator(pos, Colors.orangeAccent, false)),

                    // Hauptposition (Grün) oben auf liegend
                    _buildPositionIndicator(exactPosition, Colors.greenAccent, true),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPositionIndicator(String position, Color color, bool isMain) {
    // Falls die Position leer ist oder nur ein Bindestrich, nichts zeichnen
    if (position == '-' || position.isEmpty) return const SizedBox.shrink();

    final alignment = _getAlignmentForPosition(position);

    return Align(
      alignment: alignment,
      child: Container(
        // Margin verhindert, dass die Kreise direkt am weißen Rand kleben
        margin: const EdgeInsets.all(20),
        width: isMain ? 36 : 28,
        height: isMain ? 36 : 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2))
          ],
          border: Border.all(color: Colors.white, width: isMain ? 2.5 : 1.5),
        ),
        child: Center(
          child: Text(
            position.toUpperCase(),
            style: TextStyle(
              color: Colors.black,
              fontSize: isMain ? 11 : 9,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Hilfswidget für die Spielfeld-Optik
  Widget _buildFieldLines() {
    return Stack(
      children: [
        // Mittellinie
        Center(
          child: Container(
            height: 1,
            color: Colors.white10,
          ),
        ),
        // Mittelkreis
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white10, width: 2),
            ),
          ),
        ),
        // Strafraum oben
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 140,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10, width: 2),
            ),
          ),
        ),
        // Strafraum unten
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 140,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white10, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Alignment _getAlignmentForPosition(String pos) {
    switch (pos.toUpperCase().trim()) {
      case 'TW': return const Alignment(0, 0.95);
      case 'IV': return const Alignment(0, 0.7);
      case 'LV': return const Alignment(-0.8, 0.7);
      case 'RV': return const Alignment(0.8, 0.7);
      case 'ZM': return const Alignment(0, 0);
      case 'LM': return const Alignment(-0.85, 0);
      case 'RM': return const Alignment(0.85, 0);
      case 'OM': return const Alignment(0, -0.35);
      case 'LF': return const Alignment(-0.8, -0.75);
      case 'LW': return const Alignment(-0.8, -0.75);
      case 'RF': return const Alignment(0.8, -0.75);
      case 'RW': return const Alignment(0.8, -0.75);
      case 'ST': return const Alignment(0, -0.85);
      default: return const Alignment(0, 0);
    }
  }
}