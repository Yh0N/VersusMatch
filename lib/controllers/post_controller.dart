import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/post_model.dart';
import 'package:versus_match/data/repositories/post_repository.dart';

// Provider para acceder al repositorio desde otras clases
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final db = ref.read(dbProvider); // <- base de datos Appwrite
  return PostRepository(db);
});

// Provider del controlador de publicaciones
final postControllerProvider = Provider<PostController>((ref) {
  final repo = ref.read(postRepositoryProvider); // <- instancia del repositorio
  final storage = ref.read(storageProvider);     // <- acceso a Storage de Appwrite
  return PostController(repo, storage);
});

class PostController {
  final PostRepository _repo;
  final Storage _storage;

  // El bucket ID de Appwrite (debes asegurarte que sea correcto)
  static const String _bucketId = '6824089f00254a004c46'; 

  PostController(this._repo, this._storage);

  /// Crear una nueva publicación
  Future<void> createPost(PostModel post) async {
    try {
      await _repo.createPost(post);
      print('✅ Post creado exitosamente');
    } catch (e) {
      print('❌ Error al crear post: $e');
    }
  }

  /// Obtener todas las publicaciones
  Future<List<PostModel>> getAllPosts() => _repo.getAllPosts();

  /// Obtener publicaciones por ID de equipo
  Future<List<PostModel>> getPostsByTeam(String teamId) =>
      _repo.getPostsByTeam(teamId);

  /// Eliminar una publicación
  Future<void> deletePost(String postId) => _repo.deletePost(postId);

  /// Actualizar una publicación
  Future<void> updatePost(String postId, Map<String, dynamic> data) =>
      _repo.updatePost(postId, data);

  /// Obtener publicación por ID
  Future<PostModel> getPostById(String postId) => _repo.getPostById(postId);

  /// Subir imagen al storage de Appwrite y devolver URL pública
  Future<String?> uploadImage(File file) async {
    try {
      final uploadedFile = await _storage.createFile(
        bucketId: _bucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      // URL pública del archivo (asegúrate que el bucket tenga permiso de lectura pública o para el usuario)
      final fileUrl =
          'https://cloud.appwrite.io/v1/storage/buckets/$_bucketId/files/${uploadedFile.$id}/view?project=680e6eac0019ea6300d2';

      print('🟢 Imagen subida correctamente: $fileUrl');
      return fileUrl;
    } catch (e) {
      print('❌ Error al subir imagen: $e');
      return null;
    }
  }
}
