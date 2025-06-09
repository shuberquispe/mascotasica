import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foro'),
      ),
      body: const Center(
        child: Text('Pantalla de foro en desarrollo'),
      ),
    );
  }
}
