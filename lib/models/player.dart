
class Player {
  final String id;
  final String name;
  final String? imagePath;
  String? assignedRole;
  bool isAlive;
  bool isProtected;

  Player({
    required this.id,
    required this.name,
    this.imagePath,
    this.assignedRole,
    this.isAlive = true,
    this.isProtected = false,
  });

  Player copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? assignedRole,
    bool? isAlive,
    bool? isProtected,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      assignedRole: assignedRole ?? this.assignedRole,
      isAlive: isAlive ?? this.isAlive,
      isProtected: isProtected ?? this.isProtected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'assignedRole': assignedRole,
      'isAlive': isAlive,
      'isProtected': isProtected,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      imagePath: json['imagePath'],
      assignedRole: json['assignedRole'],
      isAlive: json['isAlive'] ?? true,
      isProtected: json['isProtected'] ?? false,
    );
  }
} 