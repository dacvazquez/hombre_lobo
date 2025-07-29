import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/role.dart';

class CreateCustomRoleScreen extends StatefulWidget {
  const CreateCustomRoleScreen({super.key});

  @override
  State<CreateCustomRoleScreen> createState() => _CreateCustomRoleScreenState();
}

class _CreateCustomRoleScreenState extends State<CreateCustomRoleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _specialAbilityController = TextEditingController();
  RoleCategory _selectedCategory = RoleCategory.principal;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _specialAbilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(gameProvider.getLocalizedText('create_custom_role')),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nombre del rol
                            _buildTextField(
                              controller: _nameController,
                              label: gameProvider.getLocalizedText('role_name'),
                              hint: 'Ej: Guardián del Bosque',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingresa un nombre';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Descripción del rol
                            _buildTextField(
                              controller: _descriptionController,
                              label: gameProvider.getLocalizedText('role_description'),
                              hint: 'Describe las habilidades y características del rol',
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Por favor ingresa una descripción';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Habilidad especial
                            _buildTextField(
                              controller: _specialAbilityController,
                              label: gameProvider.getLocalizedText('special_ability'),
                              hint: 'Ej: Puede proteger a un jugador por noche (opcional)',
                              maxLines: 2,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Categoría
                            Text(
                              gameProvider.getLocalizedText('category'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildCategoryDropdown(gameProvider),
                            
                            const SizedBox(height: 24),
                            
                            // Información sobre categorías
                            Card(
                              color: Colors.white.withOpacity(0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Información sobre categorías:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildCategoryInfo('Principal', 'Roles básicos del juego'),
                                    _buildCategoryInfo('Aldeano Feliz', 'Aldeanos con habilidades positivas'),
                                    _buildCategoryInfo('Aldeano Enojado', 'Aldeanos con habilidades agresivas'),
                                    _buildCategoryInfo('Hombre Lobo', 'Roles del equipo de los lobos'),
                                    _buildCategoryInfo('Avanzado', 'Roles complejos y especiales'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(gameProvider.getLocalizedText('cancel')),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _createRole(gameProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(gameProvider.getLocalizedText('save')),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown(GameProvider gameProvider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RoleCategory>(
          value: _selectedCategory,
          dropdownColor: const Color(0xFF16213e),
          style: const TextStyle(color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: RoleCategory.values.map((category) {
            return DropdownMenuItem<RoleCategory>(
              value: category,
              child: Text(_getCategoryDisplayName(category, gameProvider)),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCategory = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoryInfo(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• $title: ',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryDisplayName(RoleCategory category, GameProvider gameProvider) {
    switch (category) {
      case RoleCategory.principal:
        return gameProvider.getLocalizedText('principal');
      case RoleCategory.aldeanoFeliz:
        return gameProvider.getLocalizedText('aldeano_feliz');
      case RoleCategory.aldeanoEnojado:
        return gameProvider.getLocalizedText('aldeano_enojado');
      case RoleCategory.hombreLobo:
        return gameProvider.getLocalizedText('hombre_lobo');
      case RoleCategory.avanzado:
        return gameProvider.getLocalizedText('avanzado');
      case RoleCategory.personalizado:
        return gameProvider.getLocalizedText('custom');
    }
  }

  void _createRole(GameProvider gameProvider) {
    if (_formKey.currentState!.validate()) {
      gameProvider.createCustomRole(
        _nameController.text.trim(),
        _descriptionController.text.trim(),
        _selectedCategory,
        _specialAbilityController.text.trim().isEmpty 
            ? null 
            : _specialAbilityController.text.trim(),
      );
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rol ${_nameController.text.trim()} creado'),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
    }
  }
} 