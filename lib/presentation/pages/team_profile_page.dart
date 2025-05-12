import 'package:flutter/material.dart';

class TeamProfilePage extends StatelessWidget {
  const TeamProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Equipo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aquí irían los datos del equipo, como nombre, logo, etc.
            Text('Nombre del equipo', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 8),
            Text('Ubicación: Ciudad XYZ'),
            SizedBox(height: 8),
            Text('Miembros: 10'),
            SizedBox(height: 16),

            // Sección de editar equipo
            ElevatedButton(
              onPressed: () {
                // Navegar a la página para editar el equipo
                Navigator.pushNamed(context, '/edit_team');
              },
              child: const Text('Editar Equipo'),
            ),
          ],
        ),
      ),
    );
  }
}
