import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'narrator_screen.dart';

class GameSettingsScreen extends StatelessWidget {
  const GameSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Configuración del Juego'),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Configuración predeterminada
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.settings,
                                color: Color(0xFFe94560),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Configuración Predeterminada',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Switch(
                                value: gameProvider.useDefaultSettings,
                                onChanged: gameProvider.setUseDefaultSettings,
                                activeColor: const Color(0xFFe94560),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Configuración General
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'General',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingItem(
                            'Revelar el rol del jugador cuando muere',
                            gameProvider.revealRoleOnDeath,
                            gameProvider.setRevealRoleOnDeath,
                            gameProvider.useDefaultSettings,
                          ),
                          _buildSettingItem(
                            'Ocultar el tiempo de debate',
                            gameProvider.hideDebateTime,
                            gameProvider.setHideDebateTime,
                            gameProvider.useDefaultSettings,
                          ),
                          _buildSettingItem(
                            'No hay asesinatos durante la primera noche',
                            gameProvider.noKillFirstNight,
                            gameProvider.setNoKillFirstNight,
                            gameProvider.useDefaultSettings,
                          ),
                          _buildSettingItem(
                            'Acciones nocturnas de aldeano',
                            gameProvider.villagerNightActions,
                            gameProvider.setVillagerNightActions,
                            gameProvider.useDefaultSettings,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Días del juego',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, color: Colors.white),
                                    onPressed: gameProvider.maxGameDays > 1
                                        ? () => gameProvider.maxGameDays--
                                        : null,
                                  ),
                                  Text(
                                    gameProvider.maxGameDays.toString(),
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, color: Colors.white),
                                    onPressed: gameProvider.maxGameDays < 10
                                        ? () => gameProvider.maxGameDays++
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Configuración de Votación
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Votación',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingItem(
                            'Los jugadores pueden elegir no votar',
                            gameProvider.allowNoVote,
                            gameProvider.setAllowNoVote,
                            gameProvider.useDefaultSettings,
                          ),
                          _buildSettingItem(
                            'Ocultar número de votos',
                            gameProvider.hideVoteCount,
                            gameProvider.setHideVoteCount,
                            gameProvider.useDefaultSettings,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Botón para continuar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NarratorScreen(),
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

  Widget _buildSettingItem(
    String title,
    bool value,
    Function(bool) onChanged,
    bool disabled,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: disabled ? Colors.white54 : Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: disabled ? null : onChanged,
            activeColor: const Color(0xFFe94560),
          ),
        ],
      ),
    );
  }
} 