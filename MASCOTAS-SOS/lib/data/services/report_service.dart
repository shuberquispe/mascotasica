import 'dart:io';
import 'dart:math';
import '../models/report_model.dart';

class ReportService {
  final Random _random = Random();
  
  // Lista de reportes mock
  final List<ReportModel> _mockReports = [
    ReportModel(
      id: '1',
      userId: 'user1',
      title: 'Perro perdido en Ica centro',
      description: 'Se perdió un perro labrador color dorado, responde al nombre de Max.',
      reportType: 'perdido',
      petType: 'Perro',
      breed: 'Labrador',
      color: 'Dorado',
      size: 'Grande',
      gender: 'Macho',
      location: 'Ica, centro',
      contactPhone: '987654321',
      reportDate: DateTime.now().subtract(const Duration(days: 2)),
      imageUrls: ['https://images.unsplash.com/photo-1552053831-71594a27632d'],
      latitude: -14.0678,
      longitude: -75.7286,
      status: 'activo',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ReportModel(
      id: '2',
      userId: 'user2',
      title: 'Gato encontrado en parque',
      description: 'Encontré un gato blanco con manchas negras en el parque municipal.',
      reportType: 'encontrado',
      petType: 'Gato',
      breed: 'Mestizo',
      color: 'Blanco y negro',
      size: 'Pequeño',
      gender: 'Hembra',
      location: 'Ica, Parque Municipal',
      contactPhone: '987123456',
      reportDate: DateTime.now().subtract(const Duration(days: 5)),
      imageUrls: ['https://images.unsplash.com/photo-1529778873920-4da4926a72c2'],
      latitude: -14.0800,
      longitude: -75.7350,
      status: 'activo',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Obtener todos los reportes
  Future<List<ReportModel>> getReports({String? filterType}) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));
    
    if (filterType != null) {
      return _mockReports
          .where((report) => report.reportType == filterType)
          .toList();
    }
    return _mockReports;
  }

  // Obtener un reporte por ID
  Future<ReportModel?> getReportById(String reportId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      return _mockReports.firstWhere((report) => report.id == reportId);
    } catch (e) {
      print('Reporte no encontrado: $e');
      return null;
    }
  }

  // Crear un nuevo reporte
  Future<String?> createReport(ReportModel report, List<File> images) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Generar ID único
      final newId = 'report_${DateTime.now().millisecondsSinceEpoch}';
      
      // Generar URLs mock para las imágenes
      List<String> imageUrls = [];
      for (var _ in images) {
        final randomId = _random.nextInt(1000);
        imageUrls.add('https://picsum.photos/id/$randomId/500/500');
      }
      
      // Crear el reporte con las URLs de las imágenes
      final newReport = ReportModel(
        id: newId,
        userId: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
        title: report.title,
        description: report.description,
        reportType: report.reportType,
        petType: report.petType,
        breed: report.breed,
        color: report.color,
        size: report.size,
        gender: report.gender,
        location: report.location,
        contactPhone: report.contactPhone,
        reportDate: report.reportDate,
        imageUrls: imageUrls,
        latitude: report.latitude,
        longitude: report.longitude,
        status: 'activo',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Agregar a la lista mock
      _mockReports.add(newReport);
      return newId;
    } catch (e) {
      print('Error al crear reporte: $e');
      return null;
    }
  }

  // Actualizar un reporte
  Future<bool> updateReport(String reportId, ReportModel report) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final index = _mockReports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        _mockReports[index] = report.copyWith(
          updatedAt: DateTime.now(),
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error al actualizar reporte: $e');
      return false;
    }
  }

  // Marcar un reporte como resuelto
  Future<bool> markReportAsResolved(String reportId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final index = _mockReports.indexWhere((r) => r.id == reportId);
      if (index != -1) {
        _mockReports[index] = _mockReports[index].copyWith(
          status: 'resuelto',
          updatedAt: DateTime.now(),
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error al marcar reporte como resuelto: $e');
      return false;
    }
  }

  // Eliminar un reporte
  Future<bool> deleteReport(String reportId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      final initialLength = _mockReports.length;
      _mockReports.removeWhere((report) => report.id == reportId);
      return _mockReports.length < initialLength;
    } catch (e) {
      print('Error al eliminar reporte: $e');
      return false;
    }
  }

  // Obtener reportes por usuario
  Future<List<ReportModel>> getUserReports(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return _mockReports
        .where((report) => report.userId == userId)
        .toList();
  }
}
