// lib/data/models/post_model.dart

class PostModel {
  final String authorId;
  final String type;
  final String content;
  final String? imageUrl;
  final String? challengeId;
  final String? teamId;
  final List<String> likes;
  final List<String> comments;
  final DateTime createdAt;

  PostModel({
    required this.authorId,
    required this.type,
    required this.content,
    this.imageUrl,
    this.challengeId,
    this.teamId,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  // Convertir de Map a PostModel (para usar con Appwrite)
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      authorId: map['authorId'],
      type: map['type'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      challengeId: map['challengeId'],
      teamId: map['teamId'],
      likes: List<String>.from(map['likes'] ?? []),
      comments: List<String>.from(map['comments'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Convertir de PostModel a Map (para guardar en Appwrite)
  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'type': type,
      'content': content,
      'imageUrl': imageUrl,
      'challengeId': challengeId,
      'teamId': teamId,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
