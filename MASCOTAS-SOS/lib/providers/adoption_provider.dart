import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/models/adoption_model.dart';
import '../data/models/adoption_request_model.dart';
import '../data/services/adoption_service.dart';

/// Enum que representa los diferentes estados de carga de adopciones
enum AdoptionStatus {
  initial,
  loading,
  loaded,
  error
}

class AdoptionProvider with ChangeNotifier {
  /// Servicio para manejar las operaciones de adopción
  final AdoptionService _adoptionService = AdoptionService();
  
  /// Estado actual de carga
  AdoptionStatus _status = AdoptionStatus.initial;
  
  /// Lista de adopciones
  List<AdoptionModel> _adoptions = [];
  
  /// Adopción seleccionada actualmente
  AdoptionModel? _selectedAdoption;
  
  /// Mensaje de error en caso de fallo
  String _errorMessage = '';
  
  /// Estado actual de carga
  AdoptionStatus get status => _status;
  
  /// Lista de adopciones disponibles
  List<AdoptionModel> get adoptions => List.unmodifiable(_adoptions);
  
  /// Adopción seleccionada actualmente
  AdoptionModel? get selectedAdoption => _selectedAdoption;
  
  /// Mensaje de error en caso de fallo
  String get errorMessage => _errorMessage;
  
  // Filtrar adopciones por estado
  List<AdoptionModel> getAdoptionsByStatus(String status) {
    return _adoptions.where((adoption) => adoption.status == status).toList();
  }
  
  // Cargar todas las adopciones
  Future<void> loadAdoptions({String? status}) async {
    _status = AdoptionStatus.loading;
    notifyListeners();
    
    try {
      _adoptions = await _adoptionService.getAdoptions(status: status);
      _status = AdoptionStatus.loaded;
    } catch (e) {
      _status = AdoptionStatus.error;
      _errorMessage = 'Error al cargar adopciones: $e';
      print(_errorMessage);
    }
    
    notifyListeners();
  }
  
  // Obtener todas las adopciones sin cambiar el estado
  Future<List<AdoptionModel>> getAdoptions({String? status}) async {
    try {
      return await _adoptionService.getAdoptions(status: status);
    } catch (e) {
      print('Error al obtener adopciones: $e');
      return [];
    }
  }
  
  // Cargar una adopción específica por ID
  Future<void> loadAdoptionById(String adoptionId) async {
    _status = AdoptionStatus.loading;
    notifyListeners();
    
    try {
      _selectedAdoption = await _adoptionService.getAdoptionById(adoptionId);
      _status = AdoptionStatus.loaded;
    } catch (e) {
      _status = AdoptionStatus.error;
      _errorMessage = 'Error al cargar adopción: $e';
      print(_errorMessage);
    }
    
    notifyListeners();
  }
  
  // Obtener una adopción por ID sin cambiar el estado
  Future<AdoptionModel?> getAdoptionById(String adoptionId) async {
    try {
      return await _adoptionService.getAdoptionById(adoptionId);
    } catch (e) {
      print('Error al obtener adopción: $e');
      return null;
    }
  }
  
  // Crear una nueva adopción
  Future<bool> createAdoption(AdoptionModel adoption, List<File> images) async {
    _status = AdoptionStatus.loading;
    notifyListeners();
    
    try {
      final adoptionId = await _adoptionService.createAdoption(adoption, images);
      
      if (adoptionId != null) {
        await loadAdoptions(); // Recargar la lista de adopciones
        return true;
      } else {
        _status = AdoptionStatus.error;
        _errorMessage = 'Error al crear adopción';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AdoptionStatus.error;
      _errorMessage = 'Error al crear adopción: $e';
      print(_errorMessage);
      notifyListeners();
      return false;
    }
  }
  
  // Actualizar una adopción existente
  Future<bool> updateAdoption(String adoptionId, AdoptionModel updatedAdoption) async {
    _status = AdoptionStatus.loading;
    notifyListeners();
    
    try {
      final success = await _adoptionService.updateAdoption(adoptionId, updatedAdoption);
      
      if (success) {
        // Actualizar la adopción en la lista local
        final index = _adoptions.indexWhere((adoption) => adoption.id == adoptionId);
        if (index != -1) {
          _adoptions[index] = updatedAdoption;
        }
        
        // Si es la adopción seleccionada, actualizarla también
        if (_selectedAdoption?.id == adoptionId) {
          _selectedAdoption = updatedAdoption;
        }
        
        _status = AdoptionStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = AdoptionStatus.error;
        _errorMessage = 'Error al actualizar adopción';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AdoptionStatus.error;
      _errorMessage = 'Error al actualizar adopción: $e';
      print(_errorMessage);
      notifyListeners();
      return false;
    }
  }
  
  // Marcar una adopción como completada
  Future<bool> markAdoptionAsCompleted(String adoptionId) async {
    try {
      final success = await _adoptionService.markAdoptionAsCompleted(adoptionId);
      
      if (success) {
        // Actualizar el estado en la lista local
        final index = _adoptions.indexWhere((adoption) => adoption.id == adoptionId);
        if (index != -1) {
          final updatedAdoption = _adoptions[index].copyWith(
            status: 'adoptado',
            updatedAt: DateTime.now(),
          );
          _adoptions[index] = updatedAdoption;
          
          // Si es la adopción seleccionada, actualizarla también
          if (_selectedAdoption?.id == adoptionId) {
            _selectedAdoption = updatedAdoption;
          }
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _status = AdoptionStatus.error;
      _errorMessage = 'Error al marcar adopción como completada: $e';
      print(_errorMessage);
      notifyListeners();
      return false;
    }
  }
  
  // Eliminar una adopción
  Future<bool> deleteAdoption(String adoptionId) async {
    try {
      final success = await _adoptionService.deleteAdoption(adoptionId);
      
      if (success) {
        // Eliminar la adopción de la lista local
        _adoptions.removeWhere((adoption) => adoption.id == adoptionId);
        
        // Si es la adopción seleccionada, limpiarla
        if (_selectedAdoption?.id == adoptionId) {
          _selectedAdoption = null;
        }
        
        _status = AdoptionStatus.loaded;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _status = AdoptionStatus.error;
      _errorMessage = 'Error al eliminar adopción: $e';
      print(_errorMessage);
      notifyListeners();
      return false;
    }
  }
  
  // Cargar adopciones del usuario actual
  Future<void> loadUserAdoptions(String userId) async {
    _status = AdoptionStatus.loading;
    notifyListeners();
    
    try {
      _adoptions = await _adoptionService.getUserAdoptions(userId);
      _status = AdoptionStatus.loaded;
    } catch (e) {
      _status = AdoptionStatus.error;
      _errorMessage = 'Error al cargar adopciones del usuario: $e';
      print(_errorMessage);
    }
    
    notifyListeners();
  }
  
  // Solicitar una adopción
  Future<bool> requestAdoption(String adoptionId, Map<String, dynamic> requestData) async {
    try {
      final success = await _adoptionService.requestAdoption(adoptionId, requestData);
      
      if (success) {
        // Actualizar la adopción en la lista local si es necesario
        final index = _adoptions.indexWhere((adoption) => adoption.id == adoptionId);
        if (index != -1) {
          // Actualizar la adopción para marcar que tiene solicitudes
          final updatedAdoption = _adoptions[index].copyWith(
            status: _adoptions[index].status, // Mantener el mismo estado
          );
          _adoptions[index] = updatedAdoption;
          
          // Si es la adopción seleccionada, actualizarla también
          if (_selectedAdoption?.id == adoptionId) {
            _selectedAdoption = updatedAdoption;
          }
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al solicitar adopción: $e');
      return false;
    }
  }
  
  // Obtener solicitudes de adopción para una publicación
  Future<List<AdoptionRequestModel>> getAdoptionRequests(String adoptionId) async {
    try {
      final requestsData = await _adoptionService.getAdoptionRequests(adoptionId);
      return requestsData.map((data) {
        final id = data['id'] as String? ?? '';
        return AdoptionRequestModel.fromMap(data, id);
      }).toList();
    } catch (e) {
      print('Error al obtener solicitudes de adopción: $e');
      return [];
    }
  }
  
  // Limpiar la adopción seleccionada
  void clearSelectedAdoption() {
    _selectedAdoption = null;
    notifyListeners();
  }
  
  // Resetear el estado
  void resetState() {
    _status = AdoptionStatus.initial;
    _adoptions = [];
    _selectedAdoption = null;
    _errorMessage = '';
    notifyListeners();
  }
  
  // Actualizar el estado de una solicitud de adopción
  Future<bool> updateAdoptionRequestStatus({
    required String requestId,
    required String status,
    String? responseMessage,
  }) async {
    try {
      return await _adoptionService.updateAdoptionRequestStatus(
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
      final success = await _adoptionService.updateAdoptionStatus(
        adoptionId: adoptionId,
        status: status,
      );
      
      if (success) {
        // Actualizar el estado en la lista local
        final index = _adoptions.indexWhere((adoption) => adoption.id == adoptionId);
        if (index != -1) {
          final updatedAdoption = _adoptions[index].copyWith(
            status: status,
            updatedAt: DateTime.now(),
          );
          _adoptions[index] = updatedAdoption;
          
          // Si es la adopción seleccionada, actualizarla también
          if (_selectedAdoption?.id == adoptionId) {
            _selectedAdoption = updatedAdoption;
          }
        }
        
        _status = AdoptionStatus.loaded;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _status = AdoptionStatus.error;
      _errorMessage = 'Error al actualizar estado de adopción: $e';
      print(_errorMessage);
      notifyListeners();
      return false;
    }
  }
}
