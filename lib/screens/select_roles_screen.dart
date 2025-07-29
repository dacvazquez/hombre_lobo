import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/roles_data.dart';
import '../models/role.dart';
import 'create_custom_role_screen.dart';
import 'game_settings_screen.dart';

class SelectRolesScreen extends StatefulWidget {
  const SelectRolesScreen({super.key});

  @override
  State<SelectRolesScreen> createState() => _SelectRolesScreenState();
}

class _SelectRolesScreenState extends State<SelectRolesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(gameProvider.getLocalizedText('select_roles')),
            backgroundColor: const Color(0xFF1a1a2e),
            foregroundColor: Colors.white,
            elevation: 0,
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: const Color(0xFFe94560),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: gameProvider.getLocalizedText('principal')),
                Tab(text: gameProvider.getLocalizedText('aldeano_feliz')),
                Tab(text: gameProvider.getLocalizedText('aldeano_enojado')),
                Tab(text: gameProvider.getLocalizedText('hombre_lobo')),
                Tab(text: gameProvider.getLocalizedText('avanzado')),
                Tab(text: gameProvider.getLocalizedText('custom')),
              ],
            ),
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
            child: Column(
              children: [
                // Información de roles seleccionados
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white.withOpacity(0.1),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Roles seleccionados: ${gameProvider.selectedRoles.length}/${gameProvider.players.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _navigateToCreateCustomRole(context),
                            icon: const Icon(Icons.add),
                            label: Text(gameProvider.getLocalizedText('create_custom_role')),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFe94560),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (gameProvider.selectedRoles.length >= gameProvider.players.length)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Text(
                            '¡Límite alcanzado! No puedes seleccionar más roles que jugadores.',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                
                // Lista de roles seleccionados
                if (gameProvider.selectedRoles.isNotEmpty)
                  Container(
                    height: 80,
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _getUniqueRoles(gameProvider.selectedRoles).length,
                      itemBuilder: (context, index) {
                        final role = _getUniqueRoles(gameProvider.selectedRoles)[index];
                        final count = gameProvider.getRoleCount(role.id);
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          child: Chip(
                            label: Text('${role.name} ($count)'),
                            deleteIcon: const Icon(Icons.close, color: Colors.white),
                            onDeleted: () => gameProvider.removeSelectedRole(role.id),
                            backgroundColor: const Color(0xFFe94560),
                            labelStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    ),
                  ),
                
                // Contenido de las pestañas
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRoleList(RoleCategory.principal, gameProvider),
                      _buildRoleList(RoleCategory.aldeanoFeliz, gameProvider),
                      _buildRoleList(RoleCategory.aldeanoEnojado, gameProvider),
                      _buildRoleList(RoleCategory.hombreLobo, gameProvider),
                      _buildRoleList(RoleCategory.avanzado, gameProvider),
                      _buildCustomRolesList(gameProvider),
                    ],
                  ),
                ),
                
                // Botón para iniciar juego
                Container(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: gameProvider.canStartGame()
                          ? () => _startGame(context, gameProvider)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        gameProvider.getLocalizedText('start_game'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleList(RoleCategory category, GameProvider gameProvider) {
    final roles = RolesData.getRolesByCategory(category);
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: roles.length,
      itemBuilder: (context, index) {
        final role = roles[index];
        final roleCount = gameProvider.getRoleCount(role.id);
        final isSelected = roleCount > 0;
        
        return Card(
          color: isSelected 
              ? const Color(0xFFe94560).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    role.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$roleCount',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            subtitle: Text(
              role.description,
              style: const TextStyle(color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => gameProvider.removeSelectedRole(role.id),
                  ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle, 
                    color: gameProvider.selectedRoles.length >= gameProvider.players.length 
                        ? Colors.grey 
                        : Colors.green
                  ),
                  onPressed: gameProvider.selectedRoles.length >= gameProvider.players.length 
                      ? null 
                      : () => gameProvider.addSelectedRole(role),
                ),
              ],
            ),
            onTap: () => gameProvider.addSelectedRole(role),
          ),
        );
      },
    );
  }

  Widget _buildCustomRolesList(GameProvider gameProvider) {
    final customRoles = gameProvider.selectedRoles.where((role) => role.isCustom).toList();
    
    if (customRoles.isEmpty) {
      return const Center(
        child: Text(
          'No hay roles personalizados creados',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customRoles.length,
      itemBuilder: (context, index) {
        final role = customRoles[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          child: ListTile(
            title: Text(
              role.name,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              role.description,
              style: const TextStyle(color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => gameProvider.removeSelectedRole(role.id),
            ),
          ),
        );
      },
    );
  }

  void _navigateToCreateCustomRole(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateCustomRoleScreen(),
      ),
    );
  }

  List<Role> _getUniqueRoles(List<Role> roles) {
    final uniqueRoles = <Role>[];
    final seenIds = <String>{};
    
    for (final role in roles) {
      if (!seenIds.contains(role.id)) {
        uniqueRoles.add(role);
        seenIds.add(role.id);
      }
    }
    
    return uniqueRoles;
  }

  void _startGame(BuildContext context, GameProvider gameProvider) {
    gameProvider.assignRolesRandomly();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const GameSettingsScreen(),
      ),
    );
  }
} 