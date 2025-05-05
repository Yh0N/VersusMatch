// lib/controllers/auth_controller.dart
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/auth_repository.dart';
import 'package:appwrite/models.dart' as models;

final authControllerProvider = Provider<AuthController>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return AuthController(repo);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // reemplaza con tu endpoint
    ..setProject('YOUR_PROJECT_ID'); // reemplaza con tu ID de proyecto
  return AuthRepository(Account(client));
});

class AuthController {
  final AuthRepository _repository;

  AuthController(this._repository);

  Future<models.User?> getCurrentUser() => _repository.getCurrentUser();

  Future<void> signUp(String email, String password, String name) =>
      _repository.signUp(email: email, password: password, name: name);

  Future<models.Session> signIn(String email, String password) =>
      _repository.signIn(email: email, password: password);

  Future<void> logout() => _repository.logout();
}