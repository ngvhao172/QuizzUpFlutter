import 'package:final_quizlet_english/blocs/community/TopicRanking.dart';
import 'package:final_quizlet_english/dtos/TopicRankingDetailInfor.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicRankingDetailBloc extends Bloc<TopicRankingEvent, TopicRankingState> {
  final TopicDao topicDao;

  late TopicRankingDetailInfoDTO topicRankingDetailInfoDTO;

  TopicRankingDetailBloc(this.topicDao) : super(TopicRankingLoading()) {
    on<LoadTopicRankingDetail>((event, emit) async {
      emit(TopicRankingLoading());
      var result = await topicDao.getTopicRankingDetailInfoDTOByTopicId(event.topicId);
      print(result);
      if(result["status"]){
        topicRankingDetailInfoDTO = result["data"];
      }
      emit(TopicRankingDetailLoaded(topicRankingDetailInfoDTO));
    });
  }
}