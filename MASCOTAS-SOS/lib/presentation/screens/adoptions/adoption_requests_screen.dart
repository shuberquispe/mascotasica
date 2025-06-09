import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/adoption_provider.dart';
import '../../../data/models/adoption_request_model.dart';
import '../../../data/models/adoption_model.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_message.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/constants.dart';

class AdoptionRequestsScreen extends StatefulWidget {
  final String adoptionId;

  const AdoptionRequestsScreen({
    Key? key,
    required this.adoptionId,
  }) : super(key: key);

  @override
  _AdoptionRequestsScreenState createState() => _AdoptionRequestsScreenState();
}

class _AdoptionRequestsScreenState extends State<AdoptionRequestsScreen> {
  late AdoptionProvider _adoptionProvider;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<AdoptionRequestModel> _requests = [];
  AdoptionModel? _adoption;

  @override
  void initState() {
    super.initState();
    _adoptionProvider = Provider.of<AdoptionProvider>(context, listen: false);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Cargar la adopción
      final adoption = await _adoptionProvider.getAdoptionById(widget.adoptionId);
      
      if (adoption == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'No se encontró la publicación de adopción';
        });
        return;
      }
      
      // Cargar las solicitudes de adopción
      final requests = await _adoptionProvider.getAdoptionRequests(widget.adoptionId);
      
      setState(() {
        _adoption = adoption;
        _requests = requests;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error al cargar las solicitudes: $e';
      });
    }
  }

  Future<void> _updateRequestStatus(String requestId, String newStatus, [String? responseMessage]) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      await _adoptionProvider.updateAdoptionRequestStatus(
        requestId: requestId,
        status: newStatus,
        responseMessage: responseMessage,
      );
      
      // Si se aprueba una solicitud, actualizar el estado de la adopción a "en proceso"
      if (newStatus == AppConstants.requestStatusApproved && _adoption != null) {
        await _adoptionProvider.updateAdoptionStatus(
          adoptionId: widget.adoptionId,
          status: AppConstants.adoptionStatusInProcess,
        );
      }
      
      await _loadData();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == AppConstants.requestStatusApproved
                ? 'Solicitud aprobada correctamente'
                : 'Solicitud rechazada correctamente',
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la solicitud: $e')),
      );
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo realizar la llamada a $phoneNumber')),
      );
    }
  }

  Future<void> _showResponseDialog(String requestId) async {
    final TextEditingController responseController = TextEditingController();
    
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Responder solicitud'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Escribe un mensaje para el solicitante:'),
              const SizedBox(height: 16),
              TextField(
                controller: responseController,
                decoration: const InputDecoration(
                  hintText: 'Ej: Nos gustaría conocerte mejor...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, responseController.text);
              },
              child: const Text('Aprobar'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value is String) {
        _updateRequestStatus(requestId, 'aprobada', value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Adopción'),
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : _hasError
              ? Center(
                  child: ErrorMessage(
                    message: _errorMessage,
                    onRetry: _loadData,
                  ),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_requests.isEmpty) {
      return const Center(
        child: Text('No hay solicitudes de adopción para esta mascota'),
      );
    }

    return Column(
      children: [
        // Información de la mascota
        if (_adoption != null)
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.1),
            child: Row(
              children: [
                if (_adoption!.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _adoption!.imageUrls.first,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.pets, color: Colors.grey),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _adoption!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Estado: ${_adoption!.status}',
                        style: TextStyle(
                          color: _adoption!.status == 'disponible'
                              ? Colors.green
                              : _adoption!.status == 'en proceso'
                                  ? Colors.orange
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        
        // Lista de solicitudes
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _requests.length,
            itemBuilder: (context, index) {
              final request = _requests[index];
              return _buildRequestCard(request);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(AdoptionRequestModel request) {
    final bool isPending = request.status == AppConstants.requestStatusPending;
    final bool isApproved = request.status == AppConstants.requestStatusApproved;
    // Utilizamos isRejected para determinar el color y texto del estado
    final bool isRejected = request.status == AppConstants.requestStatusRejected;
    
    Color statusColor = isPending
        ? Colors.orange
        : isApproved
            ? Colors.green
            : Colors.red;
    
    String statusText = isPending
        ? 'Pendiente'
        : isApproved
            ? 'Aprobada'
            : isRejected
                ? 'Rechazada'
                : 'Desconocido';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: statusColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con estado
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPending
                            ? Icons.schedule
                            : isApproved
                                ? Icons.check_circle
                                : Icons.cancel,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Solicitud: ${_formatDate(request.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Mensaje del solicitante
            Text(
              'Mensaje del solicitante:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(request.message),
            ),
            
            // Respuesta (si existe)
            if (request.responseMessage != null && request.responseMessage!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Tu respuesta:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(request.responseMessage!),
              ),
            ],
            
            // Acciones
            const SizedBox(height: 16),
            if (isPending)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => _updateRequestStatus(request.id, 'rechazada'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Rechazar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showResponseDialog(request.id),
                    child: const Text('Aprobar'),
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // Aquí se debería obtener el teléfono del usuario solicitante
                      // Por ahora usamos un número ficticio
                      _makePhoneCall('999999999');
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text('Contactar'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
