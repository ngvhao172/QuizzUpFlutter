class TopicPlayCount {

  String? id;
  String topicId;
  String userId;
  int? times;

  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  TopicPlayCount({
    this.id,
    required this.topicId,
    required this.userId,
    this.times = 1
  });

  factory TopicPlayCount.fromJson(Map<String, dynamic> json) {
    return TopicPlayCount(
      id: json['id'],
      topicId: json['topicId'],
      userId: json['userId'],
      times: json['times']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topicId': topicId,
      'userId': userId,
      'times': times
    };
  }
}