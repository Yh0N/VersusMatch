class TeamModel {
  final String id;
  final String name;
  final String location;
  final String logoUrl;
  final List<String>? members;

  TeamModel({
    required this.id,
    required this.name,
    required this.location,
    required this.logoUrl,
    this.members,
  });

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['\$id'],
      name: map['name'],
      location: map['location'],
      logoUrl: map['logoUrl'],
      members: List<String>.from(map['members'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'logoUrl': logoUrl,
      'members': members,
    };
  }
}
