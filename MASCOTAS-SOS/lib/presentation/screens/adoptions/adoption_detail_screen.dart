import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../data/models/adoption_model.dart';
import '../../../providers/adoption_provider.dart';
import '../../../config/constants.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_message.dart';
import '../../widgets/common/image_gallery.dart';

class AdoptionDetailScreen extends StatefulWidget {
  final String adoptionId;

  const AdoptionDetailScreen({
    Key? key,
    required this.adoptionId,
  }) : super(key: key);

  @override
  _AdoptionDetailScreenState createState() => _AdoptionDetailScreenState();
}

class _AdoptionDetailScreenState extends State<AdoptionDetailScreen> {
  late final AdoptionProvider _adoptionProvider;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  AdoptionModel? _adoption;
  final Set<Marker> _markers = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _adoptionProvider = Provider.of<AdoptionProvider>(context, listen: false);
    _loadAdoptionDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadAdoptionDetails() async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
      }

      final adoption = await _adoptionProvider.getAdoptionById(widget.adoptionId);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          _adoption = adoption;
          
          if (adoption != null) {
            // Si hay coordenadas, crear un marcador en el mapa
            if (adoption.latitude != 0 && adoption.longitude != 0) {
              _markers.add(
                Marker(
                  markerId: const MarkerId('adoption_location'),
                  position: LatLng(adoption.latitude, adoption.longitude),
                  infoWindow: InfoWindow(
                    title: 'Ubicación de ${adoption.name}',
                    snippet: adoption.location,
                  ),
                ),
              );
            }
          } else {
            _hasError = true;
            _errorMessage = 'No se encontró la información de adopción';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'Error al cargar los detalles: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      final permission = await Permission.phone.request();
      
      if (permission.isGranted) {
        final Uri launchUri = Uri(
          scheme: 'tel',
          path: phoneNumber,
        );
        
        if (await canLaunchUrl(launchUri)) {
          await launchUrl(launchUri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo realizar la llamada')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, otorga permisos de llamada')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al realizar la llamada: $e')),
      );
    }
  }

  Future<void> _shareAdoption() async {
    if (_adoption == null) return;
    
    final String shareText = '''
¡Ayuda a encontrar un hogar para ${_adoption!.name}!

${_adoption!.description}

Tipo: ${_adoption!.petType}
Raza: ${_adoption!.breed}
Edad: ${_adoption!.age}
Ubicación: ${_adoption!.location}

Para más información, contacta al: ${_adoption!.contactPhone}
''';

    await Share.share(shareText, subject: 'Mascota en adopción: ${_adoption!.name}');
  }

  Future<void> _shareOnWhatsApp() async {
    if (_adoption == null) return;
    
    final String message = '''
¡Hola! Estoy interesado en adoptar a ${_adoption!.name} que vi en Mascotas SOS.

*Detalles de la mascota:*
- Nombre: ${_adoption!.name}
- Tipo: ${_adoption!.petType}
- Raza: ${_adoption!.breed}
- Edad: ${_adoption!.age}
- Descripción: ${_adoption!.description}

*Mis datos de contacto:*
- Nombre: ${_nameController.text}
- Teléfono: ${_phoneController.text}

${_messageController.text.isNotEmpty ? 'Mensaje adicional: ${_messageController.text}' : ''}
''';

    final Uri whatsappUrl = Uri.parse(
      'https://wa.me/${_adoption!.contactPhone}?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo abrir WhatsApp. ¿Tienes la aplicación instalada?'),
        ),
      );
    }
  }

  Future<void> _requestAdoption() async {
    if (_adoption == null) return;
    
    try {
      setState(() {
        _isLoading = true;
      });
      
      final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Solicitud de Adopción'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ingresa tu nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    hintText: 'Ingresa tu teléfono',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu teléfono';
                    }
                    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                      return 'Por favor ingresa un número de teléfono válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Mensaje',
                    hintText: 'Escribe tu mensaje',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un mensaje';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    // Aquí iría la lógica para enviar la solicitud
                    // Por ejemplo:
                    // await _adoptionProvider.sendAdoptionRequest(
                    //   adoptionId: widget.adoptionId,
                    //   name: _nameController.text,
                    //   phone: _phoneController.text,
                    //   message: _messageController.text,
                    // );
                    
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Solicitud de adopción enviada correctamente')),
                      );
                      
                      // Limpiar los controles después de enviar
                      _nameController.clear();
                      _phoneController.clear();
                      _messageController.clear();
                      
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al enviar la solicitud: ${e.toString()}')),
                      );
                    }
                  }
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
      );

      if (result == true) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Solicitud de adopción enviada correctamente')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la solicitud: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_adoption?.name ?? 'Detalle de Adopción'),
        actions: [
          if (_adoption != null)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: _shareAdoption,
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                  onPressed: _shareOnWhatsApp,
                  tooltip: 'Contactar por WhatsApp',
                ),
              ],
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : _hasError
              ? Center(child: ErrorMessage(message: _errorMessage))
              : _buildAdoptionDetails(),
      floatingActionButton: _adoption != null
          ? FloatingActionButton.extended(
              onPressed: _requestAdoption,
              label: const Text('Solicitar Adopción'),
              icon: const Icon(Icons.pets),
            )
          : null,
    );
  }

  Widget _buildAdoptionDetails() {
    if (_adoption == null) {
      return const Center(child: Text('No hay información disponible'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Galería de imágenes
          if (_adoption!.imageUrls.isNotEmpty)
            ImageGallery(imageUrls: _adoption!.imageUrls)
          else
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.pets, size: 100, color: Colors.grey),
            ),
          
          // Información principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _adoption!.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  _adoption!.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                
                // Características de la mascota
                _buildSectionTitle('Características'),
                _buildInfoRow('Tipo', _adoption!.petType),
                _buildInfoRow('Raza', _adoption!.breed),
                _buildInfoRow('Color', _adoption!.color),
                _buildInfoRow('Tamaño', _adoption!.size),
                _buildInfoRow('Género', _adoption!.gender),
                _buildInfoRow('Edad', _adoption!.age),
                
                // Estado de salud
                const SizedBox(height: 16),
                _buildSectionTitle('Estado de Salud'),
                _buildHealthStatus('Vacunado', _adoption!.isVaccinated),
                _buildHealthStatus('Esterilizado', _adoption!.isSterilized),
                _buildHealthStatus('Desparasitado', _adoption!.isDewormed),
                
                if (_adoption!.specialNeeds)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Necesidades Especiales:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(_adoption!.specialNeedsDescription),
                    ],
                  ),
                
                // Requisitos de adopción
                const SizedBox(height: 16),
                _buildSectionTitle('Requisitos para Adoptar'),
                Text(_adoption!.requirements),
                
                // Ubicación
                const SizedBox(height: 16),
                _buildSectionTitle('Ubicación'),
                Text(_adoption!.location),
                
                // Mapa
                if (_adoption!.latitude != 0 && _adoption!.longitude != 0)
                  Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_adoption!.latitude, _adoption!.longitude),
                          zoom: 14,
                        ),
                        markers: _markers,
                        mapType: MapType.normal,
                        myLocationEnabled: false,
                        zoomControlsEnabled: false,
                      ),
                    ),
                  ),
                
                // Contacto
                const SizedBox(height: 16),
                _buildSectionTitle('Contacto'),
                InkWell(
                  onTap: () => _makePhoneCall(_adoption!.contactPhone),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        _adoption!.contactPhone,
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Fecha de publicación
                const SizedBox(height: 16),
                Text(
                  'Publicado: ${_formatDate(_adoption!.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (_adoption!.createdAt != _adoption!.updatedAt)
                  Text(
                    'Actualizado: ${_formatDate(_adoption!.updatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildHealthStatus(String label, bool status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            color: status ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
