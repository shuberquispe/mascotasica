import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../../providers/adoption_provider.dart';
import '../../../data/models/adoption_model.dart';
import '../../widgets/common/loading_indicator.dart';

class AdoptionFormScreen extends StatefulWidget {
  final AdoptionModel? adoption; // Si es null, es un nuevo registro

  const AdoptionFormScreen({
    Key? key,
    this.adoption,
  }) : super(key: key);

  @override
  _AdoptionFormScreenState createState() => _AdoptionFormScreenState();
}

class _AdoptionFormScreenState extends State<AdoptionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _ageController = TextEditingController();
  final _specialNeedsDescController = TextEditingController();
  final _locationController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _requirementsController = TextEditingController();

  String _petType = 'Perro';
  String _size = 'Mediano';
  String _gender = 'Macho';
  bool _isVaccinated = false;
  bool _isSterilized = false;
  bool _isDewormed = false;
  bool _specialNeeds = false;
  
  final List<XFile> _selectedImages = [];
  List<String> _existingImageUrls = [];
  
  double _latitude = 0.0;
  double _longitude = 0.0;
  
  bool _isLoading = false;
  bool _isEditing = false;
  
  final List<String> _petTypes = ['Perro', 'Gato', 'Ave', 'Otro'];
  final List<String> _sizes = ['Pequeño', 'Mediano', 'Grande'];
  final List<String> _genders = ['Macho', 'Hembra'];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.adoption != null;
    
    if (_isEditing) {
      _loadExistingData();
    }
    
    // Intentar obtener la ubicación actual
    _getCurrentLocation();
  }

  void _loadExistingData() {
    final adoption = widget.adoption!;
    
    _nameController.text = adoption.name;
    _descriptionController.text = adoption.description;
    _petType = adoption.petType;
    _breedController.text = adoption.breed;
    _colorController.text = adoption.color;
    _size = adoption.size;
    _gender = adoption.gender;
    _ageController.text = adoption.age;
    _isVaccinated = adoption.isVaccinated;
    _isSterilized = adoption.isSterilized;
    _isDewormed = adoption.isDewormed;
    _specialNeeds = adoption.specialNeeds;
    _specialNeedsDescController.text = adoption.specialNeedsDescription;
    _locationController.text = adoption.location;
    _contactPhoneController.text = adoption.contactPhone;
    _requirementsController.text = adoption.requirements;
    _existingImageUrls = adoption.imageUrls;
    _latitude = adoption.latitude;
    _longitude = adoption.longitude;
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Verificar permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permisos de ubicación denegados')),
          );
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Los permisos de ubicación están permanentemente denegados, no se puede solicitar'),
          ),
        );
        return;
      }
      
      // Obtener la posición actual
      final position = await Geolocator.getCurrentPosition();
      
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });
      
      // Intentar obtener la dirección a partir de las coordenadas
      if (_locationController.text.isEmpty) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            String address = '${place.street}, ${place.locality}, ${place.administrativeArea}';
            setState(() {
              _locationController.text = address;
            });
          }
        } catch (e) {
          print('Error al obtener la dirección: $e');
        }
      }
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> _pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imágenes: $e')),
      );
    }
  }

  void _removeSelectedImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImageUrls.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final adoptionProvider = Provider.of<AdoptionProvider>(context, listen: false);
      
      // Obtener el ID del usuario actual (en una implementación real, esto vendría de Firebase Auth)
      const String currentUserId = 'usuario_actual'; // Temporal, debe reemplazarse con Firebase Auth
      
      if (_isEditing) {
        // Actualizar adopción existente
        final updatedAdoption = widget.adoption!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text,
          petType: _petType,
          breed: _breedController.text,
          color: _colorController.text,
          size: _size,
          gender: _gender,
          age: _ageController.text,
          isVaccinated: _isVaccinated,
          isSterilized: _isSterilized,
          isDewormed: _isDewormed,
          specialNeeds: _specialNeeds,
          specialNeedsDescription: _specialNeedsDescController.text,
          location: _locationController.text,
          contactPhone: _contactPhoneController.text,
          requirements: _requirementsController.text,
          latitude: _latitude,
          longitude: _longitude,
          updatedAt: DateTime.now(),
          // Mantener las URLs de imágenes existentes
          imageUrls: _existingImageUrls,
        );
        
        // Nota: En una implementación completa con Firebase Storage, aquí se convertirían y subirían las nuevas imágenes
        // final List<File> newImageFiles = _selectedImages.map((xFile) => File(xFile.path)).toList();
        
        await adoptionProvider.updateAdoption(
          widget.adoption!.id,
          updatedAdoption,
        );
        
        // Nota: En una implementación completa, aquí se subirían las nuevas imágenes
      } else {
        // Crear nueva adopción
        final newAdoption = AdoptionModel(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}', // ID temporal
          userId: currentUserId,
          name: _nameController.text,
          description: _descriptionController.text,
          petType: _petType,
          breed: _breedController.text,
          color: _colorController.text,
          size: _size,
          gender: _gender,
          age: _ageController.text,
          isVaccinated: _isVaccinated,
          isSterilized: _isSterilized,
          isDewormed: _isDewormed,
          specialNeeds: _specialNeeds,
          specialNeedsDescription: _specialNeedsDescController.text,
          location: _locationController.text,
          contactPhone: _contactPhoneController.text,
          requirements: _requirementsController.text,
          latitude: _latitude,
          longitude: _longitude,
          status: 'disponible',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          imageUrls: [], // Las imágenes se subirán después
        );
        
        // Convertir XFile a File para la subida de imágenes
        final List<File> imageFiles = _selectedImages.map((xFile) => File(xFile.path)).toList();
        
        await adoptionProvider.createAdoption(
          newAdoption,
          imageFiles,
        );
      }
      
      setState(() {
        _isLoading = false;
      });
      
      // Mostrar mensaje de éxito y volver a la pantalla anterior
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Adopción actualizada correctamente' : 'Adopción creada correctamente')),
      );
      
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _ageController.dispose();
    _specialNeedsDescController.dispose();
    _locationController.dispose();
    _contactPhoneController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Adopción' : 'Nueva Adopción'),
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección de imágenes
                    _buildSectionTitle('Fotos de la Mascota'),
                    _buildImageSection(),
                    const SizedBox(height: 16),
                    
                    // Información básica
                    _buildSectionTitle('Información Básica'),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de la mascota *',
                        hintText: 'Ej. Rocky',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción *',
                        hintText: 'Describe la personalidad y características de la mascota',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una descripción';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Características físicas
                    _buildSectionTitle('Características'),
                    _buildDropdownField(
                      label: 'Tipo de mascota *',
                      value: _petType,
                      items: _petTypes,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _petType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _breedController,
                      decoration: const InputDecoration(
                        labelText: 'Raza',
                        hintText: 'Ej. Labrador, Mestizo, etc.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _colorController,
                      decoration: const InputDecoration(
                        labelText: 'Color',
                        hintText: 'Ej. Negro, Marrón, etc.',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Tamaño *',
                      value: _size,
                      items: _sizes,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _size = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Género *',
                      value: _gender,
                      items: _genders,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _gender = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Edad aproximada *',
                        hintText: 'Ej. 2 años, 6 meses, etc.',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la edad aproximada';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Estado de salud
                    _buildSectionTitle('Estado de Salud'),
                    _buildCheckboxField(
                      label: 'Vacunado',
                      value: _isVaccinated,
                      onChanged: (value) {
                        setState(() {
                          _isVaccinated = value ?? false;
                        });
                      },
                    ),
                    _buildCheckboxField(
                      label: 'Esterilizado',
                      value: _isSterilized,
                      onChanged: (value) {
                        setState(() {
                          _isSterilized = value ?? false;
                        });
                      },
                    ),
                    _buildCheckboxField(
                      label: 'Desparasitado',
                      value: _isDewormed,
                      onChanged: (value) {
                        setState(() {
                          _isDewormed = value ?? false;
                        });
                      },
                    ),
                    _buildCheckboxField(
                      label: 'Necesidades especiales',
                      value: _specialNeeds,
                      onChanged: (value) {
                        setState(() {
                          _specialNeeds = value ?? false;
                        });
                      },
                    ),
                    if (_specialNeeds)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextFormField(
                          controller: _specialNeedsDescController,
                          decoration: const InputDecoration(
                            labelText: 'Descripción de necesidades especiales *',
                            hintText: 'Ej. Medicación diaria, cuidados específicos, etc.',
                          ),
                          maxLines: 2,
                          validator: (value) {
                            if (_specialNeeds && (value == null || value.isEmpty)) {
                              return 'Por favor describe las necesidades especiales';
                            }
                            return null;
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    
                    // Requisitos de adopción
                    _buildSectionTitle('Requisitos para Adoptar'),
                    TextFormField(
                      controller: _requirementsController,
                      decoration: const InputDecoration(
                        labelText: 'Requisitos *',
                        hintText: 'Ej. Visita previa, seguimiento post-adopción, etc.',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa los requisitos para adoptar';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Ubicación y contacto
                    _buildSectionTitle('Ubicación y Contacto'),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Ubicación *',
                        hintText: 'Ej. Ica, Urbanización X, etc.',
                        suffixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la ubicación';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _contactPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono de contacto *',
                        hintText: 'Ej. 999999999',
                        prefixText: '+51 ',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un número de contacto';
                        }
                        if (value.length < 9) {
                          return 'El número debe tener al menos 9 dígitos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Botón de envío
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          _isEditing ? 'Actualizar Adopción' : 'Publicar Adopción',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imágenes existentes (si es edición)
        if (_existingImageUrls.isNotEmpty) ...[
          const Text('Imágenes actuales:'),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _existingImageUrls.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(_existingImageUrls[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _removeExistingImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Nuevas imágenes seleccionadas
        if (_selectedImages.isNotEmpty) ...[
          const Text('Nuevas imágenes:'),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(_selectedImages[index].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _removeSelectedImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Botón para agregar imágenes
        OutlinedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Agregar Fotos'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildCheckboxField({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
