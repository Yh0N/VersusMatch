import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:versus_match/controllers/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/data/models/post_model.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart'; // 👈 Necesario para acceder a currentUserProvider

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;
  String postType = 'text'; // Valor por defecto

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<void> _createPost() async {
    final content = _contentController.text;
    if (content.isEmpty) return;

    String? uploadedImageUrl;

    if (_selectedImage != null) {
      uploadedImageUrl = await ref.read(postControllerProvider).uploadImage(_selectedImage!);
    }

    // ✅ Obtener el ID del usuario actual
    final user = await ref.read(currentUserProvider.future);
    final authorId = user.$id;

    final newPost = PostModel(
      id: '', // <--- agrega esto, Appwrite lo asignará al guardar
      content: content,
      imageUrl: uploadedImageUrl,
      type: postType,
      createdAt: DateTime.now(),
      authorId: authorId,
      likes: [],
      comments: [],
    );

    await ref.read(postControllerProvider).createPost(newPost);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tipo de publicación:', style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: postType,
                onChanged: (String? newValue) {
                  setState(() {
                    postType = newValue!;
                  });
                },
                items: <String>['text', 'challenge', 'update']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Contenido:', style: TextStyle(fontSize: 16)),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(hintText: 'Escribe algo...'),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              const Text('Imagen:', style: TextStyle(fontSize: 16)),
              if (_selectedImage != null)
                Image.file(_selectedImage!, height: 200),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Seleccionar desde galería'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createPost,
                child: const Text('Crear Publicación'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
