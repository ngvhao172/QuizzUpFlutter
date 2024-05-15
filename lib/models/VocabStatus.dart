//0: notStudied, 1: studying, 2: knew, 3: mastered
class VocabularyStatus {

  String? id;
  String vocabularyId;
  String userId;
  String topicId;
  int status;

  VocabularyStatus({
    this.id,
    required this.vocabularyId,
    required this.topicId,
    required this.userId,
    this.status = 0,
  });

  factory VocabularyStatus.fromJson(Map<String, dynamic> json) {
    return VocabularyStatus(
      id: json['id'],
      vocabularyId: json['vocabularyId'],
      topicId: json['topicId'],
      userId: json['userId'],
      status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vocabularyId': vocabularyId,
      'topicId': topicId,
      'userId': userId,
      'status': status
    };
  }
}
