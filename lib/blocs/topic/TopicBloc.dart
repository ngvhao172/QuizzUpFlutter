import 'package:final_quizlet_english/blocs/topic/Topic.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TopicBloc extends Bloc<TopicEvent, TopicState> {
  final TopicDao topicDao;

  List<TopicInfoDTO> currentTopics = [];

  // List<TopicInfoDTO> todayTopics = [];

  // List<TopicInfoDTO> yesterdayTopics = [];

  // List<TopicInfoDTO> thisWeekTopics = [];

  // List<TopicInfoDTO> otherTopics = [];

  TopicBloc(this.topicDao) : super(TopicLoading()) {
    on<LoadTopics>((event, emit) async {
      emit(TopicLoading());
      final topics = await topicDao.getTopicInfoDTOByUserId(event.userId);
      print(topics);
      DateTime today = DateTime.now();
      DateTime yesterday = today.subtract(Duration(days: 1));
      currentTopics = topics["data"];
      // todayTopics = yesterdayTopics = thisWeekTopics = otherTopics = [];
      // for (var topicDTO in currentTopics) {
      //   if (DateFormat('yyyy-MM-dd').format(topicDTO.topic.lastAccessed) ==
      //       DateFormat('yyyy-MM-dd').format(today)) {
      //     todayTopics.add(topicDTO);
      //   }
      //   if (DateFormat('yyyy-MM-dd').format(topicDTO.topic.lastAccessed) ==
      //       DateFormat('yyyy-MM-dd').format(yesterday)) {
      //     yesterdayTopics.add(topicDTO);
      //   }

      //   if (DateFormat('yyyy-MM-dd')
      //               .format(topicDTO.topic.lastAccessed)
      //               .compareTo(DateFormat('yyyy-MM-dd')
      //                   .format(today.subtract(Duration(days: 7)))) >
      //           0 &&
      //       DateFormat('yyyy-MM-dd')
      //               .format(topicDTO.topic.lastAccessed)
      //               .compareTo(DateFormat('yyyy-MM-dd')
      //                   .format(today.subtract(Duration(days: 2)))) <
      //           0) {
      //     thisWeekTopics.add(topicDTO);
      //   }
      //   if (DateFormat('yyyy-MM-dd')
      //           .format(topicDTO.topic.lastAccessed)
      //           .compareTo(DateFormat('yyyy-MM-dd')
      //               .format(today.subtract(Duration(days: 7)))) <
      //       0) {
      //     otherTopics.add(topicDTO);
      //   }
      // }
      // print(yesterdayTopics);
      currentTopics.sort((a, b) => b.topic.lastAccessed.compareTo(a.topic.lastAccessed));
      emit(TopicLoaded(currentTopics));
    });

    on<LoadTopicsByCreatedDay>((event, emit) async {
      emit(TopicLoading());
      currentTopics
          .sort((a, b) => b.topic.createdAt!.compareTo(a.topic.createdAt!));

      emit(TopicLoaded(currentTopics));
    });

    on<AddTopic>((event, emit) async {
      var result = await topicDao.addTopic(event.topic);
      if (result["status"]) {
        print(result);
        String topicId = result["data"];
        event.completer.complete(topicId); // Trả về id
        // final topics = await topicDao.getTopicInfoDTOByUserId(event.topic.userId);
        final newTopicAdded = await topicDao.getTopicInfoDTOByTopicId(topicId);
        if (newTopicAdded["status"]) {
          currentTopics.add(newTopicAdded["data"]);
          // todayTopics.add(newTopicAdded["data"]);
        }
        emit(TopicLoaded(currentTopics));
      } else {
        event.completer.completeError('Failed to add the topic');
      }
    });

    on<UpdateTopic>((event, emit) async {
      var result = await topicDao.updateTopic(event.topic);
      currentTopics.removeWhere(
          (topicToDelete) => topicToDelete.topic.id == event.topic.id);
      // todayTopics.removeWhere(
      //     (topicToDelete) => topicToDelete.topic.id == event.topic.id);
      final newTopicAdded =
          await topicDao.getTopicInfoDTOByTopicId(event.topic.id!);
      if (newTopicAdded["status"]) {
        currentTopics.add(newTopicAdded["data"]);
        // todayTopics.add(newTopicAdded["data"]);
      }
      emit(TopicLoaded(currentTopics));
    });

    on<RemoveTopic>((event, emit) async {
      var result = await topicDao.deleteTopicById(event.topicId);
      if (result["status"]) {
        currentTopics.removeWhere(
            (topicToDelete) => topicToDelete.topic.id == event.topicId);
        // todayTopics.removeWhere(
        //     (topicToDelete) => topicToDelete.topic.id == event.topicId);
      }
      emit(TopicLoaded(currentTopics));
      print(result["message"]);
    });
  }
}
