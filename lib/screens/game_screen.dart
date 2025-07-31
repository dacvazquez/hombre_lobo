import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import '../models/player.dart';
import '../models/role.dart';
import 'player_role_screen.dart';
import 'voting_screen.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String? _selectedPlayerId;
  String? _selectedTargetId;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final gameState = gameProvider.gameState;
        
        if (gameState.currentPhase == GamePhase.gameOver) {
          return const GameOverScreen();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_getPhaseTitle(gameState.currentPhase)),
            backgroundColor: const Color(0xFF1a1a2e),
            foregroundColor: Colors.white,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () => _showGameInfo(context, gameProvider),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1a1a2e),
                  Color(0xFF16213e),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Información del día y fase
                  _buildPhaseInfo(gameState),
                  
                  const SizedBox(height: 24),
                  
                  // Contenido principal según la fase
                  Expanded(
                    child: _buildPhaseContent(gameProvider, gameState),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botón para continuar
                  _buildContinueButton(gameProvider, gameState),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhaseInfo(GameState gameState) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Día ${gameState.currentDay}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _getPhaseIcon(gameState.currentPhase),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _getPhaseDescription(gameState.currentPhase),
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhaseContent(GameProvider gameProvider, GameState gameState) {
    switch (gameState.currentPhase) {
      case GamePhase.night:
        return _buildNightPhase(gameProvider, gameState);
      case GamePhase.day:
        return _buildDayPhase(gameProvider, gameState);
      case GamePhase.voting:
        return VotingScreen(
          onVoteComplete: (eliminatedPlayerId) {
            if (eliminatedPlayerId != null) {
              gameProvider.eliminatePlayer(eliminatedPlayerId);
            }
            gameProvider.nextPhase();
          },
        );
      case GamePhase.elimination:
        return _buildEliminationPhase(gameProvider, gameState);
      default:
        return const Center(
          child: Text(
            'Fase no implementada',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }

  Widget _buildNightPhase(GameProvider gameProvider, GameState gameState) {
    final alivePlayers = gameProvider.getAlivePlayers();
    final currentNightActionIndex = gameProvider.nightActions.length;
    if (currentNightActionIndex >= alivePlayers.length) {
      // Todas las acciones nocturnas han sido realizadas
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.nightlight, color: Color(0xFFe94560), size: 48),
          const SizedBox(height: 16),
          const Text('Acciones nocturnas completadas', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Aquí se procesan las acciones nocturnas (ejecutar ataques, protecciones, etc)
              // y se avanza a la siguiente fase
              gameProvider.nextPhase();
              gameProvider.clearNightActions();
            },
            child: const Text('Continuar al día'),
          ),
        ],
      );
    }
    final player = alivePlayers[currentNightActionIndex];
    final role = gameProvider.getRoleById(player.assignedRole ?? '');
    return _buildNightActionForPlayer(gameProvider, player, role);
  }

  Widget _buildNightActionForPlayer(GameProvider gameProvider, Player player, Role? role) {
    // Lógica para mostrar la acción según el rol
    if (role == null) {
      return _nightContinueButton(gameProvider);
    }
    
    // Para roles con acciones especiales
    if (role.id == 'hombre_lobo' || role.id == 'doctor' || role.id == 'vidente') {
      String actionText = '';
      switch (role.id) {
        case 'hombre_lobo':
          actionText = 'Selecciona a la víctima de los hombres lobo';
          break;
        case 'doctor':
          actionText = 'Selecciona a quién proteger esta noche';
          break;
        case 'vidente':
          actionText = 'Selecciona a quién investigar esta noche';
          break;
      }
      return _nightSelectTarget(gameProvider, player, actionText);
    }
    
    // Aldeano y otros roles sin acción: solo continuar
    return _nightContinueButton(gameProvider);
  }

  Widget _nightSelectTarget(GameProvider gameProvider, Player player, String title) {
    final alivePlayers = gameProvider.getAlivePlayers().where((p) => p.id != player.id).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: player.imagePath != null ? FileImage(File(player.imagePath!)) : null,
          child: player.imagePath == null ? Text(player.name[0].toUpperCase(), style: const TextStyle(fontSize: 32, color: Colors.white)) : null,
        ),
        const SizedBox(height: 16),
        Text(player.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: alivePlayers.length,
            itemBuilder: (context, index) {
              final target = alivePlayers[index];
              return Card(
                color: _selectedTargetId == target.id 
                    ? const Color(0xFFe94560).withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: target.imagePath != null ? FileImage(File(target.imagePath!)) : null,
                    child: target.imagePath == null ? Text(target.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)) : null,
                  ),
                  title: Text(target.name, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    setState(() {
                      _selectedTargetId = target.id;
                    });
                  },
                  trailing: _selectedTargetId == target.id ? const Icon(Icons.check, color: Colors.green) : null,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectedTargetId != null ? () {
              gameProvider.registerNightAction(player.id, _selectedTargetId);
              setState(() {
                _selectedTargetId = null;
              });
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Confirmar'),
          ),
        ),
      ],
    );
  }

  Widget _nightContinueButton(GameProvider gameProvider) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          gameProvider.registerNightAction(gameProvider.getAlivePlayers()[gameProvider.nightActions.length].id, null);
        },
        child: const Text('Continuar'),
      ),
    );
  }

  Widget _buildDayPhase(GameProvider gameProvider, GameState gameState) {
    return Column(
      children: [
        Card(
          color: Colors.white.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.wb_sunny,
                  color: Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Todos los jugadores se despiertan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Discute lo sucedido durante la noche',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Lista de jugadores vivos
        Expanded(
          child: _buildPlayersList(gameProvider, showAliveOnly: true),
        ),
      ],
    );
  }

  Widget _buildEliminationPhase(GameProvider gameProvider, GameState gameState) {
    final eliminatedPlayer = gameState.eliminatedPlayer != null
        ? gameProvider.getPlayerById(gameState.eliminatedPlayer!)
        : null;

    return Column(
      children: [
        if (eliminatedPlayer != null)
          Card(
            color: Colors.red.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.person_off,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${eliminatedPlayer.name} ha sido eliminado',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Su rol era: ${gameProvider.getRoleById(eliminatedPlayer.assignedRole ?? '')?.name ?? 'Desconocido'}',
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        
        const SizedBox(height: 24),
        
        // Lista de jugadores restantes
        Expanded(
          child: _buildPlayersList(gameProvider, showAliveOnly: true),
        ),
      ],
    );
  }

  Widget _buildPlayersList(GameProvider gameProvider, {bool showAliveOnly = false}) {
    final players = showAliveOnly 
        ? gameProvider.getAlivePlayers()
        : gameProvider.players;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          showAliveOnly ? 'Jugadores Vivos' : 'Todos los Jugadores',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              return Card(
                color: Colors.white.withOpacity(0.1),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: player.imagePath != null
                        ? FileImage(File(player.imagePath!))
                        : null,
                    child: player.imagePath == null
                        ? Text(
                            player.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  title: Text(
                    player.name,
                    style: TextStyle(
                      color: player.isAlive ? Colors.white : Colors.white54,
                    ),
                  ),
                  subtitle: Text(
                    player.isAlive ? 'Vivo' : 'Eliminado',
                    style: TextStyle(
                      color: player.isAlive ? Colors.green : Colors.red,
                    ),
                  ),
                  trailing: player.isAlive
                      ? IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.white70),
                          onPressed: () => _showPlayerRole(context, gameProvider, player),
                        )
                      : const Icon(Icons.person_off, color: Colors.red),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton(GameProvider gameProvider, GameState gameState) {
    String buttonText;
    VoidCallback? onPressed;

    switch (gameState.currentPhase) {
      case GamePhase.night:
        buttonText = 'Continuar a Día';
        onPressed = () => gameProvider.nextPhase();
        break;
      case GamePhase.day:
        buttonText = 'Iniciar Votación';
        onPressed = () => gameProvider.nextPhase();
        break;
      case GamePhase.elimination:
        final winner = gameProvider.checkGameWinner();
        if (winner != GameWinner.none) {
          buttonText = 'Ver Resultados';
          onPressed = () => gameProvider.nextPhase();
        } else {
          buttonText = 'Continuar a Noche';
          onPressed = () => gameProvider.nextPhase();
        }
        break;
      default:
        buttonText = 'Continuar';
        onPressed = null;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFe94560),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  String _getPhaseTitle(GamePhase phase) {
    switch (phase) {
      case GamePhase.night:
        return 'Fase Nocturna';
      case GamePhase.day:
        return 'Fase Diurna';
      case GamePhase.voting:
        return 'Votación';
      case GamePhase.elimination:
        return 'Eliminación';
      default:
        return 'Juego';
    }
  }

  String _getPhaseDescription(GamePhase phase) {
    switch (phase) {
      case GamePhase.night:
        return 'Los hombres lobo eligen su víctima';
      case GamePhase.day:
        return 'Discute y acusa a los sospechosos';
      case GamePhase.voting:
        return 'Vota para eliminar a un jugador';
      case GamePhase.elimination:
        return 'Se revela el jugador eliminado';
      default:
        return '';
    }
  }

  Widget _getPhaseIcon(GamePhase phase) {
    switch (phase) {
      case GamePhase.night:
        return const Icon(Icons.nightlight, color: Color(0xFFe94560));
      case GamePhase.day:
        return const Icon(Icons.wb_sunny, color: Colors.orange);
      case GamePhase.voting:
        return const Icon(Icons.how_to_vote, color: Colors.blue);
      case GamePhase.elimination:
        return const Icon(Icons.person_off, color: Colors.red);
      default:
        return const Icon(Icons.gamepad, color: Colors.white);
    }
  }

  void _showPlayerRole(BuildContext context, GameProvider gameProvider, dynamic player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerRoleScreen(player: player),
      ),
    );
  }

  void _showGameInfo(BuildContext context, GameProvider gameProvider) {
    final aliveWerewolves = gameProvider.getAliveWerewolves();
    final aliveVillagers = gameProvider.getAliveVillagers();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información del Juego'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jugadores vivos: ${gameProvider.getAlivePlayers().length}'),
            Text('Hombres lobo vivos: $aliveWerewolves'),
            Text('Aldeanos vivos: $aliveVillagers'),
            const SizedBox(height: 16),
            const Text(
              'Consejo:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('Observa el comportamiento de otros jugadores para identificar a los lobos.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
} 