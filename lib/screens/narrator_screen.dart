import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'night_phase_screen.dart';

class NarratorScreen extends StatelessWidget {
  const NarratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final firstPlayer = gameProvider.players.isNotEmpty ? gameProvider.players.first : null;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Narrador del Juego'),
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
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Avatar del narrador
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: firstPlayer?.imagePath != null
                        ? FileImage(File(firstPlayer!.imagePath!))
                        : null,
                    child: firstPlayer?.imagePath == null
                        ? Text(
                            firstPlayer?.name[0].toUpperCase() ?? '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Nombre del narrador
                  Text(
                    '${firstPlayer?.name ?? 'Jugador'} es el narrador del juego',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
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
                            Icons.info_outline,
                            color: Color(0xFFe94560),
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Instrucciones del Juego',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Todos los jugadores deben sentarse unos frente a otros en un gran círculo. El primer jugador es el narrador del juego, que tendrá el dispositivo al inicio de cada noche y día, y leerá las instrucciones.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFe94560).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFe94560),
                                width: 2,
                              ),
                            ),
                            child: const Text(
                              'Entrega el dispositivo al narrador del juego',
                              style: TextStyle(
                                color: Color(0xFFe94560),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Botón para continuar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NightPhaseScreen(),
                          ),
                        );
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 