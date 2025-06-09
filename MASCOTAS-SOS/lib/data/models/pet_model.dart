class PetModel {
  final String id;
  final String ownerId;
  final String name;
  final String type;
  final String? breed;
  final int? age;
  final String? gender;
  final String? description;
  final List<String>? photos;
  final DateTime createdAt;
  final bool isAdopted;

  PetModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.type,
    this.breed,
    this.age,
    this.gender,
    this.description,
    this.photos,
    required this.createdAt,
    this.isAdopted = false,
  });

  // Crear desde un mapa (por ejemplo, desde Firestore)
  factory PetModel.fromMap(Map<String, dynamic> map, String id) {
    return PetModel(
      id: id,
      ownerId: map['owner_id'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      breed: map['breed'],
      age: map['age'],
      gender: map['gender'],
      description: map['description'],
      photos: map['photos'] != null ? List<String>.from(map['photos']) : null,
      createdAt: map['created_at'] != null 
        ? (map['created_at'] as Timestamp).toDate() 
        : DateTime.now(),
      isAdopted: map['is_adopted'] ?? false,
    );
  }

  // Convertir a un mapa (por ejemplo, para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'owner_id': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'gender': gender,
      'description': description,
      'photos': photos,
      'created_at': createdAt,
      'is_adopted': isAdopted,
    };
  }

  // Crear una copia con algunos campos actualizados
  PetModel copyWith({
    String? ownerId,
    String? name,
    String? type,
    String? breed,
    int? age,
    String? gender,
    String? description,
    List<String>? photos,
    bool? isAdopted,
  }) {
    return PetModel(
      id: id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      description: description ?? this.description,
      photos: photos ?? this.photos,
      createdAt: createdAt,
      isAdopted: isAdopted ?? this.isAdopted,
    );
  }
}
