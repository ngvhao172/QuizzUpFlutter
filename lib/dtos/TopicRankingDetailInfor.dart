class TopicRankingDetailInfoDTO {

  final String topicName;
  final DateTime createdAt;
  double accuracy;
  final int totalAttempts;
  RecordUser? mostCorrectAnswerUser;
  RecordUser? completedShortestTimeUser;
  RecordUser? mostAttemptsUser;

  TopicRankingDetailInfoDTO({
    required this.topicName,
    required this.createdAt,
    required this.accuracy,
    required this.totalAttempts,
    this.mostCorrectAnswerUser,
    this.completedShortestTimeUser,
    this.mostAttemptsUser,
  });

  // factory TopicRankingDetailInfoDTO.fromJson(Map<String, dynamic> json) {
  //   return TopicRankingDetailInfoDTO(
  //       topicName: json['topicName'],
  //       lastPlayed: json['lastPlayed'],
  //       participants: json['participants'],
  //       accuracy: json['accuracy']);
  // }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'topicName': topicName,
  //     'lastPlayed': lastPlayed,
  //     'participants': participants,
  //     'accuracy': accuracy
  //   };
  // }

}
class RecordUser{
  final String userName;
  final String? photoURL;
  final int attemptNumbers;
  final int correctAnswers;
  final int wrongAnswers;
  final int notAnswered;
  final int? shortestTime;

  RecordUser({
    required this.userName,
    this.photoURL,
    required this.attemptNumbers,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.notAnswered,
    this.shortestTime
  });
}
