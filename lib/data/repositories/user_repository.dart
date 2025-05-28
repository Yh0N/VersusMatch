import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/user_model.dart';

class UserRepository {
  final Databases _db;
  final Account _account;

  UserRepository(this._db, this._account);

  /// Crea el documento del usuario personalizado
  Future<void> createUserDoc(UserModel user) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.id,
        data: user.toMap(),
      );
      print('✅ Usuario creado exitosamente');
    } catch (e) {
      print('❌ Error creando usuario: $e');
      rethrow;
    }
  }

  /// Obtiene documento del usuario personalizado
  Future<UserModel> getUserById(String id) async {
    try {
      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: id,
      );
      return UserModel.fromMap(doc.data);
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      rethrow;
    }
  }

  /// Obtiene el usuario autenticado desde la cuenta de Appwrite
  Future<UserModel?> getCurrentUserData() async {
    try {
      final sessionUser = await _account.get();
      final userId = sessionUser.$id;

      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userId,
      );

      return UserModel.fromMap(doc.data);
    } catch (e) {
      print('❌ Error obteniendo usuario actual: $e');
      return null;
    }
  }

  /// Actualiza el equipo del usuario (ahora acepta null)
  Future<void> updateUserTeam(String userId, String? teamId) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userId,
        data: {
          'teamId': teamId,
        },
      );
      print('✅ Equipo del usuario actualizado correctamente');
    } catch (e) {
      print('❌ Error actualizando equipo del usuario: $e');
      rethrow;
    }
  }

  /// Actualiza toda la información del usuario
  Future<void> updateUser(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.id,
        data: user.toMap(),
      );
      print('✅ Usuario actualizado correctamente');
    } catch (e) {
      print('❌ Error actualizando usuario: $e');
      rethrow;
    }
  }

  /// Verifica si un usuario existe
  Future<bool> userExists(String userId) async {
    try {
      await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Elimina un usuario
  Future<void> deleteUser(String userId) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userId,
      );
      print('✅ Usuario eliminado correctamente');
    } catch (e) {
      print('❌ Error eliminando usuario: $e');
      rethrow;
    }
  }
}