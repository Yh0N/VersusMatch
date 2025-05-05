import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/team_model.dart';
import 'package:versus_match/data/repositories/team_repository.dart';


final teamControllerProvider = Provider((ref) {
  final repo = ref.read(teamRepositoryProvider);
  return TeamController(repo);
});

class TeamController {
  final TeamRepository _repo;

  TeamController(this._repo);

  Future<void> createTeam(TeamModel team) => _repo.createTeam(team);
  Future<TeamModel> getTeam(String id) => _repo.getTeamById(id);
  Future<List<TeamModel>> getAllTeams() => _repo.getAllTeams();
}
