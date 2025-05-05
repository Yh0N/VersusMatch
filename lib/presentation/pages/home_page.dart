// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as models;
import '../../controllers/auth_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos cercanos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authControllerProvider).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyTeams.length,
        itemBuilder: (context, index) {
          final team = dummyTeams[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(team.logoUrl),
              ),
              title: Text(team.name),
              subtitle: Text('Ubicación: ${team.location}'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Lógica para retar al equipo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Has retado a ${team.name}')),
                  );
                },
                child: const Text('Retar'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Team {
  final String name;
  final String location;
  final String logoUrl;

  Team({required this.name, required this.location, required this.logoUrl});
}

final dummyTeams = [
  Team(name: 'Furia FC', location: 'Bogotá', logoUrl: 'https://i.imgur.com/1A3ZQWd.png'),
  Team(name: 'Águilas Doradas', location: 'Medellín', logoUrl: 'https://i.imgur.com/eB9Yxmp.png'),
  Team(name: 'Tigres Urbanos', location: 'Cali', logoUrl: 'https://i.imgur.com/oO4Jmws.png'),
];