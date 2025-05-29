class PostModel {
  final String id; // ID del documento en Appwrite
  final String authorId;
  final String type;
  final String content;
  final String? imageUrl;
  final String? challengeId;
  final String? teamId;
  final List<String> likes;
  final List<Map<String, dynamic>> comments; // Lista de mapas para comentarios ricos
  final DateTime createdAt;
  final String? acceptedBy; // Quién aceptó el challenge

  PostModel({
    required this.id,
    required this.authorId,
    required this.type,
    required this.content,
    this.imageUrl,
    this.challengeId,
    this.teamId,
    required this.likes,
    required this.comments,
    required this.createdAt,
    this.acceptedBy,
  });

  // Convertir de Map a PostModel (para usar con Appwrite)
  factory PostModel.fromMap(Map<String, dynamic> map) {
    // Soporta comentarios antiguos (String) y nuevos (Map)
    List<Map<String, dynamic>> parsedComments = [];
    if (map['comments'] != null) {
      if (map['comments'].isNotEmpty && map['comments'][0] is String) {
        // Comentarios antiguos: solo texto
        parsedComments = List<String>.from(map['comments'])
            .map((c) => {
                  'username': 'Usuario',
                  'avatarUrl': '',
                  'text': c,
                })
            .toList();
      } else {
        // Comentarios nuevos: mapas
        parsedComments = List<Map<String, dynamic>>.from(
            (map['comments'] as List).map((c) => Map<String, dynamic>.from(c)));
      }
    }

    return PostModel(
      id: map['\$id'] ?? '',
      authorId: map['authorId'],
      type: map['type'],
      content: map['content'],
      imageUrl: map['imageUrl'],
      challengeId: map['challengeId'],
      teamId: map['teamId'],
      likes: List<String>.from(map['likes'] ?? []),
      comments: parsedComments,
      createdAt: DateTime.parse(map['createdAt']),
      acceptedBy: map['acceptedBy'],
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
      'acceptedBy': acceptedBy,
    };

    if (imageUrl != null) {
      map['imageUrl'] = imageUrl;
    }
    if (challengeId != null) {
      map['challengeId'] = challengeId;
    }
    if (teamId != null) {
      map['teamId'] = teamId;
    }
    return map;
  }
}