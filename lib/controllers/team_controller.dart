import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/team_model.dart';
import 'package:versus_match/data/repositories/team_repository.dart';
import 'package:versus_match/data/repositories/user_repository.dart';

// Provider para acceder al repositorio de equipos
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final db = ref.read(dbProvider);
  return TeamRepository(db);
});

// Provider para acceder al repositorio de usuario
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final db = ref.read(dbProvider);
  final account = ref.read(accountProvider);
  return UserRepository(db, account);
});

// Provider del controlador de equipos
final teamControllerProvider = Provider<TeamController>((ref) {
  final repo = ref.read(teamRepositoryProvider);
  final storage = ref.read(storageProvider);
  final userRepo = ref.read(userRepositoryProvider);
  return TeamController(repo, storage, userRepo);
});

class TeamController {
  final TeamRepository _repo;
  final Storage _storage;
  final UserRepository _userRepo;

  static const String _bucketId = '6824089f00254a004c46';

  TeamController(this._repo, this._storage, this._userRepo);

  /// Crear un nuevo equipo y unir automáticamente al usuario
  Future<void> createTeamWithLogoAndJoinUser({
    required File logoFile,
    required String name,
    required String location,
    String? description,
    required String createdBy,
    bool? openToJoin,
  }) async {
    final logoUrl = await uploadLogo(logoFile);
    if (logoUrl == null) throw Exception('No se pudo subir el logo');

    final team = TeamModel(
      id: '', // Appwrite generará el ID
      name: name,
      location: location,
      logoUrl: logoUrl,
      members: [createdBy], // Inicializa con el creador
      description: description,
      createdBy: createdBy,
      openToJoin: openToJoin ?? true,
    );

    // 1. Crea el equipo y obtén el documento
    final doc = await _repo.createTeamAndReturnDoc(team);
    final teamId = doc.$id;
    
    // 2. Actualiza el usuario para asignarle el equipo
    await _userRepo.updateUserTeam(createdBy, teamId);
  }

  /// Agregar un miembro al equipo
  Future<void> addMemberToTeam(String teamId, String userId) async {
    try {
      final team = await _repo.getTeamById(teamId);
      
      // Verifica si ya es miembro
      if (team.members.contains(userId)) {
        print('⚠️ El usuario ya es miembro del equipo');
        return;
      }

      // Actualiza la lista de miembros
      final updatedMembers = [...team.members, userId];
      await _repo.updateTeam(teamId, {'members': updatedMembers});
      
      // Actualiza el usuario
      await _userRepo.updateUserTeam(userId, teamId);
      
      print('✅ Miembro agregado exitosamente al equipo');
    } catch (e) {
      print('❌ Error al agregar miembro: $e');
      throw Exception('No se pudo agregar el miembro al equipo');
    }
  }

  /// Remover un miembro del equipo
  Future<void> removeMemberFromTeam(String teamId, String userId) async {
    try {
      final team = await _repo.getTeamById(teamId);
      
      // No permitir remover al creador
      if (team.createdBy == userId) {
        throw Exception('El creador del equipo no puede ser removido');
      }
      
      if (!team.members.contains(userId)) {
        print('⚠️ El usuario no es miembro del equipo');
        return;
      }

      // Actualiza la lista de miembros
      final updatedMembers = team.members.where((id) => id != userId).toList();
      await _repo.updateTeam(teamId, {'members': updatedMembers});
      
      // Quita la asignación del equipo al usuario
      await _userRepo.updateUserTeam(userId, null);
      
      print('✅ Miembro removido exitosamente del equipo');
    } catch (e) {
      print('❌ Error al remover miembro: $e');
      throw Exception('No se pudo remover el miembro del equipo');
    }
  }

  /// Obtener todos los equipos
  Future<List<TeamModel>> getAllTeams() => _repo.getAllTeams();

  /// Obtener equipo por ID
  Future<TeamModel> getTeamById(String teamId) => _repo.getTeamById(teamId);

  /// Eliminar un equipo
  Future<void> deleteTeam(String teamId) async {
    try {
      final team = await getTeamById(teamId);
      
      // Primero, actualiza todos los usuarios del equipo
      for (final userId in team.members) {
        await _userRepo.updateUserTeam(userId, null);
      }
      
      // Luego elimina el equipo
      await _repo.deleteTeam(teamId);
      
      print('✅ Equipo eliminado exitosamente');
    } catch (e) {
      print('❌ Error al eliminar equipo: $e');
      throw Exception('No se pudo eliminar el equipo');
    }
  }

  /// Actualizar un equipo
  Future<void> updateTeam(String teamId, Map<String, dynamic> data) =>
      _repo.updateTeam(teamId, data);

  /// Subir logo al storage de Appwrite y devolver URL pública
  Future<String?> uploadLogo(File file) async {
    try {
      final uploadedFile = await _storage.createFile(
        bucketId: _bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      final fileUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/$_bucketId/files/${uploadedFile.$id}/view?project=680e6eac0019ea6300d2';

      print('✅ Logo subido correctamente: $fileUrl');
      return fileUrl;
    } catch (e) {
      print('❌ Error al subir logo: $e');
      return null;
    }
  }

  /// Verificar si un usuario es miembro del equipo
  Future<bool> isUserTeamMember(String teamId, String userId) async {
    try {
      final team = await _repo.getTeamById(teamId);
      return team.members.contains(userId);
    } catch (e) {
      print('❌ Error al verificar membresía: $e');
      return false;
    }
  }
}