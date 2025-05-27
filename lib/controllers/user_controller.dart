import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/user_model.dart';
import 'package:versus_match/data/repositories/user_repository.dart';
import 'package:versus_match/core/utils/jwt_parser.dart'; // ✅ Importamos el parser

final userControllerProvider = Provider((ref) {
  final repo = ref.read(userRepositoryProvider);
  return UserController(repo);
});

class UserController {
  final UserRepository _repo;

  UserController(this._repo);

  /// Crear un documento de usuario en la base de datos
  Future<void> createUser(UserModel user) => _repo.createUserDoc(user);

  /// Obtener un usuario por su ID
  Future<UserModel> getUser(String id) => _repo.getUserById(id);

  /// ✅ NUEVO: Obtener un usuario a partir del token
  Future<UserModel> getUserFromToken(String token) {
    final payload = parseJwt(token);
    final userId = payload['sub']; // Cambia 'sub' si Appwrite usa otra clave
    return getUser(userId);
  }
}
