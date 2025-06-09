class AppConstants {
  // Región de la aplicación
  static const String region = "Ica, Perú";
  
  // Configuración de la aplicación
  static const String appName = "MascotaSOS - Ica";
  static const String appVersion = "1.0.0";
  
  // URLs de API (se configurarán cuando se implemente Firebase)
  static const String apiBaseUrl = "";
  
  // Claves de almacenamiento
  static const String storageUserKey = "user_data";
  static const String storageAuthTokenKey = "auth_token";
  static const String storageOnboardingKey = "onboarding_completed";
  
  // Categorías de mascotas
  static const List<String> petTypes = ["Perro", "Gato", "Ave", "Otro"];
  
  // Tipos de reportes
  static const String reportTypeLost = "perdido";
  static const String reportTypeFound = "encontrado";
  
  // Estados de adopción
  static const String adoptionStatusAvailable = "disponible";
  static const String adoptionStatusInProcess = "en proceso";
  static const String adoptionStatusAdopted = "adoptado";
  
  // Estados de solicitud de adopción
  static const String requestStatusPending = "pendiente";
  static const String requestStatusApproved = "aprobada";
  static const String requestStatusRejected = "rechazada";
  
  // Tipos de servicios
  static const String serviceTypeVet = "veterinaria";
  static const String serviceTypeShelter = "refugio";
  static const String serviceTypePetShop = "tienda";
  
  // Tipos de eventos de cuidado
  static const String careTypeVaccine = "vacuna";
  static const String careTypeDeworming = "desparasitación";
  static const String careTypeBath = "baño";
  static const String careTypeCheckup = "control";
  
  // Categorías del foro
  static const List<String> forumCategories = [
    "Consejos",
    "Preguntas",
    "Historias",
    "Eventos",
    "Otros"
  ];
  
  // Categorías de guías
  static const List<String> guideCategories = [
    "Alimentación",
    "Salud",
    "Entrenamiento",
    "Primeros Auxilios",
    "Comportamiento"
  ];
  
  // Duración de animaciones
  static const int shortAnimationDuration = 200; // milisegundos
  static const int mediumAnimationDuration = 500; // milisegundos
  static const int longAnimationDuration = 800; // milisegundos
  
  // Configuración de caché
  static const int defaultCacheDuration = 7; // días
  
  // Configuración de paginación
  static const int defaultPageSize = 10;
}
