class UserModel {
  final String id;
  final String username;
  final String email;
  final String? teamId;
  final String? position;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.teamId,
    this.position,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['\$id'],
      username: map['username'],
      email: map['email'],
      teamId: map['teamId'],
      position: map['position'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'teamId': teamId,
      'position': position,
    };
  }
}
