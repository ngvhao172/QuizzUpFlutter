import 'package:final_quizlet_english/dtos/VocabInfo.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';

class TopicInfoDTO {

  int termNumbers;
  int playersCount;
  String authorName;
  String? userAvatar;
  List<VocabInfoDTO>? vocabs;
  List<VocabularyModel>? favoriteVocabs;

  TopicModel topic;

  TopicInfoDTO({
    required this.termNumbers,
    required this.playersCount,
    required this.authorName,
    required this.topic,
    this.userAvatar,
    this.vocabs,
    this.favoriteVocabs
  }
  );

  factory TopicInfoDTO.fromJson(Map<String, dynamic> json) {
    return TopicInfoDTO(
        topic: json['topic'],
        termNumbers: json['foldtermNumberserId'],
        playersCount: json['playersCount'],
        authorName: json['authorName'],
        userAvatar: json['userAvatar'],
        vocabs: json['vocabs'],
        favoriteVocabs: json['favoriteVocabs'],);
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'termNumbers': termNumbers,
      'playersCount': playersCount,
      'authorName': authorName,
      'userAvatar': userAvatar,
      'vocabs': vocabs,
      'favoriteVocabs': favoriteVocabs,
    };
  }
}
