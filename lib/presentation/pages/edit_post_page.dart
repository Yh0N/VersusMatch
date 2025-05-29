import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/data/models/post_model.dart';
import 'package:versus_match/controllers/post_controller.dart';

class EditPostPage extends ConsumerStatefulWidget {
  final PostModel post;
  const EditPostPage({super.key, required this.post});

  @override
  ConsumerState<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends ConsumerState<EditPostPage> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.post.content);
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(postControllerProvider).updatePost(
      widget.post.id,
      {'content': _contentController.text},
    );
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar publicación', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'Edita el contenido de tu publicación',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(18),
                shadowColor: Colors.deepPurple.withOpacity(0.08),
                child: TextField(
                  controller: _contentController,
                  maxLines: 6,
                  minLines: 3,
                  style: const TextStyle(fontSize: 17),
                  decoration: InputDecoration(
                    labelText: 'Contenido',
                    labelStyle: const TextStyle(color: Colors.deepPurple),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                    ),
                    prefixIcon: const Icon(Icons.edit, color: Colors.deepPurple),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(18),
                  shadowColor: Colors.deepPurple.withOpacity(0.08),
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.save, color: Colors.deepPurple),
                    label: const Text(
                      'Guardar cambios',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.05,
                        color: Colors.deepPurple,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
                      ),
                      shadowColor: Colors.transparent,
                    ),
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