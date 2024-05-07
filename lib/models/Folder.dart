import 'package:cloud_firestore/cloud_firestore.dart';

class FolderModel {
  String? id;
  List<String>? topicId;
  String name;
  String? description;
  String userId;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  FolderModel(
      {this.id,
      this.topicId,
      this.description,
      createdAt,
      updatedAt,
      required this.userId,
      required this.name,
      }) : this.createdAt = createdAt ?? DateTime.now(), this.updatedAt = updatedAt ?? DateTime.now();

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
        id: json['id'],
        topicId: json['topicId'],
        name: json['name'],
        description: json['description'],
        userId: json['userId'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        updatedAt: (json['updatedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'name': name,
      'description': description,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
