import 'package:flutter/material.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});

  @override
  _CreateTeamPageState createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final _teamNameController = TextEditingController();
  final _locationController = TextEditingController();

  void _createTeam() {
    // Lógica para crear el equipo
    final teamName = _teamNameController.text;
    final location = _locationController.text;

    if (teamName.isNotEmpty && location.isNotEmpty) {
      // Llamar a la API de Appwrite para crear el equipo
      // Después navegar a la pantalla de perfil del equipo o a home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Equipo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _teamNameController,
              decoration: const InputDecoration(labelText: 'Nombre del equipo'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Ubicación'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createTeam,
              child: const Text('Crear Equipo'),
            ),
          ],
        ),
      ),
    );
  }
}
