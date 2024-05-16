import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/dtos/TopicRankingDetailInfor.dart';
import 'package:final_quizlet_english/dtos/TopicRankingInfo.dart';
import 'package:final_quizlet_english/dtos/VocabInfo.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/TopicPlayedNumber.dart';
import 'package:final_quizlet_english/models/TopicResultRecord.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/models/VocabStatus.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';
import 'package:final_quizlet_english/services/TopicPlayedNumberDao.dart';
import 'package:final_quizlet_english/services/TopicResultRecordDao.dart';
import 'package:final_quizlet_english/services/UserDao.dart';
import 'package:final_quizlet_english/services/VocabDao.dart';
import 'package:final_quizlet_english/services/VocabStatusDao.dart';

class TopicDao {
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('Topic');

  Future<Map<String, dynamic>> addTopic(TopicModel topic) async {
    try {
      Map<String, dynamic> topicData = topic.toJson();

      var topicReturn = await topicCollection.add(topicData);
      return {
        "status": true,
        "message": "Thêm topic thành công.",
        "data": topicReturn.id.toString()
      };
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTopicById(String topictId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await topicCollection.doc(topictId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> topicData =
            documentSnapshot.data() as Map<String, dynamic>;

        if (topicData["id"] == null) {
          topicData["id"] = documentSnapshot.id;
          updateTopic(TopicModel.fromJson(topicData));
        }
        return {"status": true, "data": topicData};
      } else {
        return {"status": false, "message": "Không tìm thấy topic."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteTopicById(String topictId) async {
    try {
      await topicCollection.doc(topictId).delete();

      return {"status": true, "message": "Xóa topic thành công"};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  // Stream<Map<String, dynamic>> getTopicByIdRealtime(String topictId) async* {
  //   try {
  //     DocumentSnapshot documentSnapshot = topicCollection.doc(topictId).get() as DocumentSnapshot<Object?>;
  //     final StreamController<List<TopicModel>> controller =
  //       StreamController<List<TopicModel>>();
  //     if (documentSnapshot.exists) {
  //       Map<String, dynamic> topicData =
  //           documentSnapshot.data() as Map<String, dynamic>;

  //       if(topicData["id"] == null){
  //         topicData["id"] = documentSnapshot.id;
  //          updateTopic(TopicModel.fromJson(topicData));
  //       }
  //       return {"status": true, "data": topicData};
  //     } else {
  //       return {"status": false, "message": "Không tìm thấy topic."};
  //     }
  //   } catch (e) {
  //     return {"status": false, "message": e.toString()};
  //   }
  // }

  Future<Map<String, dynamic>> getTopicsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> topicsData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        for (var i = 0; i < topicsData.length; i++) {
          if (topicsData[i]["id"] == null) {
            topicsData[i]["id"] = querySnapshot.docs[i].id;
            updateTopic(TopicModel.fromJson(topicsData[i]));
          }
        }
        return {"status": true, "data": topicsData};
      } else {
        return {"status": false, "message": "Không tìm thấy topic."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  Future<Map<String, dynamic>> getPublicTopicsByTopicName(String topicName) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('name', isEqualTo: topicName).where("private", isEqualTo: false).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> topicsData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        for (var i = 0; i < topicsData.length; i++) {
          if (topicsData[i]["id"] == null) {
            topicsData[i]["id"] = querySnapshot.docs[i].id;
            updateTopic(TopicModel.fromJson(topicsData[i]));
          }
        }
        return {"status": true, "data": topicsData};
      } else {
        return {"status": false, "message": "Không tìm thấy topic."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateTopic(TopicModel topic) async {
    try {
      topic.updatedAt = DateTime.now();
      await topicCollection.doc(topic.id).update(topic.toJson());

      return {"status": true, "message": "Cập nhật topic thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật topic: $e"};
    }
  }

  Future<Map<String, dynamic>> getTopicInfoDTOByUserId(String userId) async {
    try {
      List<TopicInfoDTO> topicsInfo = [];
      var resultTopics = await getTopicsByUserId(userId);
      if (resultTopics["status"]) {
        List<Map<String, dynamic>> topicsData = resultTopics["data"];

        List<TopicModel> topics =
            topicsData.map((topic) => TopicModel.fromJson(topic)).toList();
        print("topic length" + topics.length.toString());
        var resultUser = await UserDao().getUserById(userId);
        if (resultUser["status"]) {
          UserModel user = UserModel.fromJson(resultUser["data"]);
          for (TopicModel topicModel in topics) {
            var result = await getTopicInfoDTOByTopicId(topicModel.id!);
            if (result["status"]) {
              topicsInfo.add(result["data"]);
            }
            print(result);
          }
          for (var element in topicsInfo) {
            print(element.vocabs);
          }
          return {"status": true, "data": topicsInfo};
        }
        return {"status": false, "message": resultUser["message"]};
      } else {
        return {"status": true, "data": topicsInfo};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getPublicTopicInfoDTOsByTopicName(String topicName) async {
    try {
      List<TopicInfoDTO> topicsInfo = [];
      var resultTopics = await getPublicTopicsByTopicName(topicName);
      if (resultTopics["status"]) {
        List<Map<String, dynamic>> topicsData = resultTopics["data"];

        List<TopicModel> topics =
          topicsData.map((topic) => TopicModel.fromJson(topic)).toList();
        for (TopicModel topicModel in topics) {
          var result = await getTopicInfoDTOByTopicId(topicModel.id!);
          if (result["status"]) {
            topicsInfo.add(result["data"]);
          }
          print(result);
        }
        for (var element in topicsInfo) {
          print(element.vocabs);
        }
        return {"status": true, "data": topicsInfo};
      }
      return {"status": false, "message": resultTopics["message"]};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  

  Future<Map<String, dynamic>> getTopicInfoDTOByTopicId(String topicId) async {
    try {
      var resultTopic = await getTopicById(topicId);
      if (resultTopic["status"]) {
        TopicModel topic = TopicModel.fromJson(resultTopic["data"]);
        var resultUser = await UserDao().getUserById(topic.userId);
        if (resultUser["status"]) {
          UserModel user = UserModel.fromJson(resultUser["data"]);

          var topicPlayed = await TopicPlayedNumberDao()
              .getTopicPlayedNumbersByTopicId(topicId);
          if (topicPlayed["status"]) {
            var vocabResult = await VocabularyDao().getVocabsByTopicId(topicId);
            if (vocabResult["status"]) {
              int vocabNumber = vocabResult["data"].length;
              List<Map<String, dynamic>> vocabLists = vocabResult["data"];
              List<VocabInfoDTO> vocabs = [];
              if (vocabLists.length > 0) {
                print(vocabLists);
                var newVocabsList = vocabLists
                    .map((value) => VocabularyModel.fromJson(value))
                    .toList();
                for (var vocab in newVocabsList) {
                  var result = await VocabularyStatusDao()
                      .getVocabularyStatusByVocabIdAndUserId(
                          vocab.id!, user.id!);
                  if (result["status"]) {
                    var vocabStatus = VocabularyStatus.fromJson(result["data"]);
                    vocabs.add(
                        VocabInfoDTO(vocab: vocab, vocabStatus: vocabStatus));
                  }
                }
              }
              // List<VocabularyStatus> vocabsStatus = [];
              // if(vocabs.length > 0){
              //   for (var vocab in vocabLists) {

              //   }
              // }
              var topicPlayCount = topicPlayed["data"];
              // int totalTimes = 0;
              // if (topicPlayCount.length > 0) {
              //   // List<TopicPlayedNumber> topicPlayCountModels = topicPlayCount
              //   //     .map((value) => TopicPlayedNumber.fromJson(value));
              //   totalTimes = topicPlayCount.fold(
              //       0,
              //       (previousValue, element) =>
              //           previousValue + (element.times ?? 0));
              // }
              // int totalPlayers = 0;
              // if (topicPlayCount.length > 0) {
              //   // List<TopicPlayedNumber> topicPlayCountModels = topicPlayCount
              //   //     .map((value) => TopicPlayedNumber.fromJson(value));
              //   totalTimes = topicPlayCount.fold(
              //       0,
              //       (previousValue, element) =>
              //           previousValue + (element.times ?? 0));
              // }
              TopicInfoDTO topicInfoDTO = TopicInfoDTO(
                topic: topic,
                authorName: user.displayName,
                playersCount: topicPlayCount.length,
                termNumbers: vocabNumber,
                userAvatar: user.photoURL,
                vocabs: vocabs,
              );
              return {"status": true, "data": topicInfoDTO};
            } else {
              return {"status": false, "data": vocabResult["message"]};
            }
          } else {
            return {"status": false, "data": topicPlayed["message"]};
          }
        } else {
          return {"status": false, "data": resultUser["message"]};
        }
      } else {
        return {"status": false, "message": "Không tìm thấy topic."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTopicRankingInfoDTOsByUserId(
      String userId) async {
    List<TopicRankingInfoDTO> topicRankingInfoDTOs = [];
    var resTopicPlay =
        await TopicPlayedNumberDao().getTopicPlayedNumbersByUserId(userId);
    if (resTopicPlay["status"]) {
      //list topic played
      if(resTopicPlay["data"].isNotEmpty){
        List<TopicPlayedNumber> topicPlayedNumber = resTopicPlay["data"];
      // List<String> topicPlayed = [];
      // for (var element in topicPlayedNumber) {
      //   topicPlayed.add(element.topicId);
      // }
      if (topicPlayedNumber.isNotEmpty) {
        for (var topicPlay in topicPlayedNumber) {
          var resTopic = await TopicDao().getTopicById(topicPlay.topicId);
          if (resTopic["status"]) {
            TopicModel topic = TopicModel.fromJson(resTopic["data"]);
            if(topic.private == true){
              continue;
            }
            else{
              //get participants
            var participants = await TopicPlayedNumberDao()
                .getTopicPlayedNumbersByTopicId(topicPlay.topicId);
            if (participants["status"]) {
              var totalParticipants = participants["data"].length;
              //get accuracy
              //
              var attempts = await TopicResultRecordDao().getTopicResultRecordsByTopicId(topicPlay.topicId);
              if(attempts["status"]){
                double accuracy = 100;
                if(attempts["data"].isNotEmpty){
                  List<TopicResultRecord> records = attempts["data"];
                  int correctNumber = 0;
                  int wrongNumber = 0;
                  int notAnsweredNumber = 0;
                  for (var record in records) {
                    correctNumber += record.correctAnswers;
                    wrongNumber += record.wrongAnswers;
                    notAnsweredNumber += record.notAnswers;
                  }
                  accuracy = correctNumber/(correctNumber+wrongNumber+notAnsweredNumber)*100;
                }
                TopicRankingInfoDTO ranking = TopicRankingInfoDTO(
                      topicId: topic.id!,
                      topicName: topic.name,
                      lastPlayed: topicPlay.updatedAt!,
                      participants: totalParticipants,
                      accuracy: accuracy
                );
                topicRankingInfoDTOs.add(ranking);
              }
              else{
                return {"status": false, "data": attempts["message"]};
              }
            } else {
              return {"status": false, "data": participants["message"]};
            }
            }
          } else {
            return {"status": false, "data": resTopic["message"]};
          }
        }
      }
      return {"status": true, "data": topicRankingInfoDTOs};
      }
      else{
        return {"status": true, "data": topicRankingInfoDTOs};
      }
      
    } else {
      return {"status": false, "data": resTopicPlay["message"]};
    }
  }

  Future<Map<String, dynamic>> getTopicRankingDetailInfoDTOByTopicId(String topicId) async {
    var topic = await getTopicById(topicId);
    if(topic["status"]){
      //topicName
      TopicModel topicModel = TopicModel.fromJson(topic["data"]);
      var attempts = await TopicResultRecordDao().getTopicResultRecordsByTopicId(topicId);
      if(attempts["status"]){
        List<TopicResultRecord> records = attempts["data"];
        //create dtos
        TopicRankingDetailInfoDTO topicRankingDetailInfoDTO = 
        TopicRankingDetailInfoDTO(topicName: topicModel.name, createdAt: topicModel.createdAt!, accuracy: 100, totalAttempts: records.length);
        //total attempts
        String? mostCorrectAnswerUserId;
        String? completedShortestTimeUserId;
        String? mostCorrectAnswerRecordId;
        String? completedShortestTimeRecordId;
        int mostCorrect = 0;
        int completedTime = 100000;
        List<Map<String, dynamic>> userPlayTimes = [];
        // if(records.isNotEmpty){
        //   completedTime = records[0].completedTime;
        //   if(records[0].wrongAnswers ==0 && records[0].notAnswers == 0){
        //     completedShortestTimeUserId = records[0].userId;
        //     completedShortestTimeRecordId = records[0].id;
        //   }
        // }
        int correctNumber = 0;
        int wrongNumber = 0;
        int notAnsweredNumber = 0;
        for (var record in records) {
          correctNumber += record.correctAnswers;
          wrongNumber += record.wrongAnswers;
          notAnsweredNumber += record.notAnswers;
          if(record.correctAnswers>mostCorrect){
            mostCorrect = record.correctAnswers;
            mostCorrectAnswerUserId = record.userId;
            mostCorrectAnswerRecordId = record.id;
          }
          if(record.completedTime < completedTime && record.wrongAnswers ==0 && record.notAnswers == 0){///100% accuracy
            completedTime = record.completedTime;
            completedShortestTimeUserId = record.userId;
            completedShortestTimeRecordId = record.id;
          }
          int index = userPlayTimes.indexWhere((element) => element['userId'] == record.userId);
          if (index != -1) {
            userPlayTimes[index]['count']++;
          } else {
            userPlayTimes.add({'userId': record.userId, 'count': 1});
          }
        }
        double accuracy = correctNumber/(correctNumber+wrongNumber+notAnsweredNumber)*100;
        topicRankingDetailInfoDTO.accuracy = accuracy;
        Map<String, dynamic> mostAttemptsUserMap = userPlayTimes.reduce((curr, next) =>
        (curr['count'] > next['count']) ? curr : next);
        //most attempts
        if(mostAttemptsUserMap!=null){
          var resUser = await UserDao().getUserById(mostAttemptsUserMap["userId"]);
          // RecordUser mostAttemptsUser;
          UserModel? userMostAttempts;
          if(resUser["status"]){
            userMostAttempts = UserModel.fromJson(resUser["data"]);
          }
          List<TopicResultRecord> mostAttemptRecords = [];
          TopicResultRecord? mostAttemptRecord;
          records.forEach((element) {
            if (element.userId == mostAttemptsUserMap["userId"]) {
              mostAttemptRecords.add(element);
            }
          });
          int mostCorrect = 0;
          for (var element in mostAttemptRecords) {
            if(element.correctAnswers > mostCorrect){
              mostAttemptRecord = element;
            }
          }
          RecordUser mostAttemptsUserRecord = 
          RecordUser(userName: userMostAttempts!.displayName, photoURL: userMostAttempts.photoURL!, 
          attemptNumbers: mostAttemptsUserMap["count"], correctAnswers: mostAttemptRecord!.correctAnswers, 
          wrongAnswers:  mostAttemptRecord!.wrongAnswers, notAnswered:  mostAttemptRecord!.notAnswers);

          topicRankingDetailInfoDTO.mostAttemptsUser = mostAttemptsUserRecord;
        }

        //shortest time
        if(completedShortestTimeUserId!=null){
          Map<String, dynamic> shortestTimeUserMap = userPlayTimes.where((element) => element["userId"] == completedShortestTimeUserId).first;
          var resShortestUser = await UserDao().getUserById(completedShortestTimeUserId);
            UserModel? userShortestTime;
          if(resShortestUser["status"]){
            userShortestTime = UserModel.fromJson(resShortestUser["data"]);
          }
          TopicResultRecord? shortestTimeRecord;
          records.forEach((element) {
            if (element.id == completedShortestTimeRecordId) {
              shortestTimeRecord = element;
            }
          });
          RecordUser userRecord = 
          RecordUser(userName: userShortestTime!.displayName, photoURL: userShortestTime.photoURL!, 
          attemptNumbers: shortestTimeUserMap["count"], correctAnswers: shortestTimeRecord!.correctAnswers, 
          wrongAnswers:  shortestTimeRecord!.wrongAnswers, notAnswered:  shortestTimeRecord!.notAnswers, shortestTime: completedTime);

          topicRankingDetailInfoDTO.completedShortestTimeUser = userRecord;
        }
        //most correct
        if(mostCorrectAnswerUserId!=null){
          Map<String, dynamic> mostCorrectAnswerUserMap = userPlayTimes.where((element) => element["userId"] == mostCorrectAnswerUserId).first;
          var resMostCorrectUser = await UserDao().getUserById(mostCorrectAnswerUserId);
            UserModel? userMostCorrect;
          if(resMostCorrectUser["status"]){
            userMostCorrect = UserModel.fromJson(resMostCorrectUser["data"]);
          }
          TopicResultRecord? mostCorrectRecord;
          records.forEach((element) {
            if (element.id == mostCorrectAnswerRecordId) {
              mostCorrectRecord = element;
            }
          });
          RecordUser userRecord = 
          RecordUser(userName: userMostCorrect!.displayName, photoURL: userMostCorrect.photoURL!, 
          attemptNumbers: mostCorrectAnswerUserMap["count"], correctAnswers: mostCorrectRecord!.correctAnswers, 
          wrongAnswers:  mostCorrectRecord!.wrongAnswers, notAnswered:  mostCorrectRecord!.notAnswers);

          topicRankingDetailInfoDTO.mostCorrectAnswerUser = userRecord;
        }
        return {"status": true, "data": topicRankingDetailInfoDTO}; 
      }
      else{
        return {"status": false, "data": attempts["message"]};  
      }
    }
    else{
      return {"status": false, "data": topic["message"]}; 
    }
  }
}
