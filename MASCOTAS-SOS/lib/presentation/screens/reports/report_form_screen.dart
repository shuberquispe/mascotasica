import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../config/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/report_model.dart';

class ReportFormScreen extends StatefulWidget {
  final String reportType; // 'perdido' o 'encontrado'

  const ReportFormScreen({
    Key? key,
    required this.reportType,
  }) : super(key: key);

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  
  String _selectedPetType = 'Perro';
  String _selectedBreed = '';
  String _selectedColor = '';
  String _selectedSize = 'Mediano';
  String _selectedGender = 'No especificado';
  DateTime _reportDate = DateTime.now();
  final List<File> _selectedImages = [];
  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Establecer título predeterminado según el tipo de reporte
    _titleController.text = widget.reportType == 'perdido'
        ? 'Mascota perdida'
        : 'Mascota encontrada';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al seleccionar imagen: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (photo != null) {
        setState(() {
          _selectedImages.add(File(photo.path));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al tomar foto: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _reportDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _reportDate) {
      setState(() {
        _reportDate = picked;
      });
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, añade al menos una imagen'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        // Simulación de carga de imágenes a Firebase Storage
        // En una implementación real, aquí subiríamos las imágenes y obtendríamos las URLs
        List<String> imageUrls = List.generate(_selectedImages.length, 
          (index) => 'https://example.com/image${index + 1}.jpg');
        
        // Crear el modelo de reporte
        final report = ReportModel(
          id: 'temp_id_${DateTime.now().millisecondsSinceEpoch}', // Se generará en Firebase
          userId: 'user_id_temp', // Se obtendrá del usuario autenticado
          reportType: widget.reportType,
          title: _titleController.text,
          description: _descriptionController.text,
          petType: _selectedPetType,
          breed: _selectedBreed,
          color: _selectedColor,
          size: _selectedSize,
          gender: _selectedGender,
          location: _locationController.text,
          contactPhone: _contactPhoneController.text,
          reportDate: _reportDate,
          status: 'activo',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          imageUrls: imageUrls,
          latitude: 0.0, // En una implementación real, obtendríamos las coordenadas
          longitude: 0.0, // Se implementará la geolocalización más adelante
        );

        // Aquí se implementará la lógica para subir imágenes a Firebase Storage
        // y guardar el reporte en Firestore
        await Future.delayed(const Duration(seconds: 2)); // Simulación de carga
        
        // Mostrar mensaje de éxito y volver a la pantalla anterior
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reporte enviado con éxito'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar reporte: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPerdido = widget.reportType == 'perdido';
    final String titleText = isPerdido
        ? 'Reportar mascota perdida'
        : 'Reportar mascota encontrada';
    final Color accentColor = isPerdido ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sección de imágenes
                Text(
                  'Fotos de la mascota',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Añade al menos una foto clara de la mascota',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Previsualización de imágenes seleccionadas
                if (_selectedImages.isNotEmpty) ...[
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImages[index],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Botones para añadir imágenes
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Galería'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _takePhoto,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Cámara'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Sección de información básica
                Text(
                  'Información básica',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Título del reporte
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ej: Perro perdido en Ica Centro',
                  ),
                  validator: (value) => Validators.validateRequired(value, 'El título'),
                ),
                const SizedBox(height: 16),
                
                // Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Describe la mascota y las circunstancias',
                  ),
                  maxLines: 3,
                  validator: (value) => Validators.validateRequired(value, 'La descripción'),
                ),
                const SizedBox(height: 16),
                
                // Tipo de mascota
                DropdownButtonFormField<String>(
                  value: _selectedPetType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de mascota',
                  ),
                  items: AppConstants.petTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPetType = value!;
                      // Resetear la raza al cambiar el tipo
                      _selectedBreed = '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Raza (opcional)
                TextFormField(
                  initialValue: _selectedBreed,
                  decoration: const InputDecoration(
                    labelText: 'Raza (opcional)',
                    hintText: 'Ej: Labrador, Mestizo, etc.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedBreed = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Color
                TextFormField(
                  initialValue: _selectedColor,
                  decoration: const InputDecoration(
                    labelText: 'Color',
                    hintText: 'Ej: Negro, Marrón, Blanco y negro, etc.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedColor = value;
                    });
                  },
                  validator: (value) => Validators.validateRequired(value, 'El color'),
                ),
                const SizedBox(height: 16),
                
                // Tamaño
                DropdownButtonFormField<String>(
                  value: _selectedSize,
                  decoration: const InputDecoration(
                    labelText: 'Tamaño',
                  ),
                  items: ['Pequeño', 'Mediano', 'Grande'].map((size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSize = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Género
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Género',
                  ),
                  items: ['Macho', 'Hembra', 'No especificado'].map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                // Sección de ubicación y contacto
                Text(
                  'Ubicación y contacto',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Fecha del reporte
                InkWell(
                  onTap: () => _selectDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Fecha',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      '${_reportDate.day}/${_reportDate.month}/${_reportDate.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Ubicación
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Ubicación',
                    hintText: 'Ej: Av. Los Maestros, Ica Centro',
                    suffixIcon: Icon(Icons.location_on),
                  ),
                  validator: (value) => Validators.validateRequired(value, 'La ubicación'),
                ),
                const SizedBox(height: 16),
                
                // Teléfono de contacto
                TextFormField(
                  controller: _contactPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono de contacto',
                    hintText: 'Ej: 956123456',
                    prefixText: '+51 ',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 32),
                
                // Botón de enviar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Enviar reporte',
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
      ),
    );
  }
}
