class VocabFavouriteModel {

  String? id;
  String vocabularyId;
  String topicId;
  String userId;

  VocabFavouriteModel({
    this.id,
    required this.vocabularyId,
    required this.userId,
     required this.topicId,
  });

  factory VocabFavouriteModel.fromJson(Map<String, dynamic> json) {
    return VocabFavouriteModel(
      id: json['id'],
      vocabularyId: json['vocabularyId'],
      userId: json['userId'],
      topicId: json['topicId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vocabularyId': vocabularyId,
      'userId': userId,
      'topicId': topicId
    };
  }
}