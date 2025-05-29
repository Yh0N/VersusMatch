import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:versus_match/controllers/team_controller.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/services/location_service.dart';
import 'package:versus_match/presentation/widgets/team_form.dart';

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
      appBar: AppBar(
        title: const Text('Crear Equipo', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: TeamForm(
          nameController: _teamNameController,
          locationController: _locationController,
          descriptionController: _descriptionController,
          onPickLogo: _pickLogoFromGallery,
          onGetLocation: _getCurrentLocation,
          onSubmit: _createTeam,
          isLoading: _isLoading,
          logoImageFile: _logoImageFile,
          openToJoin: _openToJoin,
          onOpenToJoinChanged: (v) => setState(() => _openToJoin = v ?? false),
        ),
      ),
    );
  }
}