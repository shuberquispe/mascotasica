import 'dart:async';
import 'dart:io';
import 'dart:math';
import '../models/adoption_model.dart';
import '../models/adoption_request_model.dart';
import '../../config/constants.dart';

/// Clase para simular el servicio de Firebase durante el desarrollo
class MockFirebaseService {
  static final MockFirebaseService _instance = MockFirebaseService._internal();
  
  factory MockFirebaseService() {
    return _instance;
  }
  
  MockFirebaseService._internal();
  
  // Datos mock para adopciones
  final List<AdoptionModel> _adoptions = [
    AdoptionModel(
      id: '1',
      userId: 'user1',
      name: 'Luna',
      description: 'Perrita muy cariñosa y juguetona. Le encanta correr y jugar con pelotas.',
      petType: 'Perro',
      breed: 'Mestizo',
      color: 'Blanco y negro',
      size: 'Mediano',
      gender: 'Hembra',
      age: '2 años',
      isVaccinated: true,
      isSterilized: true,
      isDewormed: true,
      specialNeeds: false,
      specialNeedsDescription: '',
      location: 'Ica, Perú',
      contactPhone: '987654321',
      requirements: 'Hogar con espacio para que pueda jugar',
      imageUrls: ['https://images.unsplash.com/photo-1543466835-00a7907e9de1'],
      latitude: -14.0678,
      longitude: -75.7286,
      status: AppConstants.adoptionStatusAvailable,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    AdoptionModel(
      id: '2',
      userId: 'user2',
      name: 'Simba',
      description: 'Gatito juguetón y muy sociable. Se lleva bien con otros animales.',
      petType: 'Gato',
      breed: 'Atigrado',
      color: 'Naranja',
      size: 'Pequeño',
      gender: 'Macho',
      age: '8 meses',
      isVaccinated: true,
      isSterilized: false,
      isDewormed: true,
      specialNeeds: false,
      specialNeedsDescription: '',
      location: 'Ica, Perú',
      contactPhone: '987123456',
      requirements: 'Familia que le dé mucho cariño',
      imageUrls: ['https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba'],
      latitude: -14.0800,
      longitude: -75.7350,
      status: AppConstants.adoptionStatusAvailable,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];
  
  // Datos mock para solicitudes de adopción
  final List<AdoptionRequestModel> _adoptionRequests = [
    AdoptionRequestModel(
      id: '1',
      adoptionId: '1',
      userId: 'user3',
      userName: 'María López',
      userPhone: '987111222',
      message: 'Me encantaría adoptar a Luna, tengo un jardín grande donde podría jugar.',
      status: AppConstants.requestStatusPending,
      responseMessage: '',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
  
  // Métodos para adopciones
  Future<List<AdoptionModel>> getAdoptions() async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));
    return _adoptions;
  }
  
  Future<AdoptionModel?> getAdoptionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _adoptions.firstWhere((adoption) => adoption.id == id, orElse: () => throw Exception('Adopción no encontrada'));
  }
  
  Future<String> createAdoption(AdoptionModel adoption) async {
    await Future.delayed(const Duration(seconds: 1));
    final newId = 'adoption_${DateTime.now().millisecondsSinceEpoch}';
    final newAdoption = adoption.copyWith(
      id: newId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: AppConstants.adoptionStatusAvailable,
    );
    _adoptions.add(newAdoption);
    return newId;
  }
  
  Future<bool> updateAdoption(AdoptionModel adoption) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _adoptions.indexWhere((a) => a.id == adoption.id);
    if (index != -1) {
      _adoptions[index] = adoption.copyWith(updatedAt: DateTime.now());
      return true;
    }
    return false;
  }
  
  Future<bool> deleteAdoption(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final initialLength = _adoptions.length;
    _adoptions.removeWhere((adoption) => adoption.id == id);
    return _adoptions.length < initialLength;
  }
  
  Future<bool> updateAdoptionStatus({required String adoptionId, required String status}) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _adoptions.indexWhere((a) => a.id == adoptionId);
    if (index != -1) {
      _adoptions[index] = _adoptions[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }
  
  // Métodos para solicitudes de adopción
  Future<List<AdoptionRequestModel>> getAdoptionRequests(String adoptionId) async {
    await Future.delayed(const Duration(seconds: 1));
    return _adoptionRequests.where((request) => request.adoptionId == adoptionId).toList();
  }
  
  Future<String> createAdoptionRequest(AdoptionRequestModel request) async {
    await Future.delayed(const Duration(seconds: 1));
    final newId = 'request_${DateTime.now().millisecondsSinceEpoch}';
    final newRequest = request.copyWith(
      id: newId,
      status: AppConstants.requestStatusPending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _adoptionRequests.add(newRequest);
    return newId;
  }
  
  Future<bool> updateAdoptionRequestStatus({
    required String requestId,
    required String status,
    String? responseMessage,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _adoptionRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _adoptionRequests[index] = _adoptionRequests[index].copyWith(
        status: status,
        responseMessage: responseMessage,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }
  
  // Métodos para almacenamiento de imágenes
  Future<List<String>> uploadImages(List<File> images) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simular URLs de imágenes subidas
    final random = Random();
    return images.map((_) {
      final randomId = random.nextInt(1000);
      return 'https://picsum.photos/id/$randomId/500/500';
    }).toList();
  }
}
