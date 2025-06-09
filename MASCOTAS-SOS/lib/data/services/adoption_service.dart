import 'dart:io';
import '../models/adoption_model.dart';
import '../models/adoption_request_model.dart';
import 'mock_services.dart';

class AdoptionService {
  // Servicio mock para desarrollo
  final MockFirebaseService _mockService = MockFirebaseService();
  
  AdoptionService() {
    // Constructor simplificado
  }

  // Obtener todas las adopciones
  Future<List<AdoptionModel>> getAdoptions({String? status}) async {
    try {
      final adoptions = await _mockService.getAdoptions();
      if (status != null) {
        return adoptions.where((adoption) => adoption.status == status).toList();
      }
      return adoptions;
    } catch (e) {
      print('Error al obtener adopciones: $e');
      return [];
    }
  }

  // Obtener una adopción por ID
  Future<AdoptionModel?> getAdoptionById(String adoptionId) async {
    try {
      return await _mockService.getAdoptionById(adoptionId);
    } catch (e) {
      print('Error al obtener adopción: $e');
      return null;
    }
  }

  // Crear una nueva publicación de adopción
  Future<String?> createAdoption(AdoptionModel adoption, List<File> images) async {
    try {
      // En modo mock, usamos un ID de usuario ficticio
      final mockUserId = 'mock_user_${DateTime.now().millisecondsSinceEpoch}';
      
      // Subir imágenes al servicio mock
      List<String> imageUrls = [];
      if (images.isNotEmpty) {
        imageUrls = await _mockService.uploadImages(images);
      }
      
      // Crear la adopción con las URLs de las imágenes
      final adoptionWithImages = adoption.copyWith(
        userId: mockUserId,
        imageUrls: imageUrls,
        updatedAt: DateTime.now(),
        status: 'disponible',
      );
      
      // Usar el servicio mock para crear la adopción
      return await _mockService.createAdoption(adoptionWithImages);
    } catch (e) {
      print('Error al crear adopción: $e');
      return null;
    }
  }

  // Actualizar una publicación de adopción
  Future<bool> updateAdoption(String adoptionId, AdoptionModel adoption) async {
    try {
      return await _mockService.updateAdoption(adoption);
    } catch (e) {
      print('Error al actualizar adopción: $e');
      return false;
    }
  }

  // Marcar una adopción como completada
  Future<bool> markAdoptionAsCompleted(String adoptionId) async {
    try {
      return await _mockService.updateAdoptionStatus(
        adoptionId: adoptionId,
        status: 'adoptado',
      );
    } catch (e) {
      print('Error al marcar adopción como completada: $e');
      return false;
    }
  }

  // Eliminar una publicación de adopción
  Future<bool> deleteAdoption(String adoptionId) async {
    try {
      return await _mockService.deleteAdoption(adoptionId);
    } catch (e) {
      print('Error al eliminar adopción: $e');
      return false;
    }
  }

  // Obtener adopciones de un usuario
  Future<List<AdoptionModel>> getUserAdoptions(String userId) async {
    try {
      final adoptions = await _mockService.getAdoptions();
      return adoptions.where((adoption) => adoption.userId == userId).toList();
    } catch (e) {
      print('Error al obtener adopciones del usuario: $e');
      return [];
    }
  }

  // Solicitar una adopción
  Future<bool> requestAdoption(String adoptionId, Map<String, dynamic> requestData) async {
    try {
      // Crear el objeto de solicitud
      final request = AdoptionRequestModel(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}', // ID temporal
        adoptionId: adoptionId,
        userId: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        userName: requestData['user_name'] ?? 'Usuario Mock',
        userPhone: requestData['user_phone'] ?? '999999999',
        message: requestData['message'] ?? '',
        status: 'pendiente',
        responseMessage: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Crear la solicitud en el servicio mock
      final requestId = await _mockService.createAdoptionRequest(request);
      return requestId.isNotEmpty;
    } catch (e) {
      print('Error al solicitar adopción: $e');
      return false;
    }
  }

  // Obtener solicitudes de adopción para una publicación
  Future<List<Map<String, dynamic>>> getAdoptionRequests(String adoptionId) async {
    try {
      // Convertir los objetos AdoptionRequestModel a Map<String, dynamic>
      final requests = await _mockService.getAdoptionRequests(adoptionId);
      return requests.map((request) => {
        'id': request.id,
        'adoption_id': request.adoptionId,
        'user_id': request.userId,
        'user_name': request.userName,
        'user_phone': request.userPhone,
        'message': request.message,
        'status': request.status,
        'response_message': request.responseMessage,
        'created_at': request.createdAt,
        'updated_at': request.updatedAt,
      }).toList();
    } catch (e) {
      print('Error al obtener solicitudes de adopción: $e');
      return [];
    }
  }
  
  // Actualizar el estado de una solicitud de adopción
  Future<bool> updateAdoptionRequestStatus({
    required String requestId,
    required String status,
    String? responseMessage,
  }) async {
    try {
      return await _mockService.updateAdoptionRequestStatus(
        requestId: requestId,
        status: status,
        responseMessage: responseMessage,
      );
    } catch (e) {
      print('Error al actualizar estado de solicitud: $e');
      return false;
    }
  }
  
  // Actualizar el estado de una adopción
  Future<bool> updateAdoptionStatus({
    required String adoptionId,
    required String status,
  }) async {
    try {
      return await _mockService.updateAdoptionStatus(
        adoptionId: adoptionId,
        status: status,
      );
    } catch (e) {
      print('Error al actualizar estado de adopción: $e');
      return false;
    }
  }
}
