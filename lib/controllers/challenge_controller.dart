import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/challenge_model.dart';
import 'package:versus_match/data/repositories/challenge_repository.dart';


final challengeControllerProvider = Provider((ref) {
  final repo = ref.read(challengeRepositoryProvider);
  return ChallengeController(repo);
});

class ChallengeController {
  final ChallengeRepository _repo;

  ChallengeController(this._repo);

  Future<void> sendChallenge(ChallengeModel challenge) {
    return _repo.createChallenge(challenge);
  }

  Future<List<ChallengeModel>> getChallengesForTeam(String teamId) {
    return _repo.getChallengesByTeam(teamId);
  }

  Future<void> updateChallengeStatus(String challengeId, String status) {
    return _repo.updateChallengeStatus(challengeId, status);
  }
}
