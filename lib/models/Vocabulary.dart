import 'package:firebase_auth/firebase_auth.dart';

class VocabularyModel {

  String? id;
  String topicId;
  String term;
  String definition;

  VocabularyModel({
    this.id,
    required this.topicId,
    required this.term,
    required this.definition,
  });

  factory VocabularyModel.fromJson(Map<String, dynamic> json) {
    return VocabularyModel(
      id: json['id'],
      topicId: json['topicId'],
      term: json['term'],
      definition: json['definition']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'term': term,
      'definition': definition
    };
  }
}
