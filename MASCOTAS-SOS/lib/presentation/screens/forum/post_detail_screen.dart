import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final String postId;
  
  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Publicación'),
      ),
      body: Center(
        child: Text('Detalle de publicación ID: $postId - En desarrollo'),
      ),
    );
  }
}
