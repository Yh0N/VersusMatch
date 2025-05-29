import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unirse a un Equipo', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(16),
              shadowColor: Colors.deepPurple.withOpacity(0.08),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Buscar equipo',
                  prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                  border: border,
                  enabledBorder: border,
                  focusedBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                ),
                onChanged: (val) => setState(() => _search = val),
              ),
            ),
            const SizedBox(height: 20),
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

                  return ListView.separated(
                    itemCount: equiposFiltrados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final team = equiposFiltrados[index];
                      return Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(16),
                        shadowColor: Colors.deepPurple.withOpacity(0.08),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.withOpacity(0.15),
                            child: const Icon(Icons.groups, color: Colors.deepPurple),
                          ),
                          title: Text(
                            team.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          subtitle: Text('Ubicación: ${team.location}'),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              final user = await account.get();
                              await teamRepo.addMemberToTeam(team.id, user.$id);
                              await userRepo.updateUserTeam(user.$id, team.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('¡Te uniste a ${team.name}!')),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              elevation: 1,
                            ),
                            child: const Text(
                              'Unirse',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.05,
                              ),
                            ),
                          ),
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