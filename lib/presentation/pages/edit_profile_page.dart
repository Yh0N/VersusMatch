import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/user_model.dart';
import 'package:appwrite/appwrite.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController teamIdController;
  late TextEditingController positionController;
  File? _imageFile;
  String? _avatarUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.username);
    teamIdController = TextEditingController(text: widget.user.teamId ?? '');
    positionController = TextEditingController(text: widget.user.position ?? '');
    _avatarUrl = widget.user.avatarUrl;
  }

  @override
  void dispose() {
    usernameController.dispose();
    teamIdController.dispose();
    positionController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  Future<String?> uploadImage(File file) async {
  final storage = ref.read(storageProvider);
  final bucketId = '6824089f00254a004c46'; // Tu bucket real
  final fileId = ID.unique();
  final result = await storage.createFile(
    bucketId: bucketId,
    fileId: fileId,
    file: InputFile.fromPath(path: file.path),
  );
  // Usa el endpoint y projectId de tu constante
  return '${AppwriteConstants.endpoint}/storage/buckets/$bucketId/files/${result.$id}/view?project=${AppwriteConstants.projectId}';
}

  Future<void> saveProfile() async {
    setState(() => isLoading = true);
    String? avatarUrl = _avatarUrl;
    if (_imageFile != null) {
      avatarUrl = await uploadImage(_imageFile!);
    }
    final userRepo = ref.read(userRepositoryProvider);
    final updatedUser = UserModel(
      id: widget.user.id,
      username: usernameController.text.trim(),
      email: widget.user.email,
      teamId: teamIdController.text.trim().isEmpty ? null : teamIdController.text.trim(),
      position: positionController.text.trim().isEmpty ? null : positionController.text.trim(),
      avatarUrl: avatarUrl,
    );
    await userRepo.updateUser(updatedUser);
    if (mounted) {
      Navigator.pop(context, updatedUser);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageFile != null
        ? FileImage(_imageFile!)
        : (_avatarUrl != null && _avatarUrl!.isNotEmpty
            ? NetworkImage(_avatarUrl!)
            : const AssetImage('assets/default_avatar.png') as ImageProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Foto de perfil editable
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: imageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit, size: 18, color: Colors.blue),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Nombre de usuario'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: teamIdController,
              decoration: const InputDecoration(labelText: 'Equipo'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: positionController,
              decoration: const InputDecoration(labelText: 'Posición'),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: saveProfile,
                    child: const Text('Guardar cambios'),
                  ),
          ],
        ),
      ),
    );
  }
}