import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/challenge_model.dart';


class ChallengePage extends ConsumerWidget {
  const ChallengePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeRepo = ref.read(challengesRepositoryProvider);
    const teamId = 'TU_TEAM_ID'; // <-- reemplázalo con el ID real del equipo

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
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
            return const Center(child: Text('No challenges found.'));
          }

          return ListView.builder(
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];

              return ListTile(
                title: Text('From: ${challenge.fromTeamId} → To: ${challenge.toTeamId}'),
                subtitle: Text('Status: ${challenge.status}'),
                trailing: challenge.status == 'pending'
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () async {
                              await challengeRepo.updateChallengeStatus(challenge.id, 'accepted');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Challenge accepted')),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () async {
                              await challengeRepo.updateChallengeStatus(challenge.id, 'rejected');
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Challenge rejected')),
                                );
                              }
                            },
                          ),
                        ],
                      )
                    : const Text('Responded'),
              );
            },
          );
        },
      ),
    );
  }
}
