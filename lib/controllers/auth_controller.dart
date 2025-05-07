import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/repositories/auth_repository.dart';

// Provider de AuthController
final authControllerProvider = Provider((ref) {
  final repo = ref.read(authRepositoryProvider);
  final db = ref.read(dbProvider);
  return AuthController(repo, db);
});

class AuthController {
  final AuthRepository _repo;
  final Databases _db;

  AuthController(this._repo, this._db);

  // Obtiene el usuario actual
  Future<User> getCurrentUser() => _repo.getCurrentUser();

  // Inicia sesión con email y contraseña
  Future<Session> login(String email, String password) =>
      _repo.login(email: email, password: password);

  // Cierra sesión
  Future<void> logout() => _repo.logout();

  // Registra un nuevo usuario
  Future<User> register(String email, String password, String username) async {
    // Crea el usuario en Appwrite
    final user = await _repo.register(
      email: email,
      password: password,
      username: username,
    );

    // Crear el documento en la colección "users"
    await _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
      documentId: user.$id,
      data: {
        'email': email,            // Se incluye el email
        'username': username,      // Se incluye el username
        'teamId': null,            // Valor por defecto en null
        'position': null,          // Valor por defecto en null
      },
      permissions: [
        Permission.read(Role.user(user.$id)),
        Permission.update(Role.user(user.$id)),
        Permission.delete(Role.user(user.$id)),
      ],
    );

    return user;
  }
}
