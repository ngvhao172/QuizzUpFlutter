import 'package:cloud_firestore/cloud_firestore.dart';

class TopicResultRecord {

  String? id;
  String topicId;
  String userId;
  int completedTime;
  int correctAnswers;
  int wrongAnswers;
  int notAnswers;


  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  TopicResultRecord({
    this.id,
    required this.topicId,
    required this.userId,
    required this.completedTime,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.notAnswers,
    createdAt,
    updatedAt
  }) : createdAt = createdAt ?? DateTime.now(), updatedAt = updatedAt ?? DateTime.now();

  factory TopicResultRecord.fromJson(Map<String, dynamic> json) {
    return TopicResultRecord(
      id: json['id'],
      topicId: json['topicId'],
      userId: json['userId'],
      completedTime: json['completedTime'],
      correctAnswers: json['correctAnswers'],
      wrongAnswers: json['wrongAnswers'],
      notAnswers: json['notAnswers'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'userId': userId,
      'completedTime': completedTime,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'notAnswers': notAnswers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}