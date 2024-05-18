import 'package:final_quizlet_english/blocs/community/TopicRanking.dart';
import 'package:final_quizlet_english/dtos/TopicRankingInfo.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicRankingBloc extends Bloc<TopicRankingEvent, TopicRankingState> {

  final TopicDao topicDao;

  List<TopicRankingInfoDTO> currentTopicRankings = [];

  TopicRankingBloc(this.topicDao) : super(TopicRankingLoading()) {
    on<LoadTopicRankings>((event, emit) async {
      emit(TopicRankingLoading());
      var result = await topicDao.getTopicRankingInfoDTOsByUserId(event.userId);
      print(result);
      currentTopicRankings = [];
      if(result["status"]){
        List<TopicRankingInfoDTO> data = result["data"];
        if(data.isNotEmpty){
          currentTopicRankings = data;
        }
      }
      emit(TopicRankingLoaded(currentTopicRankings));
    });
  }
}
