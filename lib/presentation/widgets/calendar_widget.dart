import 'package:flutter/material.dart';

class CalendarWidget extends StatelessWidget {
  final List<Map<String, dynamic>> events; // Lista de eventos

  const CalendarWidget({required this.events, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(
              event['title'],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text('Fecha: ${event['date'].toLocal()}'),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                // Navegar a los detalles del evento
              },
            ),
          ),
        );
      },
    );
  }
}
