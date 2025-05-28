class UserModel {
  final String id;
  final String username;
  final String email;
  final String? teamId;
  final String? position;
  final String? avatarUrl; // <-- Cambiado aquí

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.teamId,
    this.position,
    this.avatarUrl, // <-- Cambiado aquí
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'],
      username: map['username'],
      email: map['email'],
      teamId: map['teamId'],
      position: map['position'],
      avatarUrl: map['avatarUrl'], // <-- Cambiado aquí
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'teamId': teamId,
      'position': position,
      'avatarUrl': avatarUrl, // <-- Cambiado aquí
    };
  }
}