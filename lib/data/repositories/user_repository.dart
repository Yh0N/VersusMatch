import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/user_model.dart';


class UserRepository {
  final Databases _db;

  UserRepository(this._db);

  Future<void> createUserDoc(UserModel user) {
    return _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: user.id,
      data: user.toMap(),
    );
  }

  Future<UserModel> getUserById(String id) async {
    final doc = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: id,
    );
    return UserModel.fromMap(doc.data);
  }
}
