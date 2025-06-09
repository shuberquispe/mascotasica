import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/adoption_provider.dart';
import '../../../data/models/adoption_model.dart';
import '../../../config/routes.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/error_message.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdoptionsListScreen extends StatefulWidget {
  const AdoptionsListScreen({Key? key}) : super(key: key);

  @override
  _AdoptionsListScreenState createState() => _AdoptionsListScreenState();
}

class _AdoptionsListScreenState extends State<AdoptionsListScreen> {
  late AdoptionProvider _adoptionProvider;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<AdoptionModel> _adoptions = [];
  String _selectedFilter = 'Todos';
  final List<String> _filterOptions = ['Todos', 'Perro', 'Gato', 'Ave', 'Otro'];

  @override
  void initState() {
    super.initState();
    _adoptionProvider = Provider.of<AdoptionProvider>(context, listen: false);
    _loadAdoptions();
  }

  Future<void> _loadAdoptions() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final adoptions = await _adoptionProvider.getAdoptions();
      
      setState(() {
        _adoptions = adoptions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Error al cargar las adopciones: $e';
      });
    }
  }

  List<AdoptionModel> get _filteredAdoptions {
    if (_selectedFilter == 'Todos') {
      return _adoptions;
    } else {
      return _adoptions.where((adoption) => adoption.petType == _selectedFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : _hasError
              ? Center(
                  child: ErrorMessage(
                    message: _errorMessage,
                    onRetry: _loadAdoptions,
                  ),
                )
              : _adoptions.isEmpty
                  ? const Center(
                      child: Text('No hay mascotas en adopción disponibles'),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadAdoptions,
                      child: _buildAdoptionsList(),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.adoptionForm).then((_) => _loadAdoptions());
        },
        tooltip: 'Publicar adopción',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAdoptionsList() {
    final filteredAdoptions = _filteredAdoptions;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedFilter != 'Todos')
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Chip(
              label: Text('Filtro: $_selectedFilter'),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                setState(() {
                  _selectedFilter = 'Todos';
                });
              },
            ),
          ),
        Expanded(
          child: filteredAdoptions.isEmpty
              ? const Center(
                  child: Text('No hay mascotas que coincidan con el filtro'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredAdoptions.length,
                  itemBuilder: (context, index) {
                    final adoption = filteredAdoptions[index];
                    return _buildAdoptionCard(adoption);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildAdoptionCard(AdoptionModel adoption) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.adoptionDetail,
            arguments: adoption.id,
          ).then((_) => _loadAdoptions());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            SizedBox(
              height: 200,
              width: double.infinity,
              child: adoption.imageUrls.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: adoption.imageUrls.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.pets, size: 80, color: Colors.grey),
                    ),
            ),
            
            // Etiqueta de estado
            if (adoption.status != 'disponible')
              Container(
                color: adoption.status == 'adoptado' ? Colors.green : Colors.orange,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  adoption.status == 'adoptado' ? 'ADOPTADO' : 'EN PROCESO',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            
            // Información de la mascota
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          adoption.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          adoption.petType,
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    adoption.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  
                  // Características principales
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(
                        icon: Icons.pets,
                        label: adoption.breed.isNotEmpty ? adoption.breed : 'Sin raza',
                      ),
                      _buildInfoChip(
                        icon: Icons.straighten,
                        label: adoption.size,
                      ),
                      _buildInfoChip(
                        icon: adoption.gender == 'Macho' ? Icons.male : Icons.female,
                        label: adoption.gender,
                      ),
                      _buildInfoChip(
                        icon: Icons.calendar_today,
                        label: adoption.age,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          adoption.location,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Publicado: ${_formatDate(adoption.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrar por tipo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _filterOptions.map((filter) {
              return RadioListTile<String>(
                title: Text(filter),
                value: filter,
                groupValue: _selectedFilter,
                onChanged: (value) {
                  Navigator.pop(context);
                  if (value != null) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  }
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
