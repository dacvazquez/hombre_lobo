import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/player.dart';

class PlayerRoleScreen extends StatelessWidget {
  final Player player;

  const PlayerRoleScreen({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final role = gameProvider.getRoleById(player.assignedRole ?? '');

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tu Rol'),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Avatar del jugador
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: player.imagePath != null
                        ? FileImage(File(player.imagePath!))
                        : null,
                    child: player.imagePath == null
                        ? Text(
                            player.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Nombre del jugador
                  Text(
                    player.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Información del rol
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            'Tu Rol Es:',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            role?.name ?? 'Desconocido',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Descripción del rol
                          if (role?.description != null) ...[
                            Text(
                              'Descripción:',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              role!.description,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          
                          // Habilidad especial
                          if (role?.specialAbility != null) ...[
                            const SizedBox(height: 24),
                            Text(
                              'Habilidad Especial:',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              role!.specialAbility!,
                              style: const TextStyle(
                                color: Color(0xFFe94560),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Información adicional según el rol
                  if (role != null) _buildRoleSpecificInfo(role),
                  
                  const Spacer(),
                  
                  // Botón para continuar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFe94560),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Entendido',
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

  Widget _buildRoleSpecificInfo(dynamic role) {
    String teamInfo = '';
    String objective = '';
    
    switch (role.category.toString()) {
      case 'RoleCategory.hombreLobo':
        teamInfo = 'Equipo: Hombres Lobo';
        objective = 'Elimina a todos los aldeanos para ganar';
        break;
      case 'RoleCategory.principal':
      case 'RoleCategory.aldeanoFeliz':
      case 'RoleCategory.aldeanoEnojado':
        teamInfo = 'Equipo: Aldeanos';
        objective = 'Descubre y elimina a todos los hombres lobo';
        break;
      case 'RoleCategory.avanzado':
        if (role.id == 'asesino_serie' || role.id == 'lider_secta') {
          teamInfo = 'Equipo: Independiente';
          objective = 'Gana solo eliminando a todos los demás';
        } else {
          teamInfo = 'Equipo: Aldeanos';
          objective = 'Descubre y elimina a todos los hombres lobo';
        }
        break;
      default:
        teamInfo = 'Equipo: Aldeanos';
        objective = 'Descubre y elimina a todos los hombres lobo';
    }
    
    return Card(
      color: Colors.white.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              teamInfo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              objective,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 