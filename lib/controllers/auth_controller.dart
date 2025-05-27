import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/repositories/auth_repository.dart';
import 'package:versus_match/core/utils/jwt_parser.dart'; // ✅ NUEVA IMPORTACIÓN

final authControllerProvider = Provider((ref) {
  final repo = ref.read(authRepositoryProvider);
  final db = ref.read(dbProvider);
  return AuthController(repo, db);
});

class AuthController {
  final AuthRepository _repo;
  final Databases _db;

  AuthController(this._repo, this._db);

  Future<User> getCurrentUser() => _repo.getCurrentUser();

  Future<Session> login(String email, String password) =>
      _repo.login(email: email, password: password);

  Future<void> logout() => _repo.logout();

  Future<User> register(String email, String password, String username) async {
    final user = await _repo.register(
      email: email,
      password: password,
      username: username,
    );

    await _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: user.$id,
      data: {
        'email': email,
        'username': username,
        'teamId': null,
        'position': null,
      },
      permissions: [
        Permission.read(Role.user(user.$id)),
        Permission.update(Role.user(user.$id)),
        Permission.delete(Role.user(user.$id)),
      ],
    );

    return user;
  }

  // ✅ NUEVO MÉTODO PARA DECODIFICAR JWT
  String extractUserIdFromToken(String token) {
    final payload = parseJwt(token);
    return payload['sub']; // Ajusta esta clave si Appwrite usa otra
  }
}
