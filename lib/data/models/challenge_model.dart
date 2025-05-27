import 'package:flutter/foundation.dart';

@immutable
class ChallengeModel {
  final String id;
  final String fromTeamId;
  final String toTeamId;
  final String status; // "pending", "accepted", "rejected"
  final DateTime date;
  final String? message;
  final String? createdBy;
  final DateTime? responseDate;

  const ChallengeModel({
    required this.id,
    required this.fromTeamId,
    required this.toTeamId,
    required this.status,
    required this.date,
    this.message,
    this.createdBy,
    this.responseDate,
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['\$id'] as String? ?? '',
      fromTeamId: map['fromTeamId'] as String? ?? '',
      toTeamId: map['toTeamId'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      date: DateTime.parse(map['date'] as String),
      message: map['message'] as String?,
      createdBy: map['createdBy'] as String?,
      responseDate: map['responseDate'] != null
          ? DateTime.tryParse(map['responseDate'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromTeamId': fromTeamId,
      'toTeamId': toTeamId,
      'status': status,
      'date': date.toIso8601String(),
      if (message != null) 'message': message,
      if (createdBy != null) 'createdBy': createdBy,
      if (responseDate != null)
        'responseDate': responseDate!.toIso8601String(),
    };
  }

  ChallengeModel copyWith({
    String? id,
    String? fromTeamId,
    String? toTeamId,
    String? status,
    DateTime? date,
    String? message,
    String? createdBy,
    DateTime? responseDate,
  }) {
    return ChallengeModel(
      id: id ?? this.id,
      fromTeamId: fromTeamId ?? this.fromTeamId,
      toTeamId: toTeamId ?? this.toTeamId,
      status: status ?? this.status,
      date: date ?? this.date,
      message: message ?? this.message,
      createdBy: createdBy ?? this.createdBy,
      responseDate: responseDate ?? this.responseDate,
    );
  }
}
