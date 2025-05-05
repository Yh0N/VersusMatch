class ChallengeModel {
  final String id;
  final String fromTeamId;
  final String toTeamId;
  final String status;
  final DateTime date;
  final String? message;

  ChallengeModel({
    required this.id,
    required this.fromTeamId,
    required this.toTeamId,
    required this.status,
    required this.date,
    this.message,
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['\$id'],
      fromTeamId: map['fromTeamId'],
      toTeamId: map['toTeamId'],
      status: map['status'],
      date: DateTime.parse(map['date']),
      message: map['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromTeamId': fromTeamId,
      'toTeamId': toTeamId,
      'status': status,
      'date': date.toIso8601String(),
      'message': message,
    };
  }
}
