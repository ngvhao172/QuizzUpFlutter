import 'package:cloud_firestore/cloud_firestore.dart';

class FlashCardSettings {
  String? id;
  String userId;
  bool randomTerms;
  bool autoPlayAudio;
  String cardOrientation;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  FlashCardSettings(
  {
    this.id,
    createdAt,
    updatedAt,
    required this.userId,
    required this.randomTerms,
    required this.autoPlayAudio,
    required this.cardOrientation,
  }) : this.createdAt = createdAt ?? DateTime.now(), this.updatedAt = updatedAt ?? DateTime.now();

  factory FlashCardSettings.fromJson(Map<String, dynamic> json) {
    return FlashCardSettings(
      id: json['id'],
      randomTerms: json['randomTerms'],
      autoPlayAudio: json['autoPlayAudio'],
      cardOrientation: json['cardOrientation'],
      userId: json['userId'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'randomTerms': randomTerms,
      'autoPlayAudio': autoPlayAudio,
      'cardOrientation': cardOrientation,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
