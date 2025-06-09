import 'package:flutter/material.dart';

class GuidesScreen extends StatelessWidget {
  const GuidesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guías de Cuidado'),
      ),
      body: const Center(
        child: Text('Pantalla de guías de cuidado en desarrollo'),
      ),
    );
  }
}
