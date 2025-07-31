import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player.dart';
import '../models/role.dart';
import 'game_screen.dart';

class PlayerRoleRevealScreen extends StatefulWidget {
  const PlayerRoleRevealScreen({super.key});

  @override
  State<PlayerRoleRevealScreen> createState() => _PlayerRoleRevealScreenState();
}

class _PlayerRoleRevealScreenState extends State<PlayerRoleRevealScreen> {
  int _currentPlayerIndex = 0;
  bool _showRole = false;
  bool _actionCompleted = false;
  String? _selectedTargetId;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final players = gameProvider.players;
        
        if (_currentPlayerIndex >= players.length) {
          // Todos los jugadores han visto sus roles y ejecutado sus acciones
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
                      child: Text(
                        currentPlayer.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  
                  // Información del rol y acción (solo se muestra cuando _showRole es true)
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
                    
                    const SizedBox(height: 24),
                    
                    // Acción específica según el rol
                    if (!_actionCompleted) _buildRoleAction(gameProvider, currentPlayer, role),
                  ],
                  
                  const SizedBox(height: 32),
                  
                  // Botón para continuar al siguiente jugador
                  if (_showRole && _actionCompleted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _currentPlayerIndex++;
                            _showRole = false;
                            _actionCompleted = false;
                            _selectedTargetId = null;
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

  Widget _buildRoleAction(GameProvider gameProvider, Player player, Role? role) {
    if (role == null) {
      return _buildContinueAction(gameProvider, player);
    }

    switch (role.id) {
      case 'hombre_lobo':
      case 'lobo_solitario':
      case 'hombre_lobo_junior':
      case 'hombre_lobo_alfa':
      case 'hombre_lobo_sombras':
        return _buildWolfVoteAction(gameProvider, player, role);
      case 'vidente':
      case 'vidente_aura':
      case 'lobo_vidente':
        return _buildInvestigateAction(gameProvider, player, role);
      case 'doctor':
      case 'guardaespaldas':
        return _buildProtectAction(gameProvider, player, role);
      case 'bruja':
        return _buildWitchAction(gameProvider, player, role);
      case 'detective':
        return _buildDetectiveAction(gameProvider, player, role);
      case 'tirador':
        return _buildShooterAction(gameProvider, player, role);
      case 'piromano':
        return _buildPyromaniacAction(gameProvider, player, role);
      case 'cupido':
        return _buildCupidAction(gameProvider, player, role);
      default:
        return _buildContinueAction(gameProvider, player);
    }
  }

  Widget _buildWolfVoteAction(GameProvider gameProvider, Player player, Role role) {
    final alivePlayers = gameProvider.getAlivePlayers().where((p) => p.id != player.id).toList();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Selecciona a tu víctima',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
          child: ListView.builder(
            itemCount: alivePlayers.length,
            itemBuilder: (context, index) {
              final target = alivePlayers[index];
              final isWolf = gameProvider.getRoleById(target.assignedRole ?? '')?.category == RoleCategory.hombreLobo;
              
              return Card(
                color: _selectedTargetId == target.id 
                    ? const Color(0xFFe94560).withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(target.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text(
                    target.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: isWolf ? const Text('🐺 Compañero lobo', style: TextStyle(color: Colors.orange)) : null,
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
                _actionCompleted = true;
              });
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Confirmar Voto'),
          ),
        ),
      ],
    );
  }

  Widget _buildInvestigateAction(GameProvider gameProvider, Player player, Role role) {
    final alivePlayers = gameProvider.getAlivePlayers().where((p) => p.id != player.id).toList();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Selecciona a quién investigar',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
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
                    child: Text(target.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
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
              final targetRole = gameProvider.getRoleById(_selectedTargetId!);
              gameProvider.registerNightAction(player.id, _selectedTargetId);
              
              // Mostrar resultado de la investigación
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Resultado de la investigación'),
                  content: Text('${gameProvider.getPlayerById(_selectedTargetId!)?.name} es: ${targetRole?.name ?? 'Desconocido'}'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _actionCompleted = true;
                        });
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Investigar'),
          ),
        ),
      ],
    );
  }

  Widget _buildProtectAction(GameProvider gameProvider, Player player, Role role) {
    final alivePlayers = gameProvider.getAlivePlayers().where((p) => p.id != player.id).toList();
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Selecciona a quién proteger',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          height: 300,
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
                    child: Text(target.name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
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
                _actionCompleted = true;
              });
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Proteger'),
          ),
        ),
      ],
    );
  }

  Widget _buildWitchAction(GameProvider gameProvider, Player player, Role role) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '¿Usar poción?',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para poción de vida
                  setState(() {
                    _actionCompleted = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Poción de Vida'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para poción de muerte
                  setState(() {
                    _actionCompleted = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Poción de Muerte'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _actionCompleted = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('No usar poción'),
          ),
        ),
      ],
    );
  }

  Widget _buildDetectiveAction(GameProvider gameProvider, Player player, Role role) {
    // Implementar lógica para detective (seleccionar 2 jugadores)
    return _buildContinueAction(gameProvider, player);
  }

  Widget _buildShooterAction(GameProvider gameProvider, Player player, Role role) {
    // Implementar lógica para tirador
    return _buildContinueAction(gameProvider, player);
  }

  Widget _buildPyromaniacAction(GameProvider gameProvider, Player player, Role role) {
    // Implementar lógica para piromano
    return _buildContinueAction(gameProvider, player);
  }

  Widget _buildCupidAction(GameProvider gameProvider, Player player, Role role) {
    // Implementar lógica para cupido (seleccionar 2 amantes)
    return _buildContinueAction(gameProvider, player);
  }

  Widget _buildContinueAction(GameProvider gameProvider, Player player) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'No tienes acción nocturna',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _actionCompleted = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Continuar'),
          ),
        ),
      ],
    );
  }
} 