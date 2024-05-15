import 'package:cloud_firestore/cloud_firestore.dart';

class TopicTypeSettings {
  String? id;
  String userId;
  bool randomTerms;
  String typeLanguage;
  bool autoPlayAudio;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  TopicTypeSettings(
  {
    this.id,
    createdAt,
    updatedAt,
    required this.userId,
    required this.randomTerms,
    required this.autoPlayAudio,
    required this.typeLanguage,
  }) : this.createdAt = createdAt ?? DateTime.now(), this.updatedAt = updatedAt ?? DateTime.now();

  factory TopicTypeSettings.fromJson(Map<String, dynamic> json) {
    return TopicTypeSettings(
      id: json['id'],
      randomTerms: json['randomTerms'],
      autoPlayAudio: json['autoPlayAudio'],
      typeLanguage: json['typeLanguage'],
      userId: json['userId'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'randomTerms': randomTerms,
      'autoPlayAudio': autoPlayAudio,
      'typeLanguage': typeLanguage,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
