import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class PlayerRoleRevealScreen extends StatefulWidget {
  const PlayerRoleRevealScreen({super.key});

  @override
  State<PlayerRoleRevealScreen> createState() => _PlayerRoleRevealScreenState();
}

class _PlayerRoleRevealScreenState extends State<PlayerRoleRevealScreen> {
  int _currentPlayerIndex = 0;
  bool _showRole = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final players = gameProvider.players;
        
        if (_currentPlayerIndex >= players.length) {
          // Todos los jugadores han visto sus roles, ir al juego
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const GameScreen(),
              ),
            );
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final currentPlayer = players[_currentPlayerIndex];
        final role = gameProvider.getRoleById(currentPlayer.assignedRole ?? '');

        return Scaffold(
          appBar: AppBar(
            title: Text('Jugador ${_currentPlayerIndex + 1} de ${players.length}'),
            backgroundColor: const Color(0xFF1a1a2e),
            foregroundColor: Colors.white,
            elevation: 0,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar del jugador
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showRole = !_showRole;
                      });
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: currentPlayer.imagePath != null
                          ? FileImage(File(currentPlayer.imagePath!))
                          : null,
                      child: currentPlayer.imagePath == null
                          ? Text(
                              currentPlayer.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Nombre del jugador
                  Text(
                    currentPlayer.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Instrucciones
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.touch_app,
                            color: Color(0xFFe94560),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Entregue el dispositivo a este jugador. Selecciona el perfil de arriba cuando estés listo.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Botón para mostrar rol
                  if (!_showRole)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showRole = true;
                          });
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('Mostrar Rol'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFe94560),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  
                  // Información del rol (solo se muestra cuando _showRole es true)
                  if (_showRole) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: const Color(0xFFe94560).withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              role?.name ?? 'Desconocido',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            if (role?.description != null)
                              Text(
                                role!.description,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            if (role?.specialAbility != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Habilidad: ${role!.specialAbility}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Botón para continuar al siguiente jugador
                  if (_showRole)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentPlayerIndex++;
                            _showRole = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          _currentPlayerIndex < players.length - 1 ? 'Siguiente Jugador' : 'Comenzar Juego',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 