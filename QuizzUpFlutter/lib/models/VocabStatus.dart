enum VocabularyStatus {
  notStudied,
  studying,
  mastered,
}
class VocabStatus {

  String? id;
  String vocabularyId;
  String userId;
  VocabularyStatus status;

  VocabStatus({
    this.id,
    required this.vocabularyId,
    required this.userId,
    this.status = VocabularyStatus.notStudied,
  });

  factory VocabStatus.fromJson(Map<String, dynamic> json) {
    return VocabStatus(
      id: json['id'],
      vocabularyId: json['vocabularyId'],
      userId: json['userId'],
      status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vocabularyId': vocabularyId,
      'userId': userId,
      'status': status
    };
  }
}
