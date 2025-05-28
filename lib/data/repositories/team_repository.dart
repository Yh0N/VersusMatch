import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/team_model.dart';

class TeamRepository {
  final Databases _db;

  TeamRepository(this._db);

  /// Crea un documento (equipo) en la base de datos Appwrite (sin retorno)
  Future<void> createTeam(TeamModel team) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        documentId: ID.unique(),
        data: team.toMap(),
      );
      print('🟢 Equipo creado exitosamente');
    } catch (e) {
      print('❌ Error al crear equipo: $e');
      rethrow;
    }
  }

  /// Crea un equipo y retorna el documento creado (para obtener el ID)
  Future<Document> createTeamAndReturnDoc(TeamModel team) async {
    try {
      final doc = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        documentId: ID.unique(),
        data: team.toMap(),
      );
      print('🟢 Equipo creado exitosamente');
      return doc;
    } catch (e) {
      print('❌ Error al crear equipo: $e');
      rethrow;
    }
  }

  /// Obtiene todos los equipos
  Future<List<TeamModel>> getAllTeams() async {
    try {
      final result = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        queries: [Query.orderDesc('\$createdAt')],
      );
      return result.documents
          .map((doc) => TeamModel.fromMap(doc.data, documentId: doc.$id))
          .toList();
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
      return TeamModel.fromMap(doc.data, documentId: doc.$id);
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

  /// Actualiza un equipo
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

  /// Agrega un miembro al equipo
  Future<void> addMemberToTeam(String teamId, String userId) async {
    try {
      final team = await getTeamById(teamId);
      final List<String> updatedMembers = List<String>.from(team.members);
      if (!updatedMembers.contains(userId)) {
        updatedMembers.add(userId);
        await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.teamsCollectionId,
          documentId: teamId,
          data: {
            'members': updatedMembers,
          },
        );
        print('👥 Miembro agregado al equipo correctamente. ID: $userId');
        // Verificación
        final updatedTeam = await getTeamById(teamId);
        print('📊 Miembros actuales: ${updatedTeam.members}');
      } else {
        print('⚠️ El usuario ya es miembro del equipo.');
      }
    } catch (e) {
      print('❌ Error al agregar miembro: $e');
      rethrow;
    }
  }

  /// Remueve un miembro del equipo
  Future<void> removeMemberFromTeam(String teamId, String userId) async {
    try {
      final team = await getTeamById(teamId);
      if (team.members.contains(userId)) {
        final List<String> updatedMembers = team.members.where((id) => id != userId).toList();
        await updateTeam(teamId, {'members': updatedMembers});
        print('🚫 Miembro removido del equipo correctamente');
      }
    } catch (e) {
      print('❌ Error al remover miembro: $e');
      rethrow;
    }
  }

  /// Obtiene todos los miembros de un equipo
  Future<List<String>> getTeamMembers(String teamId) async {
    try {
      final team = await getTeamById(teamId);
      return team.members;
    } catch (e) {
      print('❌ Error al obtener miembros: $e');
      return [];
    }
  }

  /// Verifica si un usuario es miembro del equipo
  Future<bool> isUserTeamMember(String teamId, String userId) async {
    try {
      final team = await getTeamById(teamId);
      return team.members.contains(userId);
    } catch (e) {
      print('❌ Error al verificar membresía: $e');
      return false;
    }
  }

  /// Debug: Imprime el estado actual del equipo
  Future<void> debugTeamState(String teamId) async {
    try {
      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.teamsCollectionId,
        documentId: teamId,
      );
      print('🔍 Debug Team State:');
      print('Team ID: $teamId');
      print('Raw data: ${doc.data}');
      print('Members: ${doc.data['members']}');
    } catch (e) {
      print('❌ Debug error: $e');
    }
  }
}