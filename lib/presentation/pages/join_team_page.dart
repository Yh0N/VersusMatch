import 'package:flutter/material.dart';

class JoinTeamPage extends StatelessWidget {
  const JoinTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unirse a un Equipo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Buscar equipos
            TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar equipo',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            // Mostrar equipos disponibles
            ListView.builder(
              itemCount: 5, // Reemplazar con cantidad real de equipos disponibles
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Equipo ${index + 1}'),
                  subtitle: Text('Ubicación: Ciudad XYZ'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Unirse al equipo
                    },
                    child: const Text('Unirse'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
