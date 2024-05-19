class TopicRankingInfoDTO {
  final String topicId;
  final String topicName;
  final DateTime lastPlayed;
  final int participants;
  final double accuracy;

  TopicRankingInfoDTO({
    required this.topicId, 
    required this.topicName,
    required this.lastPlayed,
    required this.participants,
    required this.accuracy,
  });

  factory TopicRankingInfoDTO.fromJson(Map<String, dynamic> json) {
    return TopicRankingInfoDTO(
      topicId: json['topicId'],
      topicName: json['topicName'],
      lastPlayed: json['lastPlayed'],
      participants: json['participants'],
      accuracy: json['accuracy']);
  }

  Map<String, dynamic> toJson() {
    return {
      'topicId': topicId,
      'topicName': topicName,
      'lastPlayed': lastPlayed,
      'participants': participants,
      'accuracy': accuracy
    };
  }
}
