class Validators {
  // Validador de correo electrónico
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es obligatorio';
    }
    
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    
    return null;
  }
  
  // Validador de DNI peruano (8 dígitos)
  static String? validateDNI(String? value) {
    if (value == null || value.isEmpty) {
      return 'El DNI es obligatorio';
    }
    
    if (value.length != 8) {
      return 'El DNI debe tener 8 dígitos';
    }
    
    final dniRegExp = RegExp(r'^[0-9]{8}$');
    if (!dniRegExp.hasMatch(value)) {
      return 'Ingrese un DNI válido (solo números)';
    }
    
    return null;
  }
  
  // Validador de contraseña
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    
    return null;
  }
  
  // Validador de confirmación de contraseña
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirme su contraseña';
    }
    
    if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }
  
  // Validador de campo obligatorio
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName es obligatorio';
    }
    
    return null;
  }
  
  // Validador de número de teléfono peruano (9 dígitos)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // El teléfono puede ser opcional
    }
    
    final phoneRegExp = RegExp(r'^9[0-9]{8}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Ingrese un número de celular válido (9 dígitos)';
    }
    
    return null;
  }
}
