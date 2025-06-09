import 'package:flutter/material.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mascotas'),
      ),
      body: const Center(
        child: Text('Pantalla de mis mascotas en desarrollo'),
      ),
    );
  }
}
