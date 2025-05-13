import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:versus_match/data/repositories/auth_repository.dart';
import 'package:versus_match/data/repositories/challenge_repository.dart';
import 'package:versus_match/data/repositories/chat_repository.dart';
import 'package:versus_match/data/repositories/team_repository.dart';
import 'package:versus_match/data/repositories/user_repository.dart';
import 'package:versus_match/data/repositories/post_repository.dart';

final clientProvider = Provider<Client>((ref) {
  return Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // O tu endpoint real
    ..setProject('680e6eac0019ea6300d2'); // O tu Project ID real
});

final accountProvider = Provider<Account>((ref) {
  final client = ref.watch(clientProvider);
  return Account(client);
});

final dbProvider = Provider<Databases>((ref) {
  final client = ref.watch(clientProvider);
  return Databases(client);
});

// Repositorios
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final account = ref.watch(accountProvider);
  return AuthRepository(account);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.watch(dbProvider);
  return UserRepository(db);
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final db = ref.watch(dbProvider);
  return TeamRepository(db);
});

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  final db = ref.watch(dbProvider);
  return ChallengeRepository(db);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(dbProvider);
  return ChatRepository(db);
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final db = ref.watch(dbProvider);
  return PostRepository(db);
});
