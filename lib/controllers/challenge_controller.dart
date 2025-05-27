import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/challenge_model.dart';
import 'package:versus_match/data/repositories/challenge_repository.dart';


final challengesControllerProvider = Provider((ref) {
  final repo = ref.read(challengesRepositoryProvider);
  return ChallengesController(repo);
});

class ChallengesController {
  final ChallengesRepository _repo;

  ChallengesController(this._repo);

  // Enviar un nuevo reto
  Future<void> sendChallenge(ChallengeModel challenge) {
    return _repo.createChallenge(challenge);
  }

  // Obtener retos para un equipo (como emisor o receptor)
  Future<List<ChallengeModel>> getChallengesForTeam(String teamId) {
    return _repo.getChallengesByTeam(teamId);
  }

  // Responder un reto (aceptar o rechazar)
  Future<void> respondToChallenge(String challengeId, String status) {
    return _repo.updateChallengeStatus(challengeId, status);
  }
}
