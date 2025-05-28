import 'package:flutter/foundation.dart';

class TeamModel {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;
  final List<String> members;
  final String? description;
  final String createdBy;
  final bool openToJoin;

  TeamModel({
    required this.id,
    required this.name,
    required this.location,
    this.logoUrl,
    required this.members,
    this.description,
    required this.createdBy,
    this.openToJoin = true,
  }) : assert(name.trim().isNotEmpty, 'El nombre no puede estar vacío'),
       assert(location.trim().isNotEmpty, 'La ubicación no puede estar vacía'),
       assert(members.isNotEmpty, 'Debe haber al menos un miembro'),
       assert(createdBy.trim().isNotEmpty, 'Debe especificarse el creador');

  factory TeamModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return TeamModel(
      id: documentId ?? map['\$id'] ?? '',
      name: map['name'] as String? ?? '',
      location: map['location'] as String? ?? '',
      logoUrl: map['logoUrl'] as String?,
      members: (map['members'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      description: map['description'] as String?,
      createdBy: map['createdBy'] as String? ?? '',
      openToJoin: map['openToJoin'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'logoUrl': logoUrl,
      'members': members.toList(),
      'description': description,
      'createdBy': createdBy,
      'openToJoin': openToJoin,
    };
  }

  // Método de utilidad para agregar un miembro
  TeamModel addMember(String userId) {
    if (userId.isEmpty) throw ArgumentError('userId no puede estar vacío');
    if (members.contains(userId)) return this;
    return copyWith(members: [...members, userId]);
  }

  // Método para remover un miembro
  TeamModel removeMember(String userId) {
    if (userId == createdBy) throw StateError('No se puede remover al creador');
    if (!members.contains(userId)) return this;
    return copyWith(
      members: members.where((id) => id != userId).toList(),
    );
  }

  // Métodos de utilidad
  bool isMember(String userId) => members.contains(userId);
  bool isCreator(String userId) => createdBy == userId;
  int get memberCount => members.length;

  TeamModel copyWith({
    String? id,
    String? name,
    String? location,
    String? logoUrl,
    List<String>? members,
    String? description,
    String? createdBy,
    bool? openToJoin,
  }) {
    return TeamModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      logoUrl: logoUrl ?? this.logoUrl,
      members: members ?? this.members,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      openToJoin: openToJoin ?? this.openToJoin,
    );
  }

  @override
  String toString() => 'TeamModel(id: $id, name: $name, members: ${members.length} members)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}