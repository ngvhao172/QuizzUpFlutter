import 'package:final_quizlet_english/models/VocabStatus.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';

class VocabInfoDTO {

  VocabularyModel vocab;
  VocabularyStatus vocabStatus;

  VocabInfoDTO({
    required this.vocab,
    required this.vocabStatus
  }
  );

  factory VocabInfoDTO.fromJson(Map<String, dynamic> json) {
    return VocabInfoDTO(
        vocab: json['vocab'],
        vocabStatus: json['vocabStatus']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vocab': vocab,
      'vocabStatus': vocabStatus
    };
  }
}
