import 'package:cloud_firestore/cloud_firestore.dart';

class TopicModel {
  String? id;
  List<String>? folderId;
  String name;
  String? description;
  String userId;
  List<String>? playersId;
  bool? private = true;
  String termLanguage;
  String definitionLanguage;
  DateTime lastAccessed;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  TopicModel(
      {this.id,
      this.folderId,
      this.description,
      this.playersId,
      this.private,
      createdAt,
      updatedAt,
      required this.userId,
      required this.name,
      required this.lastAccessed,
      required this.termLanguage,
      required this.definitionLanguage}) : createdAt = createdAt ?? DateTime.now(), updatedAt = updatedAt ?? DateTime.now();

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
        id: json['id'],
        folderId: json['folderId'],
        name: json['name'],
        description: json['description'],
        userId: json['userId'],
        playersId: json['playersId'],
        private: json['private'],
        lastAccessed: (json['lastAccessed'] as Timestamp).toDate(),
        termLanguage: json['termLanguage'],
        definitionLanguage: json['definitionLanguage'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        updatedAt: (json['updatedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'folderId': folderId,
      'name': name,
      'description': description,
      'userId': userId,
      'playersId': playersId,
      'private': private,
      'lastAccessed': lastAccessed,
      'termLanguage': termLanguage,
      'definitionLanguage': definitionLanguage,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
