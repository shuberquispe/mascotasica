import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/models/report_model.dart';
import '../../../providers/report_provider.dart';

class ReportDetailScreen extends StatefulWidget {
  final String reportId;

  const ReportDetailScreen({
    Key? key,
    required this.reportId,
  }) : super(key: key);

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  bool _isLoading = true;
  ReportModel? _report;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Cargar el reporte usando el provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReportData();
    });
  }

  Future<void> _loadReportData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Usar el provider para cargar el reporte
      final reportProvider = Provider.of<ReportProvider>(context, listen: false);
      await reportProvider.loadReportById(widget.reportId);
      
      if (mounted) {
        setState(() {
          _report = reportProvider.selectedReport;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar el reporte: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentImageIndex = index;
    });
  }

  void _contactOwner() async {
    if (_report?.contactPhone == null || _report!.contactPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay número de contacto disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contactar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Datos de contacto:'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 8),
                Text('+51 ${_report?.contactPhone ?? ""}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          TextButton(
            onPressed: () async {
              final phoneNumber = _report!.contactPhone;
              final url = 'tel:+51$phoneNumber';
              final Uri uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No se puede realizar la llamada'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Llamar'),
          ),
        ],
      ),
    );
  }

  void _shareReport() async {
    if (_report == null) return;
    
    final String shareText = '''
🐾 MASCOTA ${_report!.reportType.toUpperCase()} 🐾

${_report!.title}

${_report!.description}

Características:
- Tipo: ${_report!.petType}
- Raza: ${_report!.breed}
- Color: ${_report!.color}
- Tamaño: ${_report!.size}
- Género: ${_report!.gender}

Ubicación: ${_report!.location}

Contacto: +51 ${_report!.contactPhone}

Compartido desde la app MascotaSOS Ica
''';

    await Share.share(shareText, subject: _report!.title);
  }

  void _reportAsFound() async {
    if (_report == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Marcar como resuelto'),
        content: const Text(
          '¿Estás seguro de que quieres marcar este reporte como resuelto? '
          'Esto indicará que la mascota ha sido encontrada o devuelta a su dueño.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                final reportProvider = Provider.of<ReportProvider>(context, listen: false);
                final success = await reportProvider.markReportAsResolved(widget.reportId);
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Reporte marcado como resuelto!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  // Recargar el reporte
                  await _loadReportData();
                } else if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al marcar como resuelto'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determinar color según el tipo de reporte
    final Color typeColor = _report?.reportType == 'perdido' ? Colors.red : Colors.green;
    final String typeText = _report?.reportType == 'perdido' ? 'Perdido' : 'Encontrado';
    
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // App Bar con imágenes
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: _report?.imageUrls.isNotEmpty == true
                        ? Stack(
                            children: [
                              // Carrusel de imágenes
                              PageView.builder(
                                controller: _pageController,
                                itemCount: _report!.imageUrls.length,
                                onPageChanged: _onPageChanged,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    _report!.imageUrls[index],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              
                              // Indicadores de página
                              if (_report!.imageUrls.length > 1)
                                Positioned(
                                  bottom: 16,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      _report!.imageUrls.length,
                                      (index) => Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentImageIndex == index
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              
                              // Etiqueta de tipo (perdido/encontrado)
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: typeColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    typeText.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Etiqueta de estado (activo/resuelto)
                              if (_report?.status == 'resuelto')
                                Positioned(
                                  top: 16,
                                  left: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      'RESUELTO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.photo_library,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: _shareReport,
                    ),
                  ],
                ),
                
                // Contenido
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título y fecha
                        Text(
                          _report?.title ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Reportado el ${_report != null ? DateFormat('dd/MM/yyyy').format(_report!.createdAt) : ""}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Acciones rápidas
                        if (_report?.status != 'resuelto')
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildActionButton(
                                    icon: Icons.phone,
                                    label: 'Contactar',
                                    onTap: _contactOwner,
                                  ),
                                  _buildActionButton(
                                    icon: Icons.check_circle,
                                    label: 'Resuelto',
                                    onTap: _reportAsFound,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 24),
                        
                        // Descripción
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_report?.description ?? ''),
                        const SizedBox(height: 24),
                        
                        // Características
                        const Text(
                          'Características',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildCharacteristicRow('Tipo', _report?.petType ?? ''),
                        _buildCharacteristicRow('Raza', _report?.breed ?? ''),
                        _buildCharacteristicRow('Color', _report?.color ?? ''),
                        _buildCharacteristicRow('Tamaño', _report?.size ?? ''),
                        _buildCharacteristicRow('Género', _report?.gender ?? ''),
                        const SizedBox(height: 24),
                        
                        // Mapa con ubicación real
                        const Text(
                          'Ubicación',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: _report?.latitude != null && _report?.longitude != null
                              ? GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(_report!.latitude, _report!.longitude),
                                    zoom: 15,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId(widget.reportId),
                                      position: LatLng(_report!.latitude, _report!.longitude),
                                      infoWindow: InfoWindow(
                                        title: _report!.title,
                                        snippet: _report!.location,
                                      ),
                                    ),
                                  },
                                  zoomControlsEnabled: false,
                                  mapToolbarEnabled: false,
                                  myLocationButtonEnabled: false,
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text('Ubicación no disponible'),
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Información de contacto
                        const Text(
                          'Información de contacto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(width: 8),
                            Text('+51 ${_report?.contactPhone ?? ""}'),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacteristicRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
