import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AuthRepository {
  final Account _account;

  AuthRepository(this._account);

  Future<User> getCurrentUser() async {
    try {
      return await _account.get();
    } catch (e) {
      rethrow;
    }
  }

  Future<Session> login({required String email, required String password}) async {
    try {
      return await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (e) {
      rethrow;
    }
  }

  Future<User> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      // 1. Crear usuario
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: username,
      );

      // 2. Iniciar sesión automáticamente
      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      // 3. Obtener datos del usuario
      return await _account.get();
    } catch (e) {
      rethrow;
    }
  }
}
