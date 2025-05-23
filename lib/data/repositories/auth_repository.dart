import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AuthRepository {
  final Account _account;

  AuthRepository(this._account);

  Future<User> getCurrentUser() => _account.get();

  Future<Session> login({required String email, required String password}) {
    return _account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  Future<void> logout() {
    return _account.deleteSession(sessionId: 'current');

  }

  Future<User> register({
    required String email,
    required String password,
    required String username,
  }) async {
    // 1. Crear usuario en Auth
    await _account.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: username,
    );

    // 2. Crear sesión
    await _account.createEmailPasswordSession(email: email, password: password);

    // 3. Obtener usuario con su $id
    return await _account.get();
  }
}
