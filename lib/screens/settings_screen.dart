import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(gameProvider.getLocalizedText('settings')),
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
                children: [
                  // Configuración de idioma
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
                                Icons.language,
                                color: Color(0xFFe94560),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                gameProvider.getLocalizedText('language'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildLanguageOption(
                            context,
                            gameProvider,
                            'es',
                            gameProvider.getLocalizedText('spanish'),
                            '🇪🇸',
                          ),
                          const SizedBox(height: 8),
                          _buildLanguageOption(
                            context,
                            gameProvider,
                            'en',
                            gameProvider.getLocalizedText('english'),
                            '🇺🇸',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Configuración de días del juego
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
                                Icons.calendar_today,
                                color: Color(0xFFe94560),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                gameProvider.getLocalizedText('game_days'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Días del juego: ${gameProvider.gameDays}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.white),
                                onPressed: gameProvider.gameDays > 1
                                    ? () => gameProvider.changeGameDays(gameProvider.gameDays - 1)
                                    : null,
                              ),
                              Text(
                                '${gameProvider.gameDays}',
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: gameProvider.gameDays < 10
                                    ? () => gameProvider.changeGameDays(gameProvider.gameDays + 1)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Información de la aplicación
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
                                Icons.info,
                                color: Color(0xFFe94560),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Información de la Aplicación',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow('Versión', '1.0.0'),
                          _buildInfoRow('Desarrollador', 'Daniel Capote UwU'),
                          _buildInfoRow('Plataforma', 'Android / iOS'),
                          _buildInfoRow('Tipo de Juego', 'Local Multiplayer'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Características de la aplicación
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
                                Icons.star,
                                color: Color(0xFFe94560),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Características',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildFeatureItem('🎮 Juego local en un solo dispositivo'),
                          _buildFeatureItem('👥 Soporte para 3-12 jugadores'),
                          _buildFeatureItem('🎭 40+ roles predefinidos'),
                          _buildFeatureItem('✨ Creación de roles personalizados'),
                          _buildFeatureItem('📱 Interfaz moderna y intuitiva'),
                          _buildFeatureItem('🌙 Fases nocturnas y diurnas'),
                          _buildFeatureItem('🗣️ Sistema de votación integrado'),
                          _buildFeatureItem('📸 Perfiles con imágenes personalizadas'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Botón para reiniciar juego
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showResetDialog(context, gameProvider),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reiniciar Juego'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildLanguageOption(
    BuildContext context,
    GameProvider gameProvider,
    String languageCode,
    String languageName,
    String flag,
  ) {
    final isSelected = gameProvider.currentLanguage == languageCode;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isSelected 
            ? const Color(0xFFe94560).withOpacity(0.3)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? const Color(0xFFe94560) : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => gameProvider.changeLanguage(languageCode),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  flag,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    languageName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFFe94560),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF4CAF50),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reiniciar Juego'),
        content: const Text(
          '¿Estás seguro de que quieres reiniciar el juego? '
          'Esto eliminará todos los jugadores y roles seleccionados.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              gameProvider.resetGame();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Juego reiniciado'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            child: const Text('Reiniciar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
} 