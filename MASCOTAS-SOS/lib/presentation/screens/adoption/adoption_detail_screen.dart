import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/models/adoption_model.dart';

class AdoptionDetailScreen extends StatefulWidget {
  final String adoptionId;

  const AdoptionDetailScreen({
    Key? key,
    required this.adoptionId,
  }) : super(key: key);

  @override
  State<AdoptionDetailScreen> createState() => _AdoptionDetailScreenState();
}

class _AdoptionDetailScreenState extends State<AdoptionDetailScreen> {
  bool _isLoading = true;
  AdoptionModel? _adoption;
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadAdoptionData();
  }

  Future<void> _loadAdoptionData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Aquí se implementará la lógica para cargar los datos de adopción desde Firestore
      await Future.delayed(const Duration(seconds: 1)); // Simulación de carga
      
      // Datos de ejemplo para simular una adopción
      final adoption = AdoptionModel(
        id: widget.adoptionId,
        userId: 'user_id_example',
        name: 'Luna',
        description: 'Luna es una perrita muy cariñosa y juguetona. Le encanta salir a pasear y jugar con pelotas. Es muy buena con niños y otros animales.',
        petType: 'Perro',
        breed: 'Mestizo',
        color: 'Blanco con manchas negras',
        size: 'Mediano',
        gender: 'Hembra',
        age: 'Joven',
        isVaccinated: true,
        isSterilized: true,
        isDewormed: true,
        specialNeeds: false,
        specialNeedsDescription: '',
        status: 'disponible',
        location: 'Urb. San Isidro, Ica',
        contactPhone: '956123456',
        requirements: 'Hogar con espacio suficiente. Compromiso de cuidado responsable. Se realizará visita previa.',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
        imageUrls: [
          'https://via.placeholder.com/400x300',
          'https://via.placeholder.com/400x300',
          'https://via.placeholder.com/400x300',
        ],
        latitude: -14.0678,
        longitude: -75.7286,
      );
      
      if (mounted) {
        setState(() {
          _adoption = adoption;
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
            content: Text('Error al cargar la adopción: ${e.toString()}'),
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

  void _contactOwner() {
    // Implementar lógica para contactar al dueño
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
                Text('+51 ${_adoption?.contactPhone ?? ""}'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _shareAdoption() {
    // Implementar lógica para compartir la adopción
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Compartiendo publicación de adopción...'),
      ),
    );
  }

  void _requestAdoption() {
    // Implementar lógica para solicitar adopción
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Solicitar adopción'),
        content: const Text('¿Estás interesado en adoptar a esta mascota? Te pondremos en contacto con el responsable de la adopción.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Mostrar formulario o mensaje de confirmación
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitud enviada. El responsable se pondrá en contacto contigo.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    background: Stack(
                      children: [
                        // Carrusel de imágenes
                        PageView.builder(
                          controller: _pageController,
                          onPageChanged: _onPageChanged,
                          itemCount: _adoption?.imageUrls.length ?? 0,
                          itemBuilder: (context, index) {
                            return Image.network(
                              _adoption?.imageUrls[index] ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        
                        // Indicadores de página
                        if ((_adoption?.imageUrls.length ?? 0) > 1)
                          Positioned(
                            bottom: 16,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _adoption?.imageUrls.length ?? 0,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
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
                        
                        // Etiqueta de adopción
                        Positioned(
                          top: 16 + MediaQuery.of(context).padding.top,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Text(
                              'En adopción',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Contenido
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre y edad
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                _adoption?.name ?? '',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _adoption?.age ?? '',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        
                        // Ubicación y fecha
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _adoption?.location ?? '',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _adoption?.createdAt != null
                                  ? DateFormat('dd/MM/yyyy').format(_adoption!.createdAt)
                                  : '',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Botones de acción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(
                              icon: Icons.phone,
                              label: 'Contactar',
                              onTap: _contactOwner,
                            ),
                            _buildActionButton(
                              icon: Icons.share,
                              label: 'Compartir',
                              onTap: _shareAdoption,
                            ),
                            _buildActionButton(
                              icon: Icons.pets,
                              label: 'Adoptar',
                              onTap: _requestAdoption,
                              isPrimary: true,
                            ),
                          ],
                        ),
                        const Divider(height: 32),
                        
                        // Descripción
                        const Text(
                          'Descripción',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_adoption?.description ?? ''),
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
                        _buildCharacteristicRow('Tipo', _adoption?.petType ?? ''),
                        _buildCharacteristicRow('Raza', _adoption?.breed ?? 'No especificada'),
                        _buildCharacteristicRow('Color', _adoption?.color ?? ''),
                        _buildCharacteristicRow('Tamaño', _adoption?.size ?? ''),
                        _buildCharacteristicRow('Género', _adoption?.gender ?? 'No especificado'),
                        const SizedBox(height: 24),
                        
                        // Información de salud
                        const Text(
                          'Información de salud',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildHealthItem(
                          'Vacunado',
                          _adoption?.isVaccinated ?? false,
                        ),
                        _buildHealthItem(
                          'Esterilizado',
                          _adoption?.isSterilized ?? false,
                        ),
                        _buildHealthItem(
                          'Desparasitado',
                          _adoption?.isDewormed ?? false,
                        ),
                        
                        // Necesidades especiales
                        if (_adoption?.specialNeeds ?? false) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Necesidades especiales:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_adoption?.specialNeedsDescription ?? ''),
                        ],
                        const SizedBox(height: 24),
                        
                        // Requisitos para adoptar
                        const Text(
                          'Requisitos para adoptar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_adoption?.requirements ?? ''),
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
                            Text('+51 ${_adoption?.contactPhone ?? ""}'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        
                        // Botón de solicitar adopción
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _requestAdoption,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'Solicitar adopción',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
    bool isPrimary = false,
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
            Icon(
              icon,
              color: isPrimary ? Theme.of(context).colorScheme.primary : null,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: isPrimary
                  ? TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
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

  Widget _buildHealthItem(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}
