import 'package:flutter/material.dart';

class TeamCard extends StatelessWidget {
  final String teamName;
  final String logoUrl;
  final String location;
  final int membersCount;

  const TeamCard({
    required this.teamName,
    required this.logoUrl,
    required this.location,
    required this.membersCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(logoUrl),
          radius: 30,
        ),
        title: Text(
          teamName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ubicación: $location'),
            Text('Miembros: $membersCount'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            // Navegar al perfil del equipo
          },
        ),
      ),
    );
  }
}
