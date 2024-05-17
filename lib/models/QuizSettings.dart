import 'package:cloud_firestore/cloud_firestore.dart';

class QuizSettings {
  String? id;
  String userId;
  bool randomTerms;
  bool autoPlayAudio;
  String answerType;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  QuizSettings(
  {
    this.id,
    createdAt,
    updatedAt,
    required this.userId,
    required this.randomTerms,
    required this.autoPlayAudio,
    required this.answerType,
  }) : this.createdAt = createdAt ?? DateTime.now(), this.updatedAt = updatedAt ?? DateTime.now();

  factory QuizSettings.fromJson(Map<String, dynamic> json) {
    return QuizSettings(
      id: json['id'],
      randomTerms: json['randomTerms'],
      autoPlayAudio: json['autoPlayAudio'],
      answerType: json['answerType'],
      userId: json['userId'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'randomTerms': randomTerms,
      'autoPlayAudio': autoPlayAudio,
      'answerType': answerType,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
