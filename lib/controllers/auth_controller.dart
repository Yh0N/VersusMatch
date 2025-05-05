import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/repositories/auth_repository.dart';
import 'package:appwrite/models.dart';

final authControllerProvider = Provider((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});

class AuthController {
  final AuthRepository _repo;

  AuthController(this._repo);

  Future<User> getCurrentUser() => _repo.getCurrentUser();
  Future<Session> login(String email, String password) => _repo.login(email: email, password: password);
  Future<void> logout() => _repo.logout();
  Future<User> register(String email, String password, String username) =>
      _repo.register(email: email, password: password, username: username);
}
