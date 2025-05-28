import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/challenge_model.dart';
import 'package:versus_match/data/models/team_model.dart';
import 'package:versus_match/presentation/widgets/rival_and_date_selector.dart';

class CreateChallengePage extends ConsumerStatefulWidget {
  const CreateChallengePage({super.key});

  @override
  ConsumerState<CreateChallengePage> createState() => _CreateChallengePageState();
}

class _CreateChallengePageState extends ConsumerState<CreateChallengePage> {
  String? _toTeamId;
  DateTime? _date;
  String? _message;
  List<TeamModel> _equiposRivales = [];
  bool _loadingEquipos = true;

  @override
  void initState() {
    super.initState();
    _loadEquiposRivales();
  }

  Future<void> _loadEquiposRivales() async {
    final account = ref.read(accountProvider);
    final userRepo = ref.read(userRepositoryProvider);
    final teamRepo = ref.read(teamRepositoryProvider);

    final user = await account.get();
    final userModel = await userRepo.getUserById(user.$id);
    final fromTeamId = userModel.teamId;

    final equipos = await teamRepo.getAllTeams();
    setState(() {
      _equiposRivales = equipos.where((e) => e.id != fromTeamId).toList();
      _loadingEquipos = false;
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _date != null
            ? TimeOfDay(hour: _date!.hour, minute: _date!.minute)
            : TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime combined = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() => _date = combined);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final challengeRepo = ref.read(challengesRepositoryProvider);
    final account = ref.read(accountProvider);
    final userRepo = ref.read(userRepositoryProvider);

    return FutureBuilder(
      future: account.get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final userId = snapshot.data!.$id;
        return FutureBuilder(
          future: userRepo.getUserById(userId),
          builder: (context, userSnap) {
            if (!userSnap.hasData) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            final fromTeamId = userSnap.data!.teamId;
            if (fromTeamId == null) {
              return const Scaffold(body: Center(child: Text('No tienes equipo.')));
            }

            return Scaffold(
              appBar: AppBar(title: const Text('Crear Reto')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    RivalAndDateSelector(
                      equiposRivales: _equiposRivales,
                      selectedTeamId: _toTeamId,
                      selectedDate: _date,
                      onTeamChanged: (val) => setState(() => _toTeamId = val),
                      onDateChanged: (val) => _selectDateTime(context),
                      loadingEquipos: _loadingEquipos,
                    ),
                    const SizedBox(height: 16),
                    Material(
                      elevation: 6,
                      borderRadius: BorderRadius.circular(18),
                      shadowColor: Colors.deepPurple.withOpacity(0.08),
                      child: TextField(
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Mensaje (opcional)',
                          labelStyle: const TextStyle(color: Colors.deepPurple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          prefixIcon: const Icon(Icons.message, color: Colors.deepPurple),
                        ),
                        onChanged: (val) => _message = val,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: (_toTeamId != null && _date != null)
                          ? () async {
                              final challenge = ChallengeModel(
                                id: '',
                                fromTeamId: fromTeamId,
                                toTeamId: _toTeamId!,
                                status: 'pending',
                                date: _date!,
                                message: _message,
                                createdBy: userId,
                                responseDate: null,
                              );
                              await challengeRepo.createChallenge(challenge);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Reto enviado')),
                                );
                                Navigator.pop(context);
                              }
                            }
                          : null,
                      child: const Text('Enviar reto'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}