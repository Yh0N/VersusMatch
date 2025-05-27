import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:versus_match/data/repositories/auth_repository.dart';
import 'package:versus_match/data/repositories/challenge_repository.dart';
import 'package:versus_match/data/repositories/chat_repository.dart';
import 'package:versus_match/data/repositories/user_repository.dart';
import 'package:versus_match/data/repositories/post_repository.dart';

final clientProvider = Provider<Client>((ref) {
  return Client()
    ..setEndpoint('https://cloud.appwrite.io/v1')
    ..setProject('680e6eac0019ea6300d2');
});

final accountProvider = Provider<Account>((ref) {
  final client = ref.watch(clientProvider);
  return Account(client);
});

final teamsProvider = FutureProvider((ref) async {
  final account = ref.read(accountProvider);
  return await account.get();
});

final currentUserProvider = FutureProvider((ref) async {
  final account = ref.read(accountProvider);
  return await account.get();
});

final dbProvider = Provider<Databases>((ref) {
  final client = ref.watch(clientProvider);
  return Databases(client);
});

final storageProvider = Provider<Storage>((ref) {
  final client = ref.watch(clientProvider);
  return Storage(client);
});

// Repositorios
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final account = ref.watch(accountProvider);
  return AuthRepository(account);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(dbProvider);
  final account = ref.watch(accountProvider);
  return UserRepository(db, account);
});



final challengesRepositoryProvider = Provider<ChallengesRepository>((ref) {
  final db = ref.watch(dbProvider);
  return ChallengesRepository(db);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(dbProvider);
  return ChatRepository(db);
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final db = ref.watch(dbProvider);
  return PostRepository(db);
});
