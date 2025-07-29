enum RoleCategory {
  principal,
  aldeanoFeliz,
  aldeanoEnojado,
  hombreLobo,
  avanzado,
  personalizado,
}

class Role {
  final String id;
  final String name;
  final String description;
  final RoleCategory category;
  final String? specialAbility;
  final bool isCustom;
  final String? customDescription;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.specialAbility,
    this.isCustom = false,
    this.customDescription,
  });

  Role copyWith({
    String? id,
    String? name,
    String? description,
    RoleCategory? category,
    String? specialAbility,
    bool? isCustom,
    String? customDescription,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      specialAbility: specialAbility ?? this.specialAbility,
      isCustom: isCustom ?? this.isCustom,
      customDescription: customDescription ?? this.customDescription,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category.toString(),
      'specialAbility': specialAbility,
      'isCustom': isCustom,
      'customDescription': customDescription,
    };
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: RoleCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
      ),
      specialAbility: json['specialAbility'],
      isCustom: json['isCustom'] ?? false,
      customDescription: json['customDescription'],
    );
  }
} 