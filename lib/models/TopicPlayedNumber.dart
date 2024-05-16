import 'package:cloud_firestore/cloud_firestore.dart';

class TopicPlayedNumber {

  String? id;
  String topicId;
  String userId;
  int times;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  TopicPlayedNumber({
    this.id,
    required this.topicId,
    required this.userId,
    required this.times,
    createdAt,
    updatedAt
  }) : createdAt = createdAt ?? DateTime.now(), updatedAt = updatedAt ?? DateTime.now();

  factory TopicPlayedNumber.fromJson(Map<String, dynamic> json) {
    return TopicPlayedNumber(
      id: json['id'],
      topicId: json['topicId'],
      userId: json['userId'],
      times: json['times'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'userId': userId,
      'times': times,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}