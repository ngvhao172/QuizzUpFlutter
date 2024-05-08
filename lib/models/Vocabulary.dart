import 'package:cloud_firestore/cloud_firestore.dart';

class VocabularyModel {

  String? id;
  String topicId;
  String term;
  String definition;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  VocabularyModel({
    this.id,
    required this.topicId,
    required this.term,
    required this.definition,
    createdAt,
    updatedAt,}) : createdAt = createdAt ?? DateTime.now(), updatedAt = updatedAt ?? DateTime.now();

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id'],
      topicId: json['topicId'],
      term: json['term'],
      definition: json['definition'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'term': term,
      'definition': definition,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
