import 'package:final_quizlet_english/dtos/FolderInfo.dart';
import 'package:final_quizlet_english/dtos/TopicRankingDetailInfor.dart';
import 'package:final_quizlet_english/dtos/TopicRankingInfo.dart';

abstract class TopicRankingEvent {}

class LoadTopicRankings extends TopicRankingEvent {
  final String userId;

  LoadTopicRankings(this.userId);
}

class LoadTopicRankingDetail extends TopicRankingEvent {
  final String topicId;

  LoadTopicRankingDetail(this.topicId);
}


abstract class TopicRankingState {}

class TopicRankingLoading extends TopicRankingState {}

class TopicRankingLoaded extends TopicRankingState {
  final List<TopicRankingInfoDTO> topics;

  TopicRankingLoaded(this.topics);
}

class TopicRankingDetailLoaded extends TopicRankingState {
  final TopicRankingDetailInfoDTO topicRankingInfoDTO;

  TopicRankingDetailLoaded(this.topicRankingInfoDTO);
}
