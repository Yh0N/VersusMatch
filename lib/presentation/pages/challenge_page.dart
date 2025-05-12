import 'package:flutter/material.dart';

class ChallengePage extends StatelessWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desafíos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Mostrar lista de desafíos
            ListView.builder(
              itemCount: 5, // Reemplazar con cantidad real
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text('Desafío ${index + 1}'),
                    subtitle: Text('Equipo A vs Equipo B'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        // Navegar a los detalles del desafío
                      },
                    ),
                  ),
                );
              },
            ),
            // Botón para crear un nuevo desafío
            ElevatedButton(
              onPressed: () {
                // Navegar a la página de crear desafío
                Navigator.pushNamed(context, '/create_challenge');
              },
              child: const Text('Crear Nuevo Desafío'),
            ),
          ],
        ),
      ),
    );
  }
}
