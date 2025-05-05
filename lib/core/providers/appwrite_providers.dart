import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import 'package:versus_match/data/repositories/auth_repository.dart';
import 'package:versus_match/data/repositories/challenge_repository.dart';
import 'package:versus_match/data/repositories/chat_repository.dart';
import 'package:versus_match/data/repositories/team_repository.dart';
import 'package:versus_match/data/repositories/user_repository.dart';


final clientProvider = Provider<Client>((ref) {
  return Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // O tu endpoint
    ..setProject('65ea6e1c9f5b2f7c1a34'); // O tu project ID
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

// Agregamos ChallengeRepository y ChatRepository
final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  final db = ref.watch(dbProvider);
  return ChallengeRepository(db);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final db = ref.watch(dbProvider);
  return ChatRepository(db);
});
