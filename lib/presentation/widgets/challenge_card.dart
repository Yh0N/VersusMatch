import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final String fromTeamName;
  final String toTeamName;
  final DateTime date;
  final String status; // Puede ser "pendiente", "aceptado", etc.

  const ChallengeCard({
    required this.fromTeamName,
    required this.toTeamName,
    required this.date,
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(
          '$fromTeamName vs $toTeamName',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${date.toLocal()}'),
            Text('Estado: $status'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // Navegar a los detalles del desafío
          },
        ),
      ),
    );
  }
}
