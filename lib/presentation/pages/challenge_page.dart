import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/challenge_model.dart';
import 'package:versus_match/data/models/team_model.dart';
import 'package:versus_match/data/models/user_model.dart';
import 'package:versus_match/presentation/widgets/challenge_card.dart';
import 'create_challenge_page.dart';

class ChallengePage extends ConsumerStatefulWidget {
  const ChallengePage({super.key});

  static const String routeName = '/challenge';

  @override
  ConsumerState<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends ConsumerState<ChallengePage> {
  Future<void> _refreshChallenges() async {
    setState(() {});
  }

  void _logout(BuildContext context) async {
    final account = ref.read(accountProvider);
    await account.deleteSession(sessionId: 'current');
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.read(accountProvider);
    final userRepo = ref.read(userRepositoryProvider);

    return FutureBuilder(
      future: account.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Retos'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _logout(context),
                  tooltip: 'Salir',
                ),
              ],
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final userId = snapshot.data!.$id;

        return FutureBuilder<UserModel>(
          future: userRepo.getUserById(userId),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (userSnap.hasError || userSnap.data == null) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Retos'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => _logout(context),
                      tooltip: 'Salir',
                    ),
                  ],
                ),
                body: const Center(child: Text('Error cargando el usuario')),
              );
            }

            final user = userSnap.data!;
            final teamId = user.teamId;

            if (teamId == null || teamId.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Retos'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () => _logout(context),
                      tooltip: 'Salir',
                    ),
                  ],
                ),
                body: const Center(
                  child: Text('No estás asignado a un equipo.'),
                ),
              );
            }

            final challengeRepo = ref.read(challengesRepositoryProvider);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Retos'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => _logout(context),
                    tooltip: 'Salir',
                  ),
                ],
              ),
              body: FutureBuilder<List<ChallengeModel>>(
                future: challengeRepo.getChallengesByTeam(teamId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final challenges = snapshot.data ?? [];

                  if (challenges.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nadie te ha retado aún',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshChallenges,
                    child: ListView.builder(
                      itemCount: challenges.length,
                      itemBuilder: (context, index) {
                        final challenge = challenges[index];

                        return FutureBuilder<TeamModel>(
                          future: ref.read(teamRepositoryProvider).getTeamById(challenge.fromTeamId),
                          builder: (context, fromTeamSnap) {
                            if (!fromTeamSnap.hasData) {
                              return const SizedBox.shrink();
                            }
                            return FutureBuilder<TeamModel>(
                              future: ref.read(teamRepositoryProvider).getTeamById(challenge.toTeamId),
                              builder: (context, toTeamSnap) {
                                if (!toTeamSnap.hasData) {
                                  return const SizedBox.shrink();
                                }
                                // Solo el equipo retado puede aceptar/rechazar
                                final canRespond = challenge.toTeamId.trim() == teamId.trim() &&
                                    challenge.status.toLowerCase() == 'pending';
                                return ChallengeCard(
                                  fromTeamName: fromTeamSnap.data!.name,
                                  toTeamName: toTeamSnap.data!.name,
                                  date: challenge.date,
                                  status: challenge.status,
                                  canRespond: canRespond,
                                  onAccept: canRespond
                                      ? () async {
                                          await challengeRepo.updateChallengeStatus(challenge.id, 'accepted');
                                          _refreshChallenges();
                                        }
                                      : null,
                                  onReject: canRespond
                                      ? () async {
                                          await challengeRepo.updateChallengeStatus(challenge.id, 'rejected');
                                          _refreshChallenges();
                                        }
                                      : null,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateChallengePage()),
                  );
                  _refreshChallenges();
                },
                child: const Icon(Icons.add),
                tooltip: 'Crear nuevo reto',
              ),
            );
          },
        );
      },
    );
  }
}