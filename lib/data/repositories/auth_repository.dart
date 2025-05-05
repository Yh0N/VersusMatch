// lib/data/repositories/auth_repository.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AuthRepository {
  final Account _account;

  AuthRepository(this._account);

  Future<User?> getCurrentUser() async {
    try {
      final user = await _account.get();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> signUp({required String email, required String password, required String name}) async {
    await _account.create(userId: ID.unique(), email: email, password: password, name: name);
  }

  Future<Session> signIn({required String email, required String password}) async {
    return await _account.createEmailSession(email: email, password: password);
  }

  Future<void> logout() async {
    await _account.deleteSession(sessionId: 'current');
  }
}