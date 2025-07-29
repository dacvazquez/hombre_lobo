import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../models/player.dart';
import '../models/role.dart';
import '../models/game_state.dart';
import '../models/roles_data.dart';

class GameProvider extends ChangeNotifier {
  List<Player> _players = [];
  List<Role> _selectedRoles = [];
  GameState _gameState = GameState(players: [], selectedRoles: []);
  String _currentLanguage = 'es';
  final bool _isLoading = false;
  int _gameDays = 5;
  final Map<String, String> _votes = {}; // playerId -> votedPlayerId
  int _currentVotingPlayerIndex = 0;
  bool _votingComplete = false;
  
  // Configuración del juego
  bool _useDefaultSettings = true;
  bool _revealRoleOnDeath = false;
  bool _hideDebateTime = false;
  bool _noKillFirstNight = false;
  bool _villagerNightActions = false;
  bool _allowNoVote = false;
  bool _hideVoteCount = false;

  // Getters
  List<Player> get players => _players;
  List<Role> get selectedRoles => _selectedRoles;
  GameState get gameState => _gameState;
  String get currentLanguage => _currentLanguage;
  bool get isLoading => _isLoading;
  int get gameDays => _gameDays;
  Map<String, String> get votes => _votes;
  int get currentVotingPlayerIndex => _currentVotingPlayerIndex;
  bool get votingComplete => _votingComplete;
  
  // Getters de configuración
  bool get useDefaultSettings => _useDefaultSettings;
  bool get revealRoleOnDeath => _revealRoleOnDeath;
  bool get hideDebateTime => _hideDebateTime;
  bool get noKillFirstNight => _noKillFirstNight;
  bool get villagerNightActions => _villagerNightActions;
  bool get allowNoVote => _allowNoVote;
  bool get hideVoteCount => _hideVoteCount;

  int _maxGameDays = 5;
  int get maxGameDays => _maxGameDays;
  set maxGameDays(int value) {
    _maxGameDays = value;
    notifyListeners();
  }

  Map<String, String> _nightActions = {}; // playerId -> targetPlayerId
  Map<String, String> get nightActions => _nightActions;

  // Constructor
  GameProvider() {
    _loadSettings();
  }

  // Cargar configuraciones guardadas
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('language') ?? 'es';
      _gameDays = prefs.getInt('gameDays') ?? 5;
      notifyListeners();
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  // Guardar configuraciones
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', _currentLanguage);
      await prefs.setInt('gameDays', _gameDays);
    } catch (e) {
      print('Error saving settings: $e');
    }
  }

  // Cambiar idioma
  void changeLanguage(String language) {
    _currentLanguage = language;
    _saveSettings();
    notifyListeners();
  }

  // Cambiar días del juego
  void changeGameDays(int days) {
    _gameDays = days;
    _saveSettings();
    notifyListeners();
  }

  // Métodos para cambiar configuración del juego
  void setUseDefaultSettings(bool value) {
    _useDefaultSettings = value;
    if (value) {
      _revealRoleOnDeath = false;
      _hideDebateTime = false;
      _noKillFirstNight = false;
      _villagerNightActions = false;
      _allowNoVote = false;
      _hideVoteCount = false;
    }
    notifyListeners();
  }

  void setRevealRoleOnDeath(bool value) {
    _revealRoleOnDeath = value;
    notifyListeners();
  }

  void setHideDebateTime(bool value) {
    _hideDebateTime = value;
    notifyListeners();
  }

  void setNoKillFirstNight(bool value) {
    _noKillFirstNight = value;
    notifyListeners();
  }

  void setVillagerNightActions(bool value) {
    _villagerNightActions = value;
    notifyListeners();
  }

  void setAllowNoVote(bool value) {
    _allowNoVote = value;
    notifyListeners();
  }

  void setHideVoteCount(bool value) {
    _hideVoteCount = value;
    notifyListeners();
  }

  // Iniciar votación anónima
  void startAnonymousVoting() {
    _votes.clear();
    _currentVotingPlayerIndex = 0;
    _votingComplete = false;
    notifyListeners();
  }

  // Obtener jugador actual para votar
  Player? getCurrentVotingPlayer() {
    final alivePlayers = getAlivePlayers();
    if (_currentVotingPlayerIndex < alivePlayers.length) {
      return alivePlayers[_currentVotingPlayerIndex];
    }
    return null;
  }

  // Registrar voto
  void registerVote(String voterId, String votedPlayerId) {
    _votes[voterId] = votedPlayerId;
    _currentVotingPlayerIndex++;
    
    // Verificar si todos han votado
    final alivePlayers = getAlivePlayers();
    if (_currentVotingPlayerIndex >= alivePlayers.length) {
      _votingComplete = true;
    }
    
    notifyListeners();
  }

  // Obtener jugador más votado
  String? getMostVotedPlayer() {
    if (_votes.isEmpty) return null;
    
    final voteCounts = <String, int>{};
    for (final votedPlayerId in _votes.values) {
      voteCounts[votedPlayerId] = (voteCounts[votedPlayerId] ?? 0) + 1;
    }
    
    String? mostVotedPlayerId;
    int maxVotes = 0;
    
    for (final entry in voteCounts.entries) {
      if (entry.value > maxVotes) {
        maxVotes = entry.value;
        mostVotedPlayerId = entry.key;
      }
    }
    
    return mostVotedPlayerId;
  }

  // Obtener resumen de votos
  Map<String, int> getVoteSummary() {
    final voteCounts = <String, int>{};
    for (final votedPlayerId in _votes.values) {
      voteCounts[votedPlayerId] = (voteCounts[votedPlayerId] ?? 0) + 1;
    }
    return voteCounts;
  }

  // Añadir jugador
  Future<void> addPlayer(String name, String? imagePath) async {
    final player = Player(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      imagePath: imagePath,
    );
    _players.add(player);
    notifyListeners();
  }

  // Eliminar jugador
  void removePlayer(String playerId) {
    _players.removeWhere((player) => player.id == playerId);
    notifyListeners();
  }

  // Seleccionar imagen para jugador
  Future<String?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Añadir rol seleccionado
  void addSelectedRole(Role role) {
    // Verificar que no se exceda el número de jugadores
    if (_selectedRoles.length < _players.length) {
      _selectedRoles.add(role);
      notifyListeners();
    }
  }

  // Remover rol seleccionado
  void removeSelectedRole(String roleId) {
    final index = _selectedRoles.indexWhere((role) => role.id == roleId);
    if (index != -1) {
      _selectedRoles.removeAt(index);
      notifyListeners();
    }
  }

  // Verificar si el juego puede comenzar
  bool canStartGame() {
    return _players.length >= 3 && _selectedRoles.length >= _players.length;
  }

  // Asignar roles aleatoriamente
  void assignRolesRandomly() {
    if (!canStartGame()) return;

    // Crear una copia de los roles seleccionados
    List<Role> availableRoles = List.from(_selectedRoles);
    
    // Mezclar los roles
    availableRoles.shuffle();
    
    // Asignar roles a los jugadores
    for (int i = 0; i < _players.length; i++) {
      if (i < availableRoles.length) {
        _players[i] = _players[i].copyWith(assignedRole: availableRoles[i].id);
      }
    }

    // Crear nuevo estado de juego
    _gameState = GameState(
      players: List.from(_players),
      selectedRoles: List.from(_selectedRoles),
      currentPhase: GamePhase.night,
      isGameActive: true,
    );

    notifyListeners();
  }

  // Obtener jugador por ID
  Player? getPlayerById(String playerId) {
    try {
      return _players.firstWhere((player) => player.id == playerId);
    } catch (e) {
      return null;
    }
  }

  // Obtener rol por ID
  Role? getRoleById(String roleId) {
    return RolesData.getRoleById(roleId);
  }

  // Contar instancias de un rol específico
  int getRoleCount(String roleId) {
    return _selectedRoles.where((role) => role.id == roleId).length;
  }

  // Obtener jugadores vivos
  List<Player> getAlivePlayers() {
    return _players.where((player) => player.isAlive).toList();
  }

  // Obtener jugadores muertos
  List<Player> getDeadPlayers() {
    return _players.where((player) => !player.isAlive).toList();
  }

  // Contar hombres lobo vivos
  int getAliveWerewolves() {
    return _players.where((player) {
      if (!player.isAlive) return false;
      final role = getRoleById(player.assignedRole ?? '');
      return role?.category == RoleCategory.hombreLobo || 
             role?.category == RoleCategory.avanzado && 
             (role?.id == 'asesino_serie' || role?.id == 'lider_secta');
    }).length;
  }

  // Contar aldeanos vivos
  int getAliveVillagers() {
    return _players.where((player) {
      if (!player.isAlive) return false;
      final role = getRoleById(player.assignedRole ?? '');
      return role?.category == RoleCategory.principal ||
             role?.category == RoleCategory.aldeanoFeliz ||
             role?.category == RoleCategory.aldeanoEnojado ||
             role?.category == RoleCategory.avanzado;
    }).length;
  }

  // Verificar si el juego ha terminado
  GameWinner checkGameWinner() {
    final aliveWerewolves = getAliveWerewolves();
    final aliveVillagers = getAliveVillagers();

    if (aliveWerewolves == 0) {
      return GameWinner.aldeanos;
    } else if (aliveWerewolves >= aliveVillagers) {
      return GameWinner.hombresLobo;
    }

    return GameWinner.none;
  }

  // Avanzar a la siguiente fase, considerando el máximo de días
  void nextPhase() {
    switch (_gameState.currentPhase) {
      case GamePhase.night:
        _gameState = _gameState.copyWith(currentPhase: GamePhase.day);
        break;
      case GamePhase.day:
        _gameState = _gameState.copyWith(currentPhase: GamePhase.voting);
        break;
      case GamePhase.voting:
        _gameState = _gameState.copyWith(currentPhase: GamePhase.elimination);
        break;
      case GamePhase.elimination:
        final winner = checkGameWinner();
        if (winner != GameWinner.none) {
          _gameState = _gameState.copyWith(
            currentPhase: GamePhase.gameOver,
            winner: winner,
          );
        } else {
          // Avanzar día solo si no se ha alcanzado el máximo
          if (_gameState.currentDay < _maxGameDays) {
            _gameState = _gameState.copyWith(
              currentPhase: GamePhase.night,
              currentDay: _gameState.currentDay + 1,
            );
          } else {
            _gameState = _gameState.copyWith(
              currentPhase: GamePhase.gameOver,
              winner: checkGameWinner(),
            );
          }
        }
        break;
      default:
        break;
    }
    notifyListeners();
  }

  // Eliminar jugador
  void eliminatePlayer(String playerId) {
    final playerIndex = _players.indexWhere((p) => p.id == playerId);
    if (playerIndex != -1) {
      _players[playerIndex] = _players[playerIndex].copyWith(isAlive: false);
      _gameState = _gameState.copyWith(
        players: List.from(_players),
        eliminatedPlayer: playerId,
      );
      notifyListeners();
    }
  }

  // Reiniciar juego
  void resetGame() {
    _players = [];
    _selectedRoles = [];
    _gameState = GameState(players: [], selectedRoles: []);
    notifyListeners();
  }

  // Crear rol personalizado
  void createCustomRole(String name, String description, RoleCategory category, String? specialAbility) {
    final customRole = Role(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      category: category,
      specialAbility: specialAbility,
      isCustom: true,
      customDescription: description,
    );
    
    _selectedRoles.add(customRole);
    notifyListeners();
  }

  // Obtener texto localizado
  String getLocalizedText(String key) {
    final Map<String, Map<String, String>> translations = {
      'es': {
        'app_title': 'Hombre Lobo',
        'new_game': 'Nuevo Juego',
        'rules': 'Reglas',
        'settings': 'Configuración',
        'add_player': 'Añadir Jugador',
        'player_name': 'Nombre del Jugador',
        'select_image': 'Seleccionar Imagen',
        'remove_player': 'Eliminar Jugador',
        'select_roles': 'Seleccionar Roles',
        'start_game': 'Iniciar Juego',
        'night_phase': 'Fase Nocturna',
        'day_phase': 'Fase Diurna',
        'voting_phase': 'Fase de Votación',
        'elimination_phase': 'Fase de Eliminación',
        'game_over': 'Fin del Juego',
        'villagers_win': '¡Los Aldeanos Ganaron!',
        'werewolves_win': '¡Los Hombres Lobo Ganaron!',
        'continue': 'Continuar',
        'back': 'Atrás',
        'next': 'Siguiente',
        'cancel': 'Cancelar',
        'save': 'Guardar',
        'delete': 'Eliminar',
        'confirm': 'Confirmar',
        'language': 'Idioma',
        'spanish': 'Español',
        'english': 'Inglés',
        'create_custom_role': 'Crear Rol Personalizado',
        'role_name': 'Nombre del Rol',
        'role_description': 'Descripción del Rol',
        'special_ability': 'Habilidad Especial',
        'category': 'Categoría',
        'principal': 'Principal',
        'aldeano_feliz': 'Aldeano Feliz',
        'aldeano_enojado': 'Aldeano Enojado',
        'hombre_lobo': 'Hombre Lobo',
        'avanzado': 'Avanzado',
        'custom': 'Personalizado',
        'game_days': 'Días del Juego',
      },
      'en': {
        'app_title': 'Werewolf',
        'new_game': 'New Game',
        'rules': 'Rules',
        'settings': 'Settings',
        'add_player': 'Add Player',
        'player_name': 'Player Name',
        'select_image': 'Select Image',
        'remove_player': 'Remove Player',
        'select_roles': 'Select Roles',
        'start_game': 'Start Game',
        'night_phase': 'Night Phase',
        'day_phase': 'Day Phase',
        'voting_phase': 'Voting Phase',
        'elimination_phase': 'Elimination Phase',
        'game_over': 'Game Over',
        'villagers_win': 'Villagers Win!',
        'werewolves_win': 'Werewolves Win!',
        'continue': 'Continue',
        'back': 'Back',
        'next': 'Next',
        'cancel': 'Cancel',
        'save': 'Save',
        'delete': 'Delete',
        'confirm': 'Confirm',
        'language': 'Language',
        'spanish': 'Spanish',
        'english': 'English',
        'create_custom_role': 'Create Custom Role',
        'role_name': 'Role Name',
        'role_description': 'Role Description',
        'special_ability': 'Special Ability',
        'category': 'Category',
        'principal': 'Principal',
        'aldeano_feliz': 'Happy Villager',
        'aldeano_enojado': 'Angry Villager',
        'hombre_lobo': 'Werewolf',
        'avanzado': 'Advanced',
        'custom': 'Custom',
        'game_days': 'Game Days',
      },
    };

    return translations[_currentLanguage]?[key] ?? key;
  }

  void registerNightAction(String playerId, String? targetPlayerId) {
    if (targetPlayerId != null) {
      _nightActions[playerId] = targetPlayerId;
    } else {
      _nightActions.remove(playerId);
    }
    notifyListeners();
  }

  void clearNightActions() {
    _nightActions.clear();
    notifyListeners();
  }
} 