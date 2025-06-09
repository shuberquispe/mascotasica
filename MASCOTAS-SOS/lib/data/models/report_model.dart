// Modelo de reporte sin dependencias de Firebase

class ReportModel {
  final String id;
  final String userId;
  final String reportType; // "perdido" o "encontrado"
  final String title;
  final String description;
  final String petType;
  final String breed;
  final String color;
  final String size;
  final String gender;
  final String location;
  final String contactPhone;
  final DateTime reportDate;
  final String status; // "activo" o "resuelto"
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> imageUrls;
  final double latitude;
  final double longitude;

  ReportModel({
    required this.id,
    required this.userId,
    required this.reportType,
    required this.title,
    required this.description,
    required this.petType,
    required this.breed,
    required this.color,
    required this.size,
    required this.gender,
    required this.location,
    required this.contactPhone,
    required this.reportDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrls,
    required this.latitude,
    required this.longitude,
  });

  // Crear desde un mapa (por ejemplo, desde Firestore)
  factory ReportModel.fromMap(Map<String, dynamic> map, String id) {
    return ReportModel(
      id: id,
      userId: map['user_id'] ?? '',
      reportType: map['report_type'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      petType: map['pet_type'] ?? '',
      breed: map['breed'] ?? '',
      color: map['color'] ?? '',
      size: map['size'] ?? '',
      gender: map['gender'] ?? '',
      location: map['location'] ?? '',
      contactPhone: map['contact_phone'] ?? '',
      reportDate: map['report_date'] != null 
        ? (map['report_date'] is DateTime 
            ? map['report_date'] 
            : DateTime.tryParse(map['report_date'].toString()) ?? DateTime.now())
        : DateTime.now(),
      status: map['status'] ?? 'activo',
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
      'report_type': reportType,
      'title': title,
      'description': description,
      'pet_type': petType,
      'breed': breed,
      'color': color,
      'size': size,
      'gender': gender,
      'location': location,
      'contact_phone': contactPhone,
      'report_date': reportDate,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image_urls': imageUrls,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Crear una copia con algunos campos actualizados
  ReportModel copyWith({
    String? userId,
    String? reportType,
    String? title,
    String? description,
    String? petType,
    String? breed,
    String? color,
    String? size,
    String? gender,
    String? location,
    String? contactPhone,
    DateTime? reportDate,
    String? status,
    DateTime? updatedAt,
    List<String>? imageUrls,
    double? latitude,
    double? longitude,
  }) {
    return ReportModel(
      id: id,
      userId: userId ?? this.userId,
      reportType: reportType ?? this.reportType,
      title: title ?? this.title,
      description: description ?? this.description,
      petType: petType ?? this.petType,
      breed: breed ?? this.breed,
      color: color ?? this.color,
      size: size ?? this.size,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      contactPhone: contactPhone ?? this.contactPhone,
      reportDate: reportDate ?? this.reportDate,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      imageUrls: imageUrls ?? this.imageUrls,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
