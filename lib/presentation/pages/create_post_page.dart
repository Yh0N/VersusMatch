import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:versus_match/controllers/post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/data/models/post_model.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;
  String postType = 'text';

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

    final user = await ref.read(currentUserProvider.future);
    final authorId = user.$id;

    final newPost = PostModel(
      id: '',
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
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tipo de publicación:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 6),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.deepPurple.withOpacity(0.08),
                child: DropdownButtonFormField<String>(
                  value: postType,
                  decoration: InputDecoration(
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  ),
                  items: <String>['text', 'challenge'] // Solo text y challenge
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value[0].toUpperCase() + value.substring(1)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      postType = newValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 18),
              const Text('Contenido:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 6),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.deepPurple.withOpacity(0.08),
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Escribe algo...',
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  ),
                  maxLines: 4,
                ),
              ),
              const SizedBox(height: 18),
              const Text('Imagen:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              const SizedBox(height: 6),
              if (_selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(_selectedImage!, height: 180),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.deepPurple),
                  label: const Text('Seleccionar desde galería', style: TextStyle(color: Colors.deepPurple)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.deepPurple.withOpacity(0.2)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _createPost,
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    'Crear Publicación',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}