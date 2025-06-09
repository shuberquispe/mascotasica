class UserModel {
  final String id;
  final String dni;
  final String email;
  final String name;
  final String? phone;
  final String? profilePic;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final Map<String, dynamic>? notificationPreferences;

  UserModel({
    required this.id,
    required this.dni,
    required this.email,
    required this.name,
    this.phone,
    this.profilePic,
    required this.createdAt,
    this.lastLogin,
    this.notificationPreferences,
  });

  // Crear desde un mapa (por ejemplo, desde Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      dni: map['dni'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
      profilePic: map['profile_pic'],
      createdAt: map['created_at'] != null 
        ? (map['created_at'] as Timestamp).toDate() 
        : DateTime.now(),
      lastLogin: map['last_login'] != null 
        ? (map['last_login'] as Timestamp).toDate() 
        : null,
      notificationPreferences: map['notification_preferences'],
    );
  }

  // Convertir a un mapa (por ejemplo, para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'dni': dni,
      'email': email,
      'name': name,
      'phone': phone,
      'profile_pic': profilePic,
      'created_at': createdAt,
      'last_login': lastLogin,
      'notification_preferences': notificationPreferences,
    };
  }

  // Crear una copia con algunos campos actualizados
  UserModel copyWith({
    String? dni,
    String? email,
    String? name,
    String? phone,
    String? profilePic,
    DateTime? lastLogin,
    Map<String, dynamic>? notificationPreferences,
  }) {
    return UserModel(
      id: id,
      dni: dni ?? this.dni,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profilePic: profilePic ?? this.profilePic,
      createdAt: createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      notificationPreferences: notificationPreferences ?? this.notificationPreferences,
    );
  }
}
