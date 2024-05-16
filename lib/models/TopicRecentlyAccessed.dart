import 'package:cloud_firestore/cloud_firestore.dart';

class TopicRecentlyAccessed {
  String? id;
  String userId;
  List<String> topicIds;

  DateTime? createdAt = DateTime.now();

  DateTime? updatedAt = DateTime.now();

  TopicRecentlyAccessed({
    this.id,
    createdAt,
    updatedAt,
    required this.userId,
    required this.topicIds,
  }) : this.createdAt = createdAt ?? DateTime.now(), this.updatedAt = updatedAt ?? DateTime.now();

  factory TopicRecentlyAccessed.fromJson(Map<String, dynamic> json) {
    return TopicRecentlyAccessed(
      id: json['id'],
      userId: json['userId'],
      topicIds: List<String>.from(json['topicIds']),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'topicIds': topicIds, 'createdAt': createdAt, 'updatedAt': updatedAt };
  }
}
