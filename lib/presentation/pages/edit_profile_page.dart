import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/user_model.dart';
import 'package:versus_match/data/models/team_model.dart';
import 'package:appwrite/appwrite.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController positionController;
  File? _imageFile;
  String? _avatarUrl;
  bool isLoading = false;

  String? selectedTeamId;
  List<TeamModel> teams = [];

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.username);
    positionController = TextEditingController(text: widget.user.position ?? '');
    _avatarUrl = widget.user.avatarUrl;
    selectedTeamId = widget.user.teamId;
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    final teamRepo = ref.read(teamRepositoryProvider);
    final fetchedTeams = await teamRepo.getAllTeams();
    setState(() {
      teams = fetchedTeams;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
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
      teamId: selectedTeamId,
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

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Foto de perfil editable
              GestureDetector(
                onTap: pickImage,
                child: Material(
                  elevation: 5,
                  shape: const CircleBorder(),
                  shadowColor: Colors.deepPurple.withOpacity(0.15),
                  child: CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.deepPurple.withOpacity(0.08),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: imageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, size: 18, color: Colors.deepPurple),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.deepPurple.withOpacity(0.08),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    prefixIcon: const Icon(Icons.person, color: Colors.deepPurple),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.deepPurple.withOpacity(0.08),
                child: DropdownButtonFormField<String>(
                  value: selectedTeamId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Equipo',
                    prefixIcon: const Icon(Icons.groups, color: Colors.deepPurple),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('Sin equipo'),
                    ),
                    ...teams.map((team) => DropdownMenuItem<String>(
                          value: team.id,
                          child: Text(team.name),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedTeamId = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 14),
              Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.deepPurple.withOpacity(0.08),
                child: TextField(
                  controller: positionController,
                  decoration: InputDecoration(
                    labelText: 'Posición',
                    prefixIcon: const Icon(Icons.sports_soccer, color: Colors.deepPurple),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: saveProfile,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Guardar cambios',
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