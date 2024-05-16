import 'dart:async';

import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/VocabFavourite.dart';
import 'package:final_quizlet_english/models/VocabStatus.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';

abstract class TopicEvent {}

class LoadTopics extends TopicEvent {
  final String userId;

  LoadTopics(this.userId);
}

class LoadTopicsByCreatedDay extends TopicEvent {
  final String userId;

  LoadTopicsByCreatedDay(this.userId);
}

class LoadTopic extends TopicEvent {
  final String topicId;
  final String userId;

  LoadTopic(this.topicId, this.userId);
}

class AddTopic extends TopicEvent {
  final TopicModel topic;
  final String userId;

  final Completer<String> completer;//mục đích lưu trữ id trả về của topic

  AddTopic(this.topic, this.userId)  : completer = Completer<String>();
}

class UpdateTopic extends TopicEvent {
  final TopicModel topic;
  final String userId;

  UpdateTopic(this.topic, this.userId); 
}

class RemoveTopic extends TopicEvent {
  final String topicId;

  RemoveTopic(this.topicId);
}


class RemoveVocabFav extends TopicEvent {
  final String vocabId;

  final String userId;

  RemoveVocabFav(this.vocabId, this.userId);
}
class AddVocabFav extends TopicEvent {
  final VocabFavouriteModel favVocab;

  AddVocabFav(this.favVocab);
}

class UpdateVocabStatusStatus extends TopicEvent {
  final VocabularyStatus vocabStatus;
  final int status;

  UpdateVocabStatusStatus(this.vocabStatus, this.status);
}

abstract class TopicState {}

class TopicLoading extends TopicState {}

class TopicLoaded extends TopicState {
  final List<TopicInfoDTO> topics;

  TopicLoaded(this.topics);
}

class TopicDetailLoaded extends TopicState {
  final TopicInfoDTO topic;

  final List<VocabularyModel> vocabsFav;

  TopicDetailLoaded(this.topic, this.vocabsFav);
}
