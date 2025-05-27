import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/challenge_model.dart';

class ChallengesRepository {
  final Databases _db;

  ChallengesRepository(this._db);

  Future<void> createChallenge(ChallengeModel challenge) async {
    await _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.challengesCollectionId,
      documentId: ID.unique(),
      data: challenge.toMap(),
    );
  }

  // Obtiene los retos en los que participa el equipo (como emisor o receptor)
  Future<List<ChallengeModel>> getChallengesByTeam(String teamId) async {
    final result = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.challengesCollectionId,
      queries: [
        Query.or([
          Query.equal('fromTeamId', teamId),
          Query.equal('toTeamId', teamId),
        ]),
      ],
    );

    return result.documents
        .map((doc) => ChallengeModel.fromMap(doc.data))
        .toList();
  }

  Future<void> updateChallengeStatus(String id, String status) async {
    await _db.updateDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.challengesCollectionId,
      documentId: id,
      data: {
        'status': status,
        'responseDate': DateTime.now().toIso8601String(),
      },
    );
  }

  // Obtener todos los desafíos (por si luego quieres mostrar una lista global)
  Future<List<ChallengeModel>> getAllChallenges() async {
    final result = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.challengesCollectionId,
    );

    return result.documents
        .map((doc) => ChallengeModel.fromMap(doc.data))
        .toList();
  }
}
