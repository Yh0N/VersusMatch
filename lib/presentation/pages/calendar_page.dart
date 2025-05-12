import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Aquí puedes agregar un calendario real o una lista de partidos
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Reemplazar con cantidad real de eventos
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Text('Partido ${index + 1}'),
                      subtitle: Text('Fecha: 12/12/2025'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
