import 'package:flutter/foundation.dart';

@immutable
class TeamModel {
  final String id;
  final String name;
  final String location;
  final String? logoUrl;
  final List<String>? members;
  final String? description;
  final String? createdBy;
  final bool? openToJoin;

  const TeamModel({
    required this.id,
    required this.name,
    required this.location,
    this.logoUrl,
    this.members,
    this.description,
    this.createdBy,
    this.openToJoin,
  });

  factory TeamModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return TeamModel(
      id: documentId ?? map['\$id'] ?? '',
      name: map['name'] as String? ?? '',
      location: map['location'] as String? ?? '',
      logoUrl: map['logoUrl'] as String?,
      members: map['members'] != null ? List<String>.from(map['members']) : null,
      description: map['description'] as String?,
      createdBy: map['createdBy'] as String?,
      openToJoin: map['openToJoin'] is bool ? map['openToJoin'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'logoUrl': logoUrl,
      'members': members,
      'description': description,
      'createdBy': createdBy,
      'openToJoin': openToJoin,
    };
  }
}