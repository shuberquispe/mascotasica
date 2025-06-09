// Modelo de solicitud de adopción sin dependencias de Firebase

class AdoptionRequestModel {
  final String id;
  final String adoptionId;
  final String userId;
  final String? userName; // Nombre del usuario que solicita
  final String? userPhone; // Teléfono del usuario que solicita
  final String message;
  final String status; // "pendiente", "aprobada", "rechazada"
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? responseMessage;

  AdoptionRequestModel({
    required this.id,
    required this.adoptionId,
    required this.userId,
    this.userName,
    this.userPhone,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.responseMessage,
  });

  // Crear desde un mapa (por ejemplo, desde Firestore)
  factory AdoptionRequestModel.fromMap(Map<String, dynamic> map, String id) {
    return AdoptionRequestModel(
      id: id,
      adoptionId: map['adoption_id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'],
      userPhone: map['user_phone'],
      message: map['message'] ?? '',
      status: map['status'] ?? 'pendiente',
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
      responseMessage: map['response_message'],
    );
  }

  // Convertir a un mapa (por ejemplo, para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'adoption_id': adoptionId,
      'user_id': userId,
      'user_name': userName,
      'user_phone': userPhone,
      'message': message,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'response_message': responseMessage,
    };
  }

  // Crear una copia con algunos campos actualizados
  AdoptionRequestModel copyWith({
    String? adoptionId,
    String? userId,
    String? userName,
    String? userPhone,
    String? message,
    String? status,
    DateTime? updatedAt,
    String? responseMessage,
    String? id,
    DateTime? createdAt,
  }) {
    return AdoptionRequestModel(
      id: id ?? this.id,
      adoptionId: adoptionId ?? this.adoptionId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      responseMessage: responseMessage ?? this.responseMessage,
    );
  }
}
