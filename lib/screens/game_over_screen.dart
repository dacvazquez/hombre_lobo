import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_state.dart';
import 'home_screen.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final gameState = gameProvider.gameState;
        final winner = gameState.winner;
        final alivePlayers = gameProvider.getAlivePlayers();
        final deadPlayers = gameProvider.getDeadPlayers();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Fin del Juego'),
            backgroundColor: const Color(0xFF1a1a2e),
            foregroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Resultado del juego
                  _buildGameResult(winner),
                  
                  const SizedBox(height: 32),
                  
                  // Estadísticas
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildStatistics(gameProvider, alivePlayers, deadPlayers),
                          
                          const SizedBox(height: 24),
                          
                          // Lista de jugadores vivos
                          if (alivePlayers.isNotEmpty) ...[
                            _buildPlayerSection('Jugadores Vivos', alivePlayers, Colors.green),
                            const SizedBox(height: 16),
                          ],
                          
                          // Lista de jugadores muertos
                          if (deadPlayers.isNotEmpty) ...[
                            _buildPlayerSection('Jugadores Eliminados', deadPlayers, Colors.red),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showRoleReveal(context, gameProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFe94560),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Ver Todos los Roles'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _newGame(context, gameProvider),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Volver al Inicio'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameResult(GameWinner winner) {
    String title;
    String subtitle;
    Color color;
    IconData icon;

    switch (winner) {
      case GameWinner.aldeanos:
        title = '¡Los Aldeanos Ganaron!';
        subtitle = 'Han logrado eliminar a todos los hombres lobo';
        color = Colors.green;
        icon = Icons.people;
        break;
      case GameWinner.hombresLobo:
        title = '¡Los Hombres Lobo Ganaron!';
        subtitle = 'Han eliminado a todos los aldeanos';
        color = Colors.red;
        icon = Icons.nightlight;
        break;
      default:
        title = 'Juego Terminado';
        subtitle = 'El juego ha finalizado';
        color = Colors.grey;
        icon = Icons.gamepad;
    }

    return Card(
      color: color.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(GameProvider gameProvider, List alivePlayers, List deadPlayers) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas del Juego',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Duración', '${gameProvider.gameState.currentDay} días'),
            _buildStatRow('Jugadores vivos', '${alivePlayers.length}'),
            _buildStatRow('Jugadores eliminados', '${deadPlayers.length}'),
            _buildStatRow('Hombres lobo vivos', '${gameProvider.getAliveWerewolves()}'),
            _buildStatRow('Aldeanos vivos', '${gameProvider.getAliveVillagers()}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerSection(String title, List players, Color statusColor) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...players.map((player) => _buildPlayerTile(player, statusColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerTile(dynamic player, Color statusColor) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final role = gameProvider.getRoleById(player.assignedRole ?? '');
        
        return Card(
          color: Colors.white.withOpacity(0.05),
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
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              role?.name ?? 'Desconocido',
              style: TextStyle(color: statusColor),
            ),
            trailing: Icon(
              player.isAlive ? Icons.check_circle : Icons.person_off,
              color: statusColor,
            ),
          ),
        );
      },
    );
  }

  void _showRoleReveal(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Todos los Roles'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: gameProvider.players.map((player) {
                final role = gameProvider.getRoleById(player.assignedRole ?? '');
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: player.imagePath != null
                        ? FileImage(File(player.imagePath!))
                        : null,
                    child: player.imagePath == null
                        ? Text(player.name[0].toUpperCase())
                        : null,
                  ),
                  title: Text(player.name),
                  subtitle: Text(role?.name ?? 'Desconocido'),
                  trailing: Icon(
                    player.isAlive ? Icons.check_circle : Icons.person_off,
                    color: player.isAlive ? Colors.green : Colors.red,
                  ),
                );
              }).toList(),
            ),
          ),
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

  void _newGame(BuildContext context, GameProvider gameProvider) {
    gameProvider.resetGame();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }
} 