import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/user_model.dart';

class UserRepository {
  final Databases _db;
  final Account _account;

  UserRepository(this._db, this._account);

  // Crea el documento del usuario personalizado
  Future<void> createUserDoc(UserModel user) {
    return _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: user.id,
      data: user.toMap(),
    );
  }

  // Obtiene documento del usuario personalizado
  Future<UserModel> getUserById(String id) async {
    final doc = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: id,
    );
    return UserModel.fromMap(doc.data);
  }

  // 🆕 Obtiene el usuario autenticado desde la cuenta de Appwrite
  Future<UserModel?> getCurrentUserData() async {
    try {
      final sessionUser = await _account.get(); // Appwrite user
      final userId = sessionUser.$id;

      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userId,
      );

      return UserModel.fromMap(doc.data);
    } catch (e) {
      print('Error getting current user data: $e');
      return null;
    }
  }
}
