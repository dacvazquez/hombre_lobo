import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(gameProvider.getLocalizedText('rules')),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      'Objetivo del Juego',
                      'Los aldeanos deben descubrir y eliminar a todos los hombres lobo antes de que estos eliminen a todos los aldeanos.',
                      Icons.track_changes,
                    ),
                    
                    _buildSection(
                      'Fases del Juego',
                      'El juego se divide en fases nocturnas y diurnas que se alternan hasta que un equipo gane.',
                      Icons.schedule,
                    ),
                    
                    _buildSubSection('Fase Nocturna', [
                      'Todos los jugadores cierran los ojos',
                      'Los hombres lobo se despiertan y eligen una víctima',
                      'Los roles especiales (vidente, doctor, etc.) realizan sus acciones',
                      'Al final de la noche, se anuncia si alguien murió'
                    ]),
                    
                    _buildSubSection('Fase Diurna', [
                      'Todos los jugadores se despiertan',
                      'Se discute lo sucedido durante la noche',
                      'Se realiza una votación para eliminar a un sospechoso',
                      'El jugador con más votos es eliminado'
                    ]),
                    
                    _buildSection(
                      'Roles Principales',
                      'Cada jugador tiene un rol único con habilidades especiales.',
                      Icons.people,
                    ),
                    
                    _buildRoleInfo('Hombre Lobo', 'Se despierta por la noche para elegir víctimas. Debe eliminar a todos los aldeanos para ganar.', Colors.red),
                    _buildRoleInfo('Aldeano', 'Un habitante pacífico. Debe descubrir a los hombres lobo para sobrevivir.', Colors.green),
                    _buildRoleInfo('Vidente', 'Puede descubrir la identidad de un jugador cada noche.', Colors.blue),
                    _buildRoleInfo('Doctor', 'Puede salvar a un jugador de la muerte una vez por noche.', Colors.cyan),
                    _buildRoleInfo('Vengador', 'Si muere, puede eliminar a un jugador antes de morir.', Colors.orange),
                    _buildRoleInfo('Bruja', 'Tiene pociones de vida y muerte. Puede usarlas una vez cada una.', Colors.purple),
                    
                    _buildSection(
                      'Cómo Ganar',
                      'El juego termina cuando uno de los equipos logra su objetivo.',
                      Icons.emoji_events,
                    ),
                    
                    _buildSubSection('Los Aldeanos Ganan Si:', [
                      'Eliminan a todos los hombres lobo',
                      'Descubren la identidad de todos los lobos'
                    ]),
                    
                    _buildSubSection('Los Hombres Lobo Ganan Si:', [
                      'Eliminan a todos los aldeanos',
                      'El número de lobos es igual o mayor al de aldeanos'
                    ]),
                    
                    _buildSection(
                      'Consejos de Juego',
                      'Algunas estrategias útiles para jugar mejor.',
                      Icons.lightbulb,
                    ),
                    
                    _buildSubSection('Para Aldeanos:', [
                      'Observa el comportamiento de otros jugadores',
                      'Presta atención a las acusaciones y defensas',
                      'Usa la lógica para identificar patrones',
                      'Confía en los roles especiales del equipo'
                    ]),
                    
                    _buildSubSection('Para Hombres Lobo:', [
                      'Actúa como un aldeano para no ser descubierto',
                      'Coordina con otros lobos en secreto',
                      'Distrae la atención hacia otros jugadores',
                      'Usa la confusión a tu favor'
                    ]),
                    
                    _buildSection(
                      'Roles Especiales',
                      'Además de los roles principales, hay muchos roles especiales con habilidades únicas.',
                      Icons.star,
                    ),
                    
                    _buildSubSection('Aldeanos Felices:', [
                      'Aprendiz del Vidente - Si el vidente muere, tomas su lugar y te convierte en vidente',
                      'Pacifista - Una vez por juego puedes revelar el rol de un jugador y evitar que voten ese día',
                      'Sacerdote - Puedes echarle agua bendita a otro jugador. Si es hombre lobo muere, si no tú mueres',
                      'Alcalde - Si revelas tu rol a la aldea tu voto cuenta como dos votos',
                      'Guardaespaldas - Puedes proteger a un jugador cada noche. Si los lobos intentan matarlo, mueres tú',
                      'Detective - Cada noche puedes seleccionar a dos jugadores para ver si pertenecen al mismo equipo',
                      'Hombre Sabio - Los hombres lobo no pueden matarte por la noche',
                      'Vidente de Aura - Cada noche puedes averiguar si un jugador es un hombre lobo',
                      'Príncipe Apuesto - Si la aldea intenta matarte por primera vez, revelas tu identidad y sobrevives',
                      'Hermano - Puedes ver quienes son tus hermanos'
                    ]),
                    
                    _buildSubSection('Aldeanos Enojados:', [
                      'Científico Loco - Al morir liberas un químico tóxico que mata a dos jugadores junto a ti',
                      'Cazador de Cabezas - Tu meta es que tu objetivo sea ahorcado por la aldea. Si muere de otra manera te vuelves aldeano normal',
                      'Tipo Duro - Cuando eres atacado por los hombres lobo sobrevives hasta el día siguiente',
                      'Chico Travieso - Una vez durante el juego puedes intercambiar los roles de dos jugadores',
                      'Dama Roja - Durante la noche puedes visitar a otro jugador. Si ese jugador es un hombre lobo, o asesinado por uno, también mueres. Si los hombres lobo intentan matarte y estás visitando a otro jugador, sobrevives',
                      'Abuelita Gruñona - Cada noche eliges a un jugador que no podrá votar durante el día.',
                      'Borracho - No puedes hablar durante la partida porque estás ebrio',
                      'Mongo - Si la aldea intenta matarte durante el día, no mueres, pero pierdes tu derecho al voto',
                      'Pistolero - Tienes dos balas que puedes usar para matar a alguien. Los disparos son muy ruidosos',
                      'Justiciero - Tienes una bala y puedes ver el rol de un jugador. Con la bala puedes matar a alguien',
                      'Tirador - Durante la noche puedes marcar a un jugador como tu objetivo. El día siguiente puedes matar a tu objetivo'
                    ]),
                    
                    _buildSubSection('Hombres Lobo:', [
                      'Lobo Solitario - Un hombre lobo que trabaja solo. Solo ganas si eres el último hombre lobo con vida',
                      'Hombre Lobo Junior - Un lobo joven muy tierno. Puedes seleccionar a un jugador para que muera cuando te maten',
                      'Embrujado - Eres un aldeano normal hasta que los hombres lobos intenten matarte, en ese momento pasas a ser un hombre lobo',
                      'Hechicera - Cada noche eliges a un jugador para averiguar si es vidente o hombre lobo. Perteneces a los hombres lobos',
                      'Lobo ITS - Una vez por partida puedes morder a un jugador y convertirlo en hombre lobo en vez de matarlo',
                      'Lobo Vidente - Cada noche puedes seleccionar a un jugador y desvelar su rol. Si eres el último lobo renuncias a tu habilidad',
                      'Hombre Lobo Alfa - El líder de la manada, tu voto cuenta el doble',
                      'Hombre Lobo de Sombras - Se oculta de investigaciones'
                    ]),
                    
                    _buildSubSection('Roles Avanzados:', [
                      'Asesino en Serie - Cada noche puedes matar a otro jugador. Debes eliminar a todos los demás para ganar',
                      'Cazador de Sectas - Cada noche puedes seleccionar a un jugador. Si es el líder de la secta o parte de la secta, el jugador morirá',
                      'Saqueador de Tumbas - Puede robar habilidades de jugadores muertos',
                      'Líder de Secta - Líder de una secta secreta. Cada noche elige a alguien para unirse a tu secta. Ganarás cuando todos se unan',
                      'Cupido - Durante la primera noche eliges a dos personas para ser amantes. Esa pareja solo puede ganar si son los últimos en pie',
                      'Bufón - Tu objetivo es que te mate la aldea. Si la aldea te lincha, ganas',
                      'Clarividente - Una vez por partida puedes revivir a un jugador',
                      'Pirómano - Cada noche puedes rociar a dos jugadores con gasolina o prender fuego a todos los anteriormente rociados',
                      'Presidente - Todos saben que eres Mr. Presidente!!! Si mueres, la aldea automáticamente pierde'
                    ]),
                    
                    const SizedBox(height: 32),
                    
                    // Información adicional
                    Card(
                      color: Colors.white.withOpacity(0.1),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Notas Importantes:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildNote('• El juego se juega en un solo dispositivo'),
                            _buildNote('• Los jugadores pasan el teléfono para ver su rol'),
                            _buildNote('• Las discusiones se hacen en voz alta'),
                            _buildNote('• El narrador (app) guía las fases del juego'),
                            _buildNote('• Puedes crear roles personalizados'),
                            _buildNote('• El juego es más divertido con 6-12 jugadores'),
                          ],
                        ),
                      ),
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

  Widget _buildSection(String title, String description, IconData icon) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFe94560), size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 12, left: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFe94560),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: Colors.white70)),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleInfo(String name, String description, Color color) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 8, left: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNote(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
} 