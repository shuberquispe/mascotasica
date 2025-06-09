import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../config/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/adoption_model.dart';

class AdoptionFormScreen extends StatefulWidget {
  const AdoptionFormScreen({Key? key}) : super(key: key);

  @override
  State<AdoptionFormScreen> createState() => _AdoptionFormScreenState();
}

class _AdoptionFormScreenState extends State<AdoptionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _requirementsController = TextEditingController();
  
  String _selectedPetType = 'Perro';
  String _selectedBreed = '';
  String _selectedColor = '';
  String _selectedSize = 'Mediano';
  String _selectedGender = 'No especificado';
  String _selectedAge = 'Adulto';
  bool _isVaccinated = false;
  bool _isSterilized = false;
  bool _isDewormed = false;
  bool _specialNeeds = false;
  String _specialNeedsDescription = '';
  final List<File> _selectedImages = [];
  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _contactPhoneController.dispose();
    _requirementsController.dispose();
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

  Future<void> _submitAdoption() async {
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
        // Crear el modelo de adopción
        final adoption = AdoptionModel(
          id: '', // Se generará en Firebase
          userId: '', // Se obtendrá del usuario autenticado
          name: _nameController.text,
          description: _descriptionController.text,
          petType: _selectedPetType,
          breed: _selectedBreed,
          color: _selectedColor,
          size: _selectedSize,
          gender: _selectedGender,
          age: _selectedAge,
          isVaccinated: _isVaccinated,
          isSterilized: _isSterilized,
          isDewormed: _isDewormed,
          specialNeeds: _specialNeeds,
          specialNeedsDescription: _specialNeedsDescription,
          status: 'disponible',
          location: _locationController.text,
          contactPhone: _contactPhoneController.text,
          requirements: _requirementsController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          imageUrls: [], // Se subirán las imágenes a Firebase Storage
          latitude: 0, // Se implementará la geolocalización más adelante
          longitude: 0,
        );

        // Aquí se implementará la lógica para subir imágenes a Firebase Storage
        // y guardar la adopción en Firestore
        await Future.delayed(const Duration(seconds: 2)); // Simulación de carga
        
        // Mostrar mensaje de éxito y volver a la pantalla anterior
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Solicitud de adopción enviada con éxito'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        // Mostrar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar solicitud: ${e.toString()}'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar mascota en adopción'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
                
                // Nombre de la mascota
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la mascota',
                    hintText: 'Ej: Max, Luna, etc.',
                  ),
                  validator: (value) => Validators.validateRequired(value, 'El nombre'),
                ),
                const SizedBox(height: 16),
                
                // Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Describe la personalidad y características de la mascota',
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
                const SizedBox(height: 16),
                
                // Edad aproximada
                DropdownButtonFormField<String>(
                  value: _selectedAge,
                  decoration: const InputDecoration(
                    labelText: 'Edad aproximada',
                  ),
                  items: ['Cachorro', 'Joven', 'Adulto', 'Senior'].map((age) {
                    return DropdownMenuItem<String>(
                      value: age,
                      child: Text(age),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAge = value!;
                    });
                  },
                ),
                const SizedBox(height: 24),
                
                // Sección de salud
                Text(
                  'Información de salud',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Vacunado
                SwitchListTile(
                  title: const Text('Vacunado'),
                  value: _isVaccinated,
                  onChanged: (value) {
                    setState(() {
                      _isVaccinated = value;
                    });
                  },
                ),
                
                // Esterilizado
                SwitchListTile(
                  title: const Text('Esterilizado'),
                  value: _isSterilized,
                  onChanged: (value) {
                    setState(() {
                      _isSterilized = value;
                    });
                  },
                ),
                
                // Desparasitado
                SwitchListTile(
                  title: const Text('Desparasitado'),
                  value: _isDewormed,
                  onChanged: (value) {
                    setState(() {
                      _isDewormed = value;
                    });
                  },
                ),
                
                // Necesidades especiales
                SwitchListTile(
                  title: const Text('Necesidades especiales'),
                  value: _specialNeeds,
                  onChanged: (value) {
                    setState(() {
                      _specialNeeds = value;
                      if (!value) {
                        _specialNeedsDescription = '';
                      }
                    });
                  },
                ),
                
                // Descripción de necesidades especiales
                if (_specialNeeds) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    initialValue: _specialNeedsDescription,
                    decoration: const InputDecoration(
                      labelText: 'Descripción de necesidades especiales',
                      hintText: 'Ej: Medicación diaria, movilidad reducida, etc.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _specialNeedsDescription = value;
                      });
                    },
                    validator: (value) {
                      if (_specialNeeds && (value == null || value.isEmpty)) {
                        return 'Por favor, describe las necesidades especiales';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
                
                // Sección de ubicación y contacto
                Text(
                  'Ubicación y contacto',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
                const SizedBox(height: 16),
                
                // Requisitos para adoptar
                TextFormField(
                  controller: _requirementsController,
                  decoration: const InputDecoration(
                    labelText: 'Requisitos para adoptar',
                    hintText: 'Ej: Hogar con espacio, visita previa, etc.',
                  ),
                  maxLines: 3,
                  validator: (value) => Validators.validateRequired(value, 'Los requisitos'),
                ),
                const SizedBox(height: 32),
                
                // Botón de enviar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitAdoption,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Publicar en adopción',
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
