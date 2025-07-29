import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'select_roles_screen.dart';

class AddPlayersScreen extends StatefulWidget {
  const AddPlayersScreen({super.key});

  @override
  State<AddPlayersScreen> createState() => _AddPlayersScreenState();
}

class _AddPlayersScreenState extends State<AddPlayersScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedImagePath;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(gameProvider.getLocalizedText('add_player')),
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Formulario para añadir jugador
                  Card(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gameProvider.getLocalizedText('player_name'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Ingresa el nombre del jugador',
                                hintStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFe94560)),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingresa un nombre';
                                }
                                if (gameProvider.players.any((player) => 
                                    player.name.toLowerCase() == value.toLowerCase())) {
                                  return 'Ya existe un jugador con ese nombre';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Selección de imagen
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    gameProvider.getLocalizedText('select_image'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _pickImage(gameProvider),
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('Galería'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFe94560),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Vista previa de imagen
                            if (_selectedImagePath != null)
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFe94560)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(_selectedImagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            
                            const SizedBox(height: 16),
                            
                            // Botón para añadir jugador
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _addPlayer(gameProvider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFe94560),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: const Text('Añadir Jugador'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Lista de jugadores
                  Expanded(
                    child: Card(
                      color: Colors.white.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Jugadores (${gameProvider.players.length})',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (gameProvider.players.isNotEmpty)
                                  TextButton.icon(
                                    onPressed: () => _clearAllPlayers(gameProvider),
                                    icon: const Icon(Icons.clear_all, color: Colors.red),
                                    label: const Text('Limpiar', style: TextStyle(color: Colors.red)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: gameProvider.players.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No hay jugadores añadidos',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: gameProvider.players.length,
                                      itemBuilder: (context, index) {
                                        final player = gameProvider.players[index];
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
                                            trailing: IconButton(
                                              icon: const Icon(Icons.delete, color: Colors.red),
                                              onPressed: () => _removePlayer(gameProvider, player.id),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botón para continuar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: gameProvider.players.length >= 3
                          ? () => _continueToRoles(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Continuar (${gameProvider.players.length}/3)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Future<void> _pickImage(GameProvider gameProvider) async {
    final imagePath = await gameProvider.pickImage();
    if (imagePath != null) {
      setState(() {
        _selectedImagePath = imagePath;
      });
    }
  }

  void _addPlayer(GameProvider gameProvider) {
    if (_formKey.currentState!.validate()) {
      gameProvider.addPlayer(_nameController.text.trim(), _selectedImagePath);
      _nameController.clear();
      setState(() {
        _selectedImagePath = null;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jugador ${_nameController.text.trim()} añadido'),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
    }
  }

  void _removePlayer(GameProvider gameProvider, String playerId) {
    gameProvider.removePlayer(playerId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Jugador eliminado'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _clearAllPlayers(GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los jugadores?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              gameProvider.resetGame();
              Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _continueToRoles(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectRolesScreen(),
      ),
    );
  }
} 