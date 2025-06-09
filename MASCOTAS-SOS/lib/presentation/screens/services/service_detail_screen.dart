import 'package:flutter/material.dart';

class ServiceDetailScreen extends StatelessWidget {
  final String serviceId;
  
  const ServiceDetailScreen({Key? key, required this.serviceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Servicio'),
      ),
      body: Center(
        child: Text('Detalle de servicio ID: $serviceId - En desarrollo'),
      ),
    );
  }
}
