import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/dtos/VocabInfo.dart';
import 'package:final_quizlet_english/models/VocabFavourite.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:final_quizlet_english/services/VocabFavDao.dart';
import 'package:final_quizlet_english/services/VocabStatusDao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicDetailBloc extends Bloc<TopicEvent, TopicState> {
  final TopicDao topicDao;

  final VocabularyFavDao vocabularyFavDao;

  late TopicInfoDTO topicInfoDTO;

  List<VocabularyModel> vocabsFav = [];

  TopicDetailBloc(this.topicDao, this.vocabularyFavDao) : super(TopicLoading()) {
    on<LoadTopic>((event, emit) async {
      emit(TopicLoading());
      final topicDetail = await topicDao.getTopicInfoDTOByTopicIdAndUserId(event.topicId, event.userId);
      print(topicDetail);
      if(vocabsFav.isNotEmpty){
        print(topicInfoDTO.topic.id);
        if(topicInfoDTO.topic.id != topicDetail["data"].topic.id){
          vocabsFav.clear();
        }
      }
      vocabsFav.clear();
      if(topicDetail["status"]){
        topicInfoDTO = topicDetail["data"];
        final vocabFav = await vocabularyFavDao.getVocabularysFavByUserIdAndTopicId(event.userId, event.topicId);
        if (vocabFav["status"]) {
          var vocabFavs = vocabFav["data"];
          for (var vocab in topicInfoDTO.vocabs!) {
            for (var favvocab in vocabFavs) {
            if(favvocab.vocabularyId == vocab.vocab.id){
              vocabsFav.add(vocab.vocab);
            }
          }
        }
      }
      else{
        print(vocabFav["message"]);
      }
      }
      else{
        print(topicDetail["message"]);
      }
      
      emit(TopicDetailLoaded(topicInfoDTO, vocabsFav));
    });


    on<AddVocabFav>((event, emit) async {
      var result = await vocabularyFavDao.addVocabularyFav(event.favVocab);
      if (result["status"]) {
        print(result);
        for (var element in topicInfoDTO.vocabs!) {
          if(event.favVocab.vocabularyId == element.vocab.id){
            vocabsFav.add(element.vocab);
          }
        }
        emit(TopicDetailLoaded(topicInfoDTO, vocabsFav));
      } 
      print(result["message"]);
    });

    on<RemoveVocabFav>((event, emit) async {
      var result = await vocabularyFavDao.deleteVocabularyFav(event.vocabId, event.userId);
      if (result["status"]) {
        print(result);
        vocabsFav.removeWhere((element) => element.id == event.vocabId);
      } 
      else{
        print(result["message"]);
      }
      emit(TopicDetailLoaded(topicInfoDTO, vocabsFav));
    });

    on<UpdateVocabStatusStatus>((event, emit) async {
      var result = await VocabularyStatusDao().updateVocabularyStatusStatus(event.vocabStatus.id!, event.status);
      if (result["status"]) {
        print(result);
        for (var element in topicInfoDTO.vocabs!) {
          if(element.vocabStatus.id == event.vocabStatus.id!){
            element.vocabStatus = result["data"];
          }
        }
      } 
      else{
        print(result["message"]);
      }
      emit(TopicDetailLoaded(topicInfoDTO, vocabsFav));
    });
  }
}
