// Modelo de adopción sin dependencias de Firebase

class AdoptionModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String petType;
  final String breed;
  final String color;
  final String size;
  final String gender;
  final String age;
  final bool isVaccinated;
  final bool isSterilized;
  final bool isDewormed;
  final bool specialNeeds;
  final String specialNeedsDescription;
  final String status; // "disponible", "en proceso" o "adoptado"
  final String location;
  final String contactPhone;
  final String requirements;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> imageUrls;
  final double latitude;
  final double longitude;

  AdoptionModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.petType,
    required this.breed,
    required this.color,
    required this.size,
    required this.gender,
    required this.age,
    required this.isVaccinated,
    required this.isSterilized,
    required this.isDewormed,
    required this.specialNeeds,
    required this.specialNeedsDescription,
    required this.status,
    required this.location,
    required this.contactPhone,
    required this.requirements,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
  });

  // Crear desde un mapa (por ejemplo, desde Firestore)
  factory AdoptionModel.fromMap(Map<String, dynamic> map, String id) {
    return AdoptionModel(
      id: id,
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      petType: map['pet_type'] ?? '',
      breed: map['breed'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      gender: map['gender'] ?? '',
      age: map['age'] ?? '',
      isVaccinated: map['is_vaccinated'] ?? false,
      isSterilized: map['is_sterilized'] ?? false,
      isDewormed: map['is_dewormed'] ?? false,
      specialNeeds: map['special_needs'] ?? false,
      specialNeedsDescription: map['special_needs_description'] ?? '',
      status: map['status'] ?? 'disponible',
      location: map['location'] ?? '',
      contactPhone: map['contact_phone'] ?? '',
      requirements: map['requirements'] ?? '',
      createdAt: map['created_at'] != null 
        ? (map['created_at'] is DateTime 
            ? map['created_at'] 
            : DateTime.tryParse(map['created_at'].toString()) ?? DateTime.now())
        : DateTime.now(),
      updatedAt: map['updated_at'] != null 
        ? (map['updated_at'] is DateTime 
            ? map['updated_at'] 
            : DateTime.tryParse(map['updated_at'].toString()) ?? DateTime.now())
        : DateTime.now(),
      imageUrls: List<String>.from(map['image_urls'] ?? []),
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
    );
  }

  // Convertir a un mapa (por ejemplo, para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'description': description,
      'pet_type': petType,
      'breed': breed,
      'color': color,
      'size': size,
      'gender': gender,
      'age': age,
      'is_vaccinated': isVaccinated,
      'is_sterilized': isSterilized,
      'is_dewormed': isDewormed,
      'special_needs': specialNeeds,
      'special_needs_description': specialNeedsDescription,
      'status': status,
      'location': location,
      'contact_phone': contactPhone,
      'requirements': requirements,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image_urls': imageUrls,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Crear una copia con algunos campos actualizados
  AdoptionModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? petType,
    String? breed,
    String? color,
    String? size,
    String? gender,
    String? age,
    bool? isVaccinated,
    bool? isSterilized,
    bool? isDewormed,
    bool? specialNeeds,
    String? specialNeedsDescription,
    String? status,
    String? location,
    String? contactPhone,
    String? requirements,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
    double? latitude,
    double? longitude,
  }) {
    return AdoptionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      petType: petType ?? this.petType,
      breed: breed ?? this.breed,
      color: color ?? this.color,
      size: size ?? this.size,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      isVaccinated: isVaccinated ?? this.isVaccinated,
      isSterilized: isSterilized ?? this.isSterilized,
      isDewormed: isDewormed ?? this.isDewormed,
      specialNeeds: specialNeeds ?? this.specialNeeds,
      specialNeedsDescription: specialNeedsDescription ?? this.specialNeedsDescription,
      status: status ?? this.status,
      location: location ?? this.location,
      contactPhone: contactPhone ?? this.contactPhone,
      requirements: requirements ?? this.requirements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      imageUrls: imageUrls ?? this.imageUrls,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
