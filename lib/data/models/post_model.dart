class PostModel {
  final String id; // <--- ID del documento en Appwrite
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
    required this.id, // <--- AGREGA ESTO
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
      id: map['\$id'] ?? '', // Appwrite usa '$id' para el id del documento
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
    final map = {
      'authorId': authorId,
      'type': type,
      'content': content,
      'likes': likes,
      'comments': comments,
      'createdAt': createdAt.toIso8601String(),
    };

    if (imageUrl != null) {
      map['imageUrl'] = imageUrl as Object;
    }
    if (challengeId != null) {
      map['challengeId'] = challengeId as Object;
    }
    if (teamId != null) {
      map['teamId'] = teamId as Object;
    }
    return map;
  }
}