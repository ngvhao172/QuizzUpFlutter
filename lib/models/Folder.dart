import 'package:cloud_firestore/cloud_firestore.dart';

class FolderModel {
  String? id;
  List<String>? topicIds = [];
  String name;
  String? description;
  String userId;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  FolderModel(
      {this.id,
      this.topicIds,
      this.description,
      createdAt,
      updatedAt,
      required this.userId,
      required this.name,
      }) : this.createdAt = createdAt ?? DateTime.now(), this.updatedAt = updatedAt ?? DateTime.now();

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
        id: json['id'],
        topicIds: List<String>.from(json['topicIds']),
        name: json['name'],
        description: json['description'],
        userId: json['userId'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        updatedAt: (json['updatedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicIds': topicIds,
      'name': name,
      'description': description,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
