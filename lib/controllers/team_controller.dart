import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/team_model.dart';
import 'package:versus_match/data/repositories/team_repository.dart';

// Provider para acceder al repositorio desde otras clases
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  final db = ref.read(dbProvider); // base de datos Appwrite
  return TeamRepository(db);
});

// Provider del controlador de equipos
final teamControllerProvider = Provider<TeamController>((ref) {
  final repo = ref.read(teamRepositoryProvider);
  final storage = ref.read(storageProvider);
  return TeamController(repo, storage);
});

class TeamController {
  final TeamRepository _repo;
  final Storage _storage;

  // El bucket ID de Appwrite (ajusta si es necesario)
  static const String _bucketId = '6824089f00254a004c46';

  TeamController(this._repo, this._storage);

  /// Crear un nuevo equipo
  Future<void> createTeam(TeamModel team) async {
    try {
      await _repo.createTeam(team);
      print('✅ Equipo creado exitosamente');
    } catch (e) {
      print('❌ Error al crear equipo: $e');
    }
  }

  /// Crear equipo y subir logo en un solo flujo
Future<void> createTeamWithLogo({
  required File logoFile,
  required String name,
  required String location,
  String? description,
  required String createdBy, // Ahora es requerido
  bool? openToJoin,
}) async {
  final logoUrl = await uploadLogo(logoFile);
  if (logoUrl == null) throw Exception('No se pudo subir el logo');

  final team = TeamModel(
    id: '', // Appwrite generará el ID
    name: name,
    location: location,
    logoUrl: logoUrl,
    members: [createdBy], // El creador es el primer miembro
    description: description,
    createdBy: createdBy,
    openToJoin: openToJoin,
  );
  await createTeam(team);
}

  /// Obtener todos los equipos
  Future<List<TeamModel>> getAllTeams() => _repo.getAllTeams();

  /// Obtener equipo por ID
  Future<TeamModel> getTeamById(String teamId) => _repo.getTeamById(teamId);

  /// Eliminar un equipo
  Future<void> deleteTeam(String teamId) => _repo.deleteTeam(teamId);

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

      print('🟢 Logo subido correctamente: $fileUrl');
      return fileUrl;
    } catch (e) {
      print('❌ Error al subir logo: $e');
      return null;
    }
  }
}