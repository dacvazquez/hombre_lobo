import 'player.dart';
import 'role.dart';

enum GamePhase {
  setup,
  night,
  day,
  voting,
  elimination,
  gameOver,
}

enum GameWinner {
  aldeanos,
  hombresLobo,
  none,
}

class GameState {
  final List<Player> players;
  final List<Role> selectedRoles;
  final GamePhase currentPhase;
  final int currentDay;
  final GameWinner winner;
  final String? eliminatedPlayer;
  final Map<String, String> nightActions;
  final bool isGameActive;

  GameState({
    required this.players,
    required this.selectedRoles,
    this.currentPhase = GamePhase.setup,
    this.currentDay = 1,
    this.winner = GameWinner.none,
    this.eliminatedPlayer,
    this.nightActions = const {},
    this.isGameActive = false,
  });

  GameState copyWith({
    List<Player>? players,
    List<Role>? selectedRoles,
    GamePhase? currentPhase,
    int? currentDay,
    GameWinner? winner,
    String? eliminatedPlayer,
    Map<String, String>? nightActions,
    bool? isGameActive,
  }) {
    return GameState(
      players: players ?? this.players,
      selectedRoles: selectedRoles ?? this.selectedRoles,
      currentPhase: currentPhase ?? this.currentPhase,
      currentDay: currentDay ?? this.currentDay,
      winner: winner ?? this.winner,
      eliminatedPlayer: eliminatedPlayer ?? this.eliminatedPlayer,
      nightActions: nightActions ?? this.nightActions,
      isGameActive: isGameActive ?? this.isGameActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'players': players.map((p) => p.toJson()).toList(),
      'selectedRoles': selectedRoles.map((r) => r.toJson()).toList(),
      'currentPhase': currentPhase.toString(),
      'currentDay': currentDay,
      'winner': winner.toString(),
      'eliminatedPlayer': eliminatedPlayer,
      'nightActions': nightActions,
      'isGameActive': isGameActive,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      players: (json['players'] as List)
          .map((p) => Player.fromJson(p))
          .toList(),
      selectedRoles: (json['selectedRoles'] as List)
          .map((r) => Role.fromJson(r))
          .toList(),
      currentPhase: GamePhase.values.firstWhere(
        (e) => e.toString() == json['currentPhase'],
      ),
      currentDay: json['currentDay'],
      winner: GameWinner.values.firstWhere(
        (e) => e.toString() == json['winner'],
      ),
      eliminatedPlayer: json['eliminatedPlayer'],
      nightActions: Map<String, String>.from(json['nightActions'] ?? {}),
      isGameActive: json['isGameActive'] ?? false,
    );
  }
} 