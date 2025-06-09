import 'package:flutter/material.dart';

class PetProfileScreen extends StatelessWidget {
  final String petId;
  
  const PetProfileScreen({Key? key, required this.petId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Mascota'),
      ),
      body: Center(
        child: Text('Perfil de mascota ID: $petId - En desarrollo'),
      ),
    );
  }
}
