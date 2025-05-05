import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/user_model.dart';
import 'package:versus_match/data/repositories/user_repository.dart';


final userControllerProvider = Provider((ref) {
  final repo = ref.read(userRepositoryProvider);
  return UserController(repo);
});

class UserController {
  final UserRepository _repo;

  UserController(this._repo);

  Future<void> createUser(UserModel user) => _repo.createUserDoc(user);
  Future<UserModel> getUser(String id) => _repo.getUserById(id);
}
