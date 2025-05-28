import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:versus_match/controllers/team_controller.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/services/location_service.dart';

class CreateTeamPage extends ConsumerStatefulWidget {
  const CreateTeamPage({Key? key}) : super(key: key);
  static const routeName = '/create-team';

  @override
  ConsumerState<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends ConsumerState<CreateTeamPage> {
  final _teamNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _logoImageFile;
  bool _isLoading = false;
  bool _openToJoin = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickLogoFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _logoImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar imagen: $e')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    final locationService = LocationService();
    final position = await locationService.getCurrentLocation();
    if (position != null) {
      setState(() {
        _locationController.text = '${position.latitude},${position.longitude}';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener la ubicación')),
      );
    }
  }

  Future<void> _createTeam() async {
    final name = _teamNameController.text.trim();
    final location = _locationController.text.trim();
    final description = _descriptionController.text.trim();

    final user = ref.read(currentUserProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener el usuario actual')),
      );
      return;
    }
    final String userId = user.$id;

    if (name.isEmpty || location.isEmpty || _logoImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre, ubicación y logo son obligatorios')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Usamos el método que crea el equipo y une al usuario automáticamente
      await ref.read(teamControllerProvider).createTeamWithLogoAndJoinUser(
        logoFile: _logoImageFile!,
        name: name,
        location: location,
        description: description.isNotEmpty ? description : null,
        createdBy: userId,
        openToJoin: _openToJoin,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Equipo creado y te uniste automáticamente')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear equipo: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Equipo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamNameController,
              decoration: const InputDecoration(labelText: 'Nombre del equipo'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(labelText: 'Ubicación'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.my_location),
                  label: const Text('Ubicación actual'),
                  onPressed: _getCurrentLocation,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ],
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _openToJoin,
                  onChanged: (value) {
                    setState(() {
                      _openToJoin = value ?? false;
                    });
                  },
                ),
                const Text('Abierto a nuevos jugadores'),
              ],
            ),
            if (_logoImageFile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _logoImageFile!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ElevatedButton.icon(
              onPressed: _pickLogoFromGallery,
              icon: const Icon(Icons.image),
              label: const Text('Seleccionar logo desde galería'),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _createTeam,
                    child: const Text('Crear Equipo'),
                  ),
          ],
        ),
      ),
    );
  }
}