import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/models/report_model.dart';
import '../data/services/report_service.dart';
import '../data/services/storage_service.dart';

enum ReportStatus { initial, loading, loaded, error }

class ReportProvider with ChangeNotifier {
  final ReportService _reportService = ReportService();
  final StorageService _storageService = StorageService();
  
  ReportStatus _status = ReportStatus.initial;
  List<ReportModel> _reports = [];
  ReportModel? _selectedReport;
  String _errorMessage = '';
  
  // Getters
  ReportStatus get status => _status;
  List<ReportModel> get reports => _reports;
  ReportModel? get selectedReport => _selectedReport;
  String get errorMessage => _errorMessage;
  
  // Filtrar reportes por tipo
  List<ReportModel> getReportsByType(String type) {
    return _reports.where((report) => report.reportType == type).toList();
  }
  
  // Cargar todos los reportes
  Future<void> loadReports({String? filterType}) async {
    _status = ReportStatus.loading;
    notifyListeners();
    
    try {
      _reports = await _reportService.getReports(filterType: filterType);
      _status = ReportStatus.loaded;
    } catch (e) {
      _status = ReportStatus.error;
      _errorMessage = 'Error al cargar reportes: $e';
      print(_errorMessage);
    }
    
    notifyListeners();
  }
  
  // Cargar un reporte específico por ID
  Future<void> loadReportById(String reportId) async {
    _status = ReportStatus.loading;
    notifyListeners();
    
    try {
      _selectedReport = await _reportService.getReportById(reportId);
      _status = ReportStatus.loaded;
    } catch (e) {
      _status = ReportStatus.error;
      _errorMessage = 'Error al cargar reporte: $e';
      print(_errorMessage);
    }
    
    notifyListeners();
  }
  
  // Crear un nuevo reporte
  Future<bool> createReport(ReportModel report, List<File> images) async {
    _status = ReportStatus.loading;
    notifyListeners();
    
    try {
      final reportId = await _reportService.createReport(report, images);
      
      if (reportId != null) {
        await loadReports(); // Recargar la lista de reportes
        return true;
      } else {
        _status = ReportStatus.error;
        _errorMessage = 'Error al crear reporte';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ReportStatus.error;
      _errorMessage = 'Error al crear reporte: $e';
      print(_errorMessage);
      notifyListeners();
      return false;
    }
  }
  
  // Actualizar un reporte existente
  Future<bool> updateReport(String reportId, ReportModel updatedReport) async {
    _status = ReportStatus.loading;
    notifyListeners();
    
    try {
      final success = await _reportService.updateReport(reportId, updatedReport);
      
      if (success) {
        // Actualizar el reporte en la lista local
        final index = _reports.indexWhere((report) => report.id == reportId);
        if (index != -1) {
          _reports[index] = updatedReport;
        }
        
        // Si es el reporte seleccionado, actualizarlo también
        if (_selectedReport?.id == reportId) {
          _selectedReport = updatedReport;
        }
        
        _status = ReportStatus.loaded;
        notifyListeners();
        return true;
      } else {
        _status = ReportStatus.error;
        _errorMessage = 'Error al actualizar reporte';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = ReportStatus.error;
      _errorMessage = 'Error al actualizar reporte: $e';
      print(_errorMessage);
      notifyListeners();
      return false;
    }
  }
  
  // Marcar un reporte como resuelto
  Future<bool> markReportAsResolved(String reportId) async {
    try {
      final success = await _reportService.markReportAsResolved(reportId);
      
      if (success) {
        // Actualizar el estado en la lista local
        final index = _reports.indexWhere((report) => report.id == reportId);
        if (index != -1) {
          final updatedReport = _reports[index].copyWith(
            status: 'resuelto',
            updatedAt: DateTime.now(),
          );
          _reports[index] = updatedReport;
          
          // Si es el reporte seleccionado, actualizarlo también
          if (_selectedReport?.id == reportId) {
            _selectedReport = updatedReport;
          }
        }
        
        notifyListeners();
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
    try {
      final success = await _reportService.deleteReport(reportId);
      
      if (success) {
        // Eliminar el reporte de la lista local
        _reports.removeWhere((report) => report.id == reportId);
        
        // Si es el reporte seleccionado, limpiarlo
        if (_selectedReport?.id == reportId) {
          _selectedReport = null;
        }
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error al eliminar reporte: $e');
      return false;
    }
  }
  
  // Cargar reportes del usuario actual
  Future<void> loadUserReports(String userId) async {
    _status = ReportStatus.loading;
    notifyListeners();
    
    try {
      _reports = await _reportService.getUserReports(userId);
      _status = ReportStatus.loaded;
    } catch (e) {
      _status = ReportStatus.error;
      _errorMessage = 'Error al cargar reportes del usuario: $e';
      print(_errorMessage);
    }
    
    notifyListeners();
  }
  
  // Limpiar el reporte seleccionado
  void clearSelectedReport() {
    _selectedReport = null;
    notifyListeners();
  }
  
  // Resetear el estado
  void resetState() {
    _status = ReportStatus.initial;
    _reports = [];
    _selectedReport = null;
    _errorMessage = '';
    notifyListeners();
  }
}
