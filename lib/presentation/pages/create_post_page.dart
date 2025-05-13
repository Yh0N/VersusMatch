import 'package:flutter/material.dart';
import 'package:versus_match/controllers/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/data/models/post_model.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contenido:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: 'Escribe algo...'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Text('URL de Imagen:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(hintText: 'Opcional: URL de la imagen'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _createPost();
              },
              child: const Text('Crear Publicación'),
            ),
          ],
        ),
      ),
    );
  }

  void _createPost() {
    final content = _contentController.text;
    final imageUrl = _imageUrlController.text;

    if (content.isEmpty) {
      return;
    }

    final newPost = PostModel(
      content: content,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
      type: 'General', // Puedes agregar un tipo de publicación
      createdAt: DateTime.now(), authorId: '', likes: [], comments: [],
    );

    // Usar el controlador para crear la publicación
    ref.read(postControllerProvider).createPost(newPost);

    // Regresar a la página anterior
    Navigator.pop(context);
  }
}
