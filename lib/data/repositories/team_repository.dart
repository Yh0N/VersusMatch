import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/team_model.dart';


class TeamRepository {
  final Databases _db;

  TeamRepository(this._db);

  Future<void> createTeam(TeamModel team) {
    return _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.teamsCollectionId,
      documentId: ID.unique(),
      data: team.toMap(),
    );
  }

  Future<TeamModel> getTeamById(String id) async {
    final doc = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.teamsCollectionId,
      documentId: id,
    );
    return TeamModel.fromMap(doc.data);
  }

  Future<List<TeamModel>> getAllTeams() async {
    final res = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.teamsCollectionId,
    );
    return res.documents.map((doc) => TeamModel.fromMap(doc.data)).toList();
  }
}
