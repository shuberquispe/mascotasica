import 'dart:io';
import 'dart:math';

class StorageService {
  // Usamos solo Random para generar IDs aleatorios para URLs de imágenes mock
  final Random _random = Random();
  
  // Modo mock para desarrollo
  final bool _useMockService = true;

  // Subir una imagen
  Future<String?> uploadImage(File imageFile, String folder) async {
    try {
      if (_useMockService) {
        // Simular delay de red
        await Future.delayed(const Duration(seconds: 1));
        
        // En modo mock, no necesitamos generar nombres de archivo
        // Solo generamos URLs aleatorias para simular imágenes
        
        // Generar URL mock
        final randomId = _random.nextInt(1000);
        return 'https://picsum.photos/id/$randomId/500/500';
      }
      
      // Código para Firebase Storage (no se ejecutará en modo mock)
      throw UnimplementedError('Servicio de Firebase Storage no disponible en modo mock');
    } catch (e) {
      print('Error al subir imagen: $e');
      return null;
    }
  }

  // Subir múltiples imágenes
  Future<List<String>> uploadImages(List<File> imageFiles, String folder) async {
    List<String> imageUrls = [];
    
    try {
      if (_useMockService) {
        // Simular delay de red
        await Future.delayed(const Duration(seconds: 2));
        
        // Generar URLs mock para cada imagen
        for (var _ in imageFiles) {
          final randomId = _random.nextInt(1000);
          imageUrls.add('https://picsum.photos/id/$randomId/500/500');
        }
        return imageUrls;
      }
      
      // Código para Firebase Storage (no se ejecutará en modo mock)
      for (var imageFile in imageFiles) {
        final imageUrl = await uploadImage(imageFile, folder);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }
    } catch (e) {
      print('Error al subir múltiples imágenes: $e');
    }
    
    return imageUrls;
  }

  // Eliminar una imagen por URL
  Future<bool> deleteImage(String imageUrl) async {
    try {
      if (_useMockService) {
        // Simular delay de red
        await Future.delayed(const Duration(milliseconds: 800));
        return true;
      }
      
      // Código para Firebase Storage (no se ejecutará en modo mock)
      throw UnimplementedError('Servicio de Firebase Storage no disponible en modo mock');
    } catch (e) {
      print('Error al eliminar imagen: $e');
      return false;
    }
  }

  // Eliminar múltiples imágenes por URL
  Future<bool> deleteImages(List<String> imageUrls) async {
    try {
      if (_useMockService) {
        // Simular delay de red
        await Future.delayed(const Duration(seconds: 1));
        return true;
      }
      
      // Código para Firebase Storage (no se ejecutará en modo mock)
      bool allDeleted = true;
      for (var imageUrl in imageUrls) {
        final success = await deleteImage(imageUrl);
        if (!success) {
          allDeleted = false;
        }
      }
      return allDeleted;
    } catch (e) {
      print('Error al eliminar múltiples imágenes: $e');
      return false;
    }
  }
}
