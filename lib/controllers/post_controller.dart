import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/post_model.dart';
import 'package:versus_match/data/repositories/post_repository.dart';

// Provider para el repositorio
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final db = ref.read(dbProvider);
  return PostRepository(db);
});

// Provider del controlador
final postControllerProvider = Provider((ref) {
  final repo = ref.read(postRepositoryProvider);
  return PostController(repo);
});

class PostController {
  final PostRepository _repo;

  PostController(this._repo);

  Future<void> createPost(PostModel post) => _repo.createPost(post);

  Future<List<PostModel>> getAllPosts() => _repo.getAllPosts();

  Future<List<PostModel>> getPostsByTeam(String teamId) =>
      _repo.getPostsByTeam(teamId);

  Future<void> deletePost(String postId) => _repo.deletePost(postId);

  Future<void> updatePost(String postId, Map<String, dynamic> data) =>
      _repo.updatePost(postId, data);

  Future<PostModel> getPostById(String postId) =>
      _repo.getPostById(postId);
}
