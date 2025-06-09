import 'package:flutter/material.dart';

class GuideDetailScreen extends StatelessWidget {
  final String guideId;
  
  const GuideDetailScreen({Key? key, required this.guideId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Guía'),
      ),
      body: Center(
        child: Text('Detalle de guía ID: $guideId - En desarrollo'),
      ),
    );
  }
}
