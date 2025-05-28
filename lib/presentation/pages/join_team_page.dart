import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Usa alias para evitar conflictos de providers
import 'package:versus_match/core/providers/appwrite_providers.dart' as appwrite;
import 'package:versus_match/data/models/team_model.dart';

class JoinTeamPage extends ConsumerStatefulWidget {
  const JoinTeamPage({super.key});

  @override
  ConsumerState<JoinTeamPage> createState() => _JoinTeamPageState();
}

class _JoinTeamPageState extends ConsumerState<JoinTeamPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final teamRepo = ref.read(appwrite.teamRepositoryProvider);
    final userRepo = ref.read(appwrite.userRepositoryProvider);
    final account = ref.read(appwrite.accountProvider);

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
              onChanged: (val) => setState(() => _search = val),
            ),
            const SizedBox(height: 20),
            // Mostrar equipos disponibles
            Expanded(
              child: FutureBuilder<List<TeamModel>>(
                future: teamRepo.getAllTeams(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final equipos = snapshot.data ?? [];
                  final equiposFiltrados = equipos.where((team) =>
                    team.name.toLowerCase().contains(_search.toLowerCase())
                  ).toList();

                  if (equiposFiltrados.isEmpty) {
                    return const Center(child: Text('No hay equipos disponibles.'));
                  }

                  return ListView.builder(
                    itemCount: equiposFiltrados.length,
                    itemBuilder: (context, index) {
                      final team = equiposFiltrados[index];
                      return ListTile(
                        title: Text(team.name),
                        subtitle: Text('Ubicación: ${team.location}'),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            final user = await account.get();
                            // 1. Agrega el usuario al array de miembros del equipo
                            await teamRepo.addMemberToTeam(team.id, user.$id);
                            // 2. Actualiza el usuario para asignarle el equipo
                            await userRepo.updateUserTeam(user.$id, team.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('¡Te uniste a ${team.name}!')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Unirse'),
                        ),
                      );
                    },
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