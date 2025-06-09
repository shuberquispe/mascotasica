import 'package:flutter/material.dart';

class CareCalendarScreen extends StatelessWidget {
  final String petId;
  
  const CareCalendarScreen({Key? key, required this.petId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Cuidados'),
      ),
      body: Center(
        child: Text('Calendario de cuidados para mascota ID: $petId - En desarrollo'),
      ),
    );
  }
}
