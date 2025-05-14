import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/post_model.dart';

class PostRepository {
  final Databases _db;

  PostRepository(this._db);

  /// Crea un documento (post) en la base de datos Appwrite
  Future<void> createPost(PostModel post) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        documentId: ID.unique(), // Genera un ID único
        data: post.toMap(),
      );
      print('🟢 Post creado exitosamente');
    } catch (e) {
      print('❌ Error al crear post: $e');
      rethrow;
    }
  }

  /// Obtiene todos los posts, ordenados por fecha de creación (descendente)
  Future<List<PostModel>> getAllPosts() async {
    try {
      final result = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        queries: [
          Query.orderDesc('createdAt'),
        ],
      );

      return result.documents.map((doc) => PostModel.fromMap(doc.data)).toList();
    } catch (e) {
      print('❌ Error al obtener posts: $e');
      return [];
    }
  }

  /// Obtiene posts filtrados por equipo
  Future<List<PostModel>> getPostsByTeam(String teamId) async {
    try {
      final result = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        queries: [
          Query.equal('teamId', teamId),
          Query.orderDesc('createdAt'),
        ],
      );

      return result.documents.map((doc) => PostModel.fromMap(doc.data)).toList();
    } catch (e) {
      print('❌ Error al obtener posts por equipo: $e');
      return [];
    }
  }

  /// Elimina un post por su ID
  Future<void> deletePost(String postId) async {
    try {
      await _db.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        documentId: postId,
      );
      print('🗑️ Post eliminado correctamente');
    } catch (e) {
      print('❌ Error al eliminar post: $e');
      rethrow;
    }
  }

  /// Actualiza un post con los datos proporcionados
  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        documentId: postId,
        data: data,
      );
      print('📝 Post actualizado correctamente');
    } catch (e) {
      print('❌ Error al actualizar post: $e');
      rethrow;
    }
  }

  /// Obtiene un solo post por su ID
  Future<PostModel> getPostById(String postId) async {
    try {
      final doc = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postsCollectionId,
        documentId: postId,
      );
      return PostModel.fromMap(doc.data);
    } catch (e) {
      print('❌ Error al obtener post por ID: $e');
      rethrow;
    }
  }
}
