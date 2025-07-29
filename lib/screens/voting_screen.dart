import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class VotingScreen extends StatefulWidget {
  final Function(String?) onVoteComplete;

  const VotingScreen({
    super.key,
    required this.onVoteComplete,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  String? _selectedPlayerId;
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    // Iniciar votación anónima cuando se abre la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().startAnonymousVoting();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final currentVotingPlayer = gameProvider.getCurrentVotingPlayer();
        final alivePlayers = gameProvider.getAlivePlayers();
        final voteSummary = gameProvider.getVoteSummary();
        final mostVotedPlayerId = gameProvider.getMostVotedPlayer();

        // Si la votación está completa, mostrar resultados
        if (gameProvider.votingComplete && !_showResults) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _showResults = true;
            });
          });
        }

        return Column(
          children: [
            // Instrucciones
            Card(
              color: Colors.white.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _showResults ? Icons.visibility : Icons.how_to_vote,
                      color: _showResults ? Colors.green : Colors.blue,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _showResults ? 'Resultados de la Votación' : 'Votación Anónima',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _showResults 
                          ? 'Todos han votado. Aquí están los resultados:'
                          : 'Es el turno de ${currentVotingPlayer?.name ?? 'N/A'}. Selecciona al jugador que quieres eliminar:',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (!_showResults) ...[
              // En la pantalla de votación, antes de mostrar la lista de jugadores a votar, mostrar el avatar y nombre del jugador que está votando:
              _buildVotingTurn(gameProvider),
              
              // Lista de jugadores para votar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jugadores Vivos (${alivePlayers.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: alivePlayers.length,
                        itemBuilder: (context, index) {
                          final player = alivePlayers[index];
                          final isSelected = _selectedPlayerId == player.id;
                          
                          return Card(
                            color: isSelected 
                                ? const Color(0xFFe94560).withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
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
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: isSelected
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedPlayerId = player.id;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Botón para confirmar voto
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedPlayerId != null
                        ? () {
                            gameProvider.registerVote(
                              currentVotingPlayer!.id,
                              _selectedPlayerId!,
                            );
                            setState(() {
                              _selectedPlayerId = null;
                            });
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFe94560),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Confirmar Voto',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Mostrar resultados
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen de Votos',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: voteSummary.length,
                        itemBuilder: (context, index) {
                          final entry = voteSummary.entries.elementAt(index);
                          final player = gameProvider.getPlayerById(entry.key);
                          final isMostVoted = entry.key == mostVotedPlayerId;
                          
                          return Card(
                            color: isMostVoted 
                                ? const Color(0xFFe94560).withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundImage: player?.imagePath != null
                                    ? FileImage(File(player!.imagePath!))
                                    : null,
                                child: player?.imagePath == null
                                    ? Text(
                                        player?.name[0].toUpperCase() ?? '?',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                              title: Text(
                                player?.name ?? 'Jugador Desconocido',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${entry.value} voto${entry.value != 1 ? 's' : ''}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: isMostVoted
                                  ? const Icon(
                                      Icons.warning,
                                      color: Colors.red,
                                    )
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Botón para continuar
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onVoteComplete(mostVotedPlayerId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
} 

// En la pantalla de votación, antes de mostrar la lista de jugadores a votar, mostrar el avatar y nombre del jugador que está votando:
Widget _buildVotingTurn(GameProvider gameProvider) {
  final currentPlayer = gameProvider.players[gameProvider.currentVotingPlayerIndex];
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 40,
        backgroundImage: currentPlayer.imagePath != null ? FileImage(File(currentPlayer.imagePath!)) : null,
        child: currentPlayer.imagePath == null ? Text(currentPlayer.name[0].toUpperCase(), style: const TextStyle(fontSize: 32, color: Colors.white)) : null,
      ),
      const SizedBox(height: 16),
      Text('Turno de:', style: const TextStyle(color: Colors.white70, fontSize: 16)),
      Text(currentPlayer.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),
      // ... aquí va la lista de jugadores a votar ...
    ],
  );
} 