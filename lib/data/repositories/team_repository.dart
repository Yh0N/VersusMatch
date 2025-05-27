import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/team_model.dart';

class TeamRepository {
  final Databases _db;

  TeamRepository(this._db);

  /// Crea un documento (equipo) en la base de datos Appwrite
  Future<void> createTeam(TeamModel team) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        documentId: ID.unique(), // Genera un ID único
        data: team.toMap(),
      );
      print('🟢 Equipo creado exitosamente');
    } catch (e) {
      print('❌ Error al crear equipo: $e');
      rethrow;
    }
  }

  /// Obtiene todos los equipos, ordenados por fecha de creación (descendente)
  Future<List<TeamModel>> getAllTeams() async {
    try {
      final result = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        queries: [
          Query.orderDesc('createdAt'),
        ],
      );
      return result.documents.map((doc) => TeamModel.fromMap(doc.data)).toList();
    } catch (e) {
      print('❌ Error al obtener equipos: $e');
      return [];
    }
  }

  /// Obtiene un equipo por su ID
  Future<TeamModel> getTeamById(String teamId) async {
    try {
      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        documentId: teamId,
      );
      return TeamModel.fromMap(doc.data);
    } catch (e) {
      print('❌ Error al obtener equipo por ID: $e');
      rethrow;
    }
  }

  /// Elimina un equipo por su ID
  Future<void> deleteTeam(String teamId) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        documentId: teamId,
      );
      print('🗑️ Equipo eliminado correctamente');
    } catch (e) {
      print('❌ Error al eliminar equipo: $e');
      rethrow;
    }
  }

  /// Actualiza un equipo con los datos proporcionados
  Future<void> updateTeam(String teamId, Map<String, dynamic> data) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        documentId: teamId,
        data: data,
      );
      print('📝 Equipo actualizado correctamente');
    } catch (e) {
      print('❌ Error al actualizar equipo: $e');
      rethrow;
    }
  }
}