import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/post_model.dart';

class PostRepository {
  final Databases _db;

  PostRepository(this._db);

  Future<void> createPost(PostModel post) {
    return _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      documentId: ID.unique(), // o usa el ID del post si ya lo tienes
      data: post.toMap(),
    );
  }

  Future<List<PostModel>> getAllPosts() async {
    final result = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      queries: [
        Query.orderDesc('createdAt'),
      ],
    );

    return result.documents.map((doc) => PostModel.fromMap(doc.data)).toList();
  }

  Future<List<PostModel>> getPostsByTeam(String teamId) async {
    final result = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      queries: [
        Query.equal('teamId', teamId),
        Query.orderDesc('createdAt'),
      ],
    );

    return result.documents.map((doc) => PostModel.fromMap(doc.data)).toList();
  }

  Future<void> deletePost(String postId) {
    return _db.deleteDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      documentId: postId,
    );
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) {
    return _db.updateDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      documentId: postId,
      data: data,
    );
  }

  Future<PostModel> getPostById(String postId) async {
    final doc = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.postsCollectionId,
      documentId: postId,
    );

    return PostModel.fromMap(doc.data);
  }
}
