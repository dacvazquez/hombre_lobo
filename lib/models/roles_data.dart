import 'role.dart';

class RolesData {
  static List<Role> getAllRoles() {
    return [
      // Roles Principales
      Role(
        id: 'hombre_lobo',
        name: 'Hombre Lobo',
        description: 'Te despierta por la noche para elegir a una víctima a la que matar junto a tus colegas hombre lobo. Durante el día intentas hacerte pasar por un aldeano para que no te maten. Debe eliminar a todos los aldeanos para ganar.',
        category: RoleCategory.principal,
        specialAbility: 'Auuuuuuuuu',
      ),
      Role(
        id: 'aldeano',
        name: 'Aldeano',
        description: 'Un habitante pacífico del pueblo. Debe descubrir a los hombres lobo para sobrevivir. Durante el día discute con la aldea quién podría ser un hombre lobo y elige una persona a la que matar',
        category: RoleCategory.principal,
      ),
      Role(
        id: 'vidente',
        name: 'Vidente',
        description: 'Puedes descubrir la identidad (rol) de un jugador cada noche.',
        category: RoleCategory.principal,
        specialAbility: 'Veo veo',
      ),
      Role(
        id: 'doctor',
        name: 'Doctor',
        description: 'Puedes salvar a un jugador de la muerte una vez por noche. No se puede proteger al mismo jugador dos noches seguidas',
        category: RoleCategory.principal,
        specialAbility: 'Dame gracias papi',
      ),
      Role(
        id: 'vengador',
        name: 'Vengador',
        description: 'Si mueres, puedes eliminar a un jugador cualquiera antes de morir.',
        category: RoleCategory.principal,
        specialAbility: 'Alahu Akbar!!',
      ),
      Role(
        id: 'bruja',
        name: 'Bruja',
        description: 'Tienes una poción de vida y una de muerte. Puedes usarlas una vez cada una. La pocición de vida salva a otro jugador de morir a manos de los hombres lobo y la de muerte mata a otro jugador',
        category: RoleCategory.principal,
        specialAbility: 'Red||Black',
      ),

      // Aldeanos Felices
      Role(
        id: 'aprendiz_vidente',
        name: 'Aprendiz del Vidente',
        description: 'Si el vidente muere, tomas su lugar y te convierte en vidente.',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'Aprendi del mejor',
      ),
      Role(
        id: 'pacifista',
        name: 'Pacifista',
        description: 'Una vez por juego puedes revelar el rol de un jugador a todos los participantes y evitar que voten ese día. Perteneces al equipo de la aldea.',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'Algun problema?',
      ),
      Role(
        id: 'sacerdote',
        name: 'Sacerdote',
        description: 'Puedes echarle agua bendita a otro jugador. Si ese jugador es un hombre lobo, morirá. Si no lo es, tú moriras. Esta técnica solo se puede usar una vez',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'YOLO religioso',
      ),
      Role(
        id: 'alcalde',
        name: 'Alcalde',
        description: 'Si revelas tu rol a la aldea tu voto cuenta como dos votos.',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'Pinga en Mesa',
      ),
      Role(
        id: 'guardaespaldas',
        name: 'Guardaespaldas',
        description: 'Puedes proteger a un jugador cada noche. Si los hombres lobo intentan matar a ese jugador, mueres en su lugar',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'Tankeo',
      ),
      Role(
        id: 'detective',
        name: 'Detective',
        description: 'Cada noche puedes seleccionar a dos jugadores para ver si pertenecen al mismo equipo.',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'Gay radar',
      ),
      Role(
        id: 'hombre_sabio',
        name: 'Hombre Sabio',
        description: 'Los hombres lobo no pueden matarte por la noche',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'Im Batman bitch',
      ),
      Role(
        id: 'vidente_aura',
        name: 'Vidente de Aura',
        description: 'Cada noche puedes averiguar si un jugador es un hombre lobo ',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'Pendejismo',
      ),
      Role(
        id: 'principe_apuesto',
        name: 'Príncipe Apuesto',
        description: 'Si la aldea intenta matarte por primera vez, revelas tu identidad y sobrevives.',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'No pinchen al Timba',
      ),
      Role(
        id: 'hermano',
        name: 'Hermano',
        description: 'Puedes ver quienes son tus hermanos.',
        category: RoleCategory.aldeanoFeliz,
        specialAbility: 'Bros before hoes',
      ),

      // Aldeanos Enojados
      Role(
        id: 'cientifico_loco',
        name: 'Científico Loco',
        description: 'Al morir liberas un químico tóxico que mata a dos jugadores junto a ti.',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'Hail Hitler',
      ),
      Role(
        id: 'cazador_cabezas',
        name: 'Cazador de Cabezas',
        description: 'Tu meta es que tu objetivo sea ahorcado por la aldea durante el día. Si tu objetivo muere de otra manera te vuelves un aldeano normal',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'Llévame contigo',
      ),
      Role(
        id: 'tipo_duro',
        name: 'Tipo Duro',
        description: 'Cuando eres atacado por los hombres lobo sobrevives hasta el dia siguiente.',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'A mi hay que mamármela',
      ),
      Role(
        id: 'chico_travieso',
        name: 'Chico Travieso',
        description: 'Una vez durante el juego puedes intercambiar los roles de dos jugadores',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'Shambles',
      ),
      Role(
        id: 'dama_roja',
        name: 'Dama Roja',
        description: 'Durante la noche puedes visitar a otro jugador. Si ese jugador es un hombre lobo, o asesinado por uno, también mueres. Si los hombres lobo intentan matarte y estás visitando a otro jugador, sobrevives',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'Pretty Woman',
      ),
      Role(
        id: 'abuelita_gruñona',
        name: 'Abuelita Gruñona',
        description: 'Cada noche eliges a un jugador que no podrá votar durante el día.',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'Diazcanel Singao',
      ),
      Role(
        id: 'borracho',
        name: 'Borracho',
        description: 'No puedes hablar durante la partida porque estás ebrio.',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'Tócate María Silvia',
      ),
      Role(
        id: 'mongo',
        name: 'Mongo',
        description: 'Si la aldea intenta matarte durante el día, no mueres, pero pierdes tu derecho al voto.',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'No entiende las reglas',
      ),
      Role(
        id: 'pistolero',
        name: 'Pistolero',
        description: 'Tienes dos balas que puedes usar para matar a alguien. Los disparos son muy ruidosos, por lo que tu rol será revelado después de la primera bala',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'El 2 pa 2',
      ),
      Role(
        id: 'justiciero',
        name: 'Justiciero',
        description: 'Tienes una bala y puedes ver el rol de un jugador. Con la bala puedes matar a alguien. Cuando elijas ver el rol de otro jugador, no se podrá votar en esa ronda',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'Bala X Ojo',
      ),
      Role(
        id: 'tirador',
        name: 'Tirador',
        description: 'Durante la noche puedes marcar a un jugador como tu objetivo. El día siguiente puedes matar a tu objetivo o seleccionar a uno nuevo. Si intentas matar a un aldeano tu tiro rebotará y morirás, tienes dos flechas',
        category: RoleCategory.aldeanoEnojado,
        specialAbility: 'Ay dio mio un tirador',
      ),

      // Roles de Hombre Lobo
      Role(
        id: 'lobo_solitario',
        name: 'Lobo Solitario',
        description: 'Un hombre lobo que trabaja solo. Solo ganas si eres el ultimo hombre lobo con vida',
        category: RoleCategory.hombreLobo,
        specialAbility: 'Work better alone',
      ),
      Role(
        id: 'hombre_lobo_junior',
        name: 'Hombre Lobo Junior',
        description: 'Un lobo joven que muy tierno. Puedes seleccionar a un jugador para que muera cuando te maten',
        category: RoleCategory.hombreLobo,
        specialAbility: 'Te llevaré conmigo',
      ),
      Role(
        id: 'embrujado',
        name: 'Embrujado',
        description: 'Eres un aldeano normal hasta que los hombres lobos intenten matarte, en ese momento pasas a ser un hombre lobo.',
        category: RoleCategory.hombreLobo,
        specialAbility: 'Er diavlo pero que malditos tennis',
      ),
      Role(
        id: 'hechicera',
        name: 'Hechicera',
        description: 'Cada noche eliges a un jugador para averiguar si es vidente o hombre lobo. Perteneces a los hombres lobos',
        category: RoleCategory.hombreLobo,
        specialAbility: 'Ojitos o Pelitos',
      ),
      Role(
        id: 'lobo_its',
        name: 'Lobo ITS',
        description: 'Una vez por partida puedes morder a un jugador y comvertirlo en hombre lobo en vez de matarlo',
        category: RoleCategory.hombreLobo,
        specialAbility: 'Tocamiento ilícito',
      ),
      Role(
        id: 'lobo_vidente',
        name: 'Lobo Vidente',
        description: 'Cada noche puedes seleccionar a un jugador y desvelar su rol. Si eres el último hombre lobo con vida renuncias a tu habilidad y te vuelves un hombre lobo normal',
        category: RoleCategory.hombreLobo,
        specialAbility: 'Puede ver identidades',
      ),
      Role(
        id: 'hombre_lobo_alfa',
        name: 'Hombre Lobo Alfa',
        description: 'El líder de la manada, tu voto cuenta el doble.',
        category: RoleCategory.hombreLobo,
        specialAbility: 'Patriarcado lobezno',
      ),
      Role(
        id: 'hombre_lobo_sombras',
        name: 'Hombre Lobo de Sombras',
        description: 'Una vez por partida puedes doblar los votos de los hombres lobos durante el día, mientras se ocultan los votos. Los hombres lobos pueden ver los votos',
        category: RoleCategory.hombreLobo,
        specialAbility: 'Uno reverse',
      ),

      // Roles Avanzados
      Role(
        id: 'asesino_serie',
        name: 'Asesino en Serie',
        description: 'Cada noche puedes matar a otro jugador. Debes eliminar a todos los demás para ganar.',
        category: RoleCategory.avanzado,
        specialAbility: 'GG EZ',
      ),
      Role(
        id: 'cazador_sectas',
        name: 'Cazador de Sectas',
        description: 'Cada noche puedes seleccionar a un jugador. Si es el líder de la secta o parte de la secta, el jugador morirá',
        category: RoleCategory.avanzado,
        specialAbility: 'Caza mondongo',
      ),
      Role(
        id: 'lider_secta',
        name: 'Líder de Secta',
        description: 'Líder de una secta secreta. Cada noche elige a alguien para unirse a tu secta. Ganarás cuando todos los jugadores se unan a ella',
        category: RoleCategory.avanzado,
        specialAbility: 'Divide and Conquer',
      ),
      Role(
        id: 'saqueador_tumbas',
        name: 'Saqueador de Tumbas',
        description: 'Puede robar habilidades de jugadores muertos.',
        category: RoleCategory.avanzado,
        specialAbility: 'Roba habilidades de muertos',
      ),
      Role(
        id: 'cupido',
        name: 'Cupido',
        description: 'Durante la primera noche eliges a dos personas para ser amantes. Esa pareja solo puede ganar si son los últimos jugadores en pie. Si uno de los miembros de la pareja muere en cualquier momento, la otra persona también morirá inmediatamente',
        category: RoleCategory.avanzado,
        specialAbility: 'Romeo&Juliet',
      ),
      Role(
        id: 'bufon',
        name: 'Bufón',
        description: 'Tu objetivo es que te mate la aldea. Si la aldea te lincha, ganas',
        category: RoleCategory.avanzado,
        specialAbility: 'Quedaron: 🤡',
      ),
      Role(
        id: 'clarividente',
        name: 'Clarividente',
        description: 'Una vez por partida puedes revivir a un jugador.',
        category: RoleCategory.avanzado,
        specialAbility: 'Rise and Shine',
      ),
      Role(
        id: 'piromano',
        name: 'Pirómano',
        description: 'Cada noche puedes rociar a dos jugadores con gasolina o prender fuego a todos los jugadores anteriormente rociados para matarles. Ganas si eres el último jugador en pie. Los hombres lobos no pueden matarte.',
        category: RoleCategory.avanzado,
        specialAbility: 'Puede incendiar',
      ),
      Role(
        id: 'presidente',
        name: 'Presidente',
        description: 'Todos saben que eres Mr. Presidente!!! Si mueres, la aldea automáticamente pierde.',
        category: RoleCategory.avanzado,
        specialAbility: 'Get down Mr. President!!!',
      ),
    ];
  }

  static List<Role> getRolesByCategory(RoleCategory category) {
    return getAllRoles().where((role) => role.category == category).toList();
  }

  static Role? getRoleById(String id) {
    try {
      return getAllRoles().firstWhere((role) => role.id == id);
    } catch (e) {
      return null;
    }
  }
} 