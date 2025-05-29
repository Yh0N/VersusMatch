import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/team_model.dart';
import 'package:versus_match/data/models/user_model.dart';

class TeamProfilePage extends ConsumerWidget {
  final String teamId;
  const TeamProfilePage({super.key, required this.teamId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamRepo = ref.read(teamRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    return FutureBuilder<TeamModel>(
      future: teamRepo.getTeamById(teamId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final team = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil del Equipo', style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo del equipo
                  Center(
                    child: Material(
                      elevation: 6,
                      shape: const CircleBorder(),
                      shadowColor: Colors.deepPurple.withOpacity(0.15),
                      child: CircleAvatar(
                        radius: 54,
                        backgroundColor: Colors.deepPurple.withOpacity(0.08),
                        backgroundImage: team.logoUrl != null && team.logoUrl!.isNotEmpty
                            ? NetworkImage(team.logoUrl!)
                            : const AssetImage('assets/default_avatar.png') as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    team.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.deepPurple, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        team.location,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (team.description != null && team.description!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        team.description!,
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.groups, color: Colors.deepPurple, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'Miembros: ${team.members.length}',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Lista de miembros',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.deepPurple),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<List<UserModel>>(
                    future: Future.wait(team.members.map((id) => userRepo.getUserById(id))),
                    builder: (context, memberSnap) {
                      if (memberSnap.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final members = memberSnap.data ?? [];
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: members.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final member = members[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: member.avatarUrl != null && member.avatarUrl!.isNotEmpty
                                  ? NetworkImage(member.avatarUrl!)
                                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
                            ),
                            title: Text(member.username),
                            subtitle: Text(member.email),
                            trailing: team.createdBy == member.id
                                ? const Chip(
                                    label: Text('Creador', style: TextStyle(color: Colors.white)),
                                    backgroundColor: Colors.deepPurple,
                                  )
                                : null,
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        const Text(
                          'Creado por: ',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                        FutureBuilder<UserModel>(
                          future: userRepo.getUserById(team.createdBy),
                          builder: (context, creatorSnap) {
                            if (creatorSnap.connectionState == ConnectionState.waiting) {
                              return const Text('...');
                            }
                            if (creatorSnap.hasData) {
                              return Text(
                                creatorSnap.data!.username,
                                style: const TextStyle(color: Colors.black87),
                              );
                            }
                            return const Text('Desconocido');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/edit_team', arguments: team);
                      },
                      icon: const Icon(Icons.edit, color: Colors.deepPurple),
                      label: const Text(
                        'Editar Equipo',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: Colors.deepPurple.withOpacity(0.2)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}