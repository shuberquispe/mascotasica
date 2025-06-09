import 'package:flutter/material.dart';

class ReportsListScreen extends StatelessWidget {
  const ReportsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Reportes'),
      ),
      body: const Center(
        child: Text('Pantalla de lista de reportes en desarrollo'),
      ),
    );
  }
}
