import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/TopicPlayCount.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';
import 'package:final_quizlet_english/services/TopicPlayCountDao.dart';
import 'package:final_quizlet_english/services/UserDao.dart';
import 'package:final_quizlet_english/services/VocabDao.dart';

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

        if(topicData["id"] == null){
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
          if(topicsData[i]["id"] == null){
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
        var resultUser = await UserDao().getUserById(userId);
        if (resultUser["status"]) {
          UserModel user = UserModel.fromJson(resultUser["data"]);

          for (TopicModel topicModel in topics) {
            var result = await TopicPlayCountDao()
                .getTopicsCountByTopicId(topicModel.id!);
            if (result["status"]) {
              var vocabResult =
                  await VocabularyDao().getVocabNumberByTopicId(topicModel.id!);
              if (vocabResult["status"]) {
                int vocabNumber = vocabResult["data"];

                var topicPlayCount = result["data"];
                int totalTimes = 0;
                if (topicPlayCount.length > 0) {
                  List<TopicPlayCount> topicPlayCountModels = topicPlayCount
                      .map((value) => TopicPlayCount.fromJson(value));
                  totalTimes = topicPlayCountModels.fold(
                      0,
                      (previousValue, element) =>
                          previousValue + (element.times ?? 0));
                }
                TopicInfoDTO topicInfoDTO = TopicInfoDTO(
                    topic: topicModel,
                    authorName: user.displayName,
                    playersCount: totalTimes,
                    termNumbers: vocabNumber,
                    userAvatar: user.photoURL);
                topicsInfo.add(topicInfoDTO);
              } else {
                return {"status": false, "message": vocabResult["message"]};
              }
            } else {
              return {"status": false, "message": result["message"]};
            }
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

  Future<Map<String, dynamic>> getTopicInfoDTOByTopicId(String topicId) async {
    try {
      var resultTopic = await getTopicById(topicId);
      if (resultTopic["status"]) {
        TopicModel topic = TopicModel.fromJson(resultTopic["data"]);
        var resultUser = await UserDao().getUserById(topic.userId!);
        if (resultUser["status"]) {
          UserModel user = UserModel.fromJson(resultUser["data"]);

          var result =
              await TopicPlayCountDao().getTopicsCountByTopicId(topicId);
          if (result["status"]) {
            var vocabResult = await VocabularyDao().getVocabsByTopicId(topicId);
          if (vocabResult["status"]) {
            int vocabNumber = vocabResult["data"].length;
            List<Map<String, dynamic>> vocabLists = vocabResult["data"];
            List<VocabularyModel> vocabs = [];
            if (vocabLists.length > 0) {
              print(vocabLists);
              vocabs = vocabLists.map((value) => VocabularyModel.fromJson(value)).toList();
            }
              var topicPlayCount = result["data"];
              int totalTimes = 0;
              if (topicPlayCount.length > 0) {
                List<TopicPlayCount> topicPlayCountModels = topicPlayCount
                    .map((value) => TopicPlayCount.fromJson(value));
                totalTimes = topicPlayCountModels.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + (element.times ?? 0));
              }
              TopicInfoDTO topicInfoDTO = TopicInfoDTO(
              topic: topic,
              authorName: user.displayName,
              playersCount: totalTimes,
              termNumbers: vocabNumber,
              userAvatar: user.photoURL,
              vocabs: vocabs,
            );
              return {"status": true, "data": topicInfoDTO};
            } else {
              return {"status": false, "data": vocabResult["message"]};
            }
          } else {
            return {"status": false, "data": result["message"]};
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


Stream<Map<String, dynamic>> getTopicInfoDTOByTopicIdRealtime(String topicId) async* {
  try {
    var resultTopic = await getTopicById(topicId);
    if (resultTopic["status"]) {
      TopicModel topic = TopicModel.fromJson(resultTopic["data"]);
      var resultUser = await UserDao().getUserById(topic.userId!);
      if (resultUser["status"]) {
        UserModel user = UserModel.fromJson(resultUser["data"]);

        var result = await TopicPlayCountDao().getTopicsCountByTopicId(topicId);
        if (result["status"]) {
          var vocabResult = await VocabularyDao().getVocabsByTopicId(topicId);
          if (vocabResult["status"]) {
            int vocabNumber = vocabResult["data"].length;
            List<Map<String, dynamic>> vocabLists = vocabResult["data"];
            List<VocabularyModel> vocabs = [];
            if (vocabLists.length > 0) {
              print(vocabLists);
              vocabs = vocabLists.map((value) => VocabularyModel.fromJson(value)).toList();
            }
            var topicPlayCount = result["data"];
            int totalTimes = 0;
            if (topicPlayCount.length > 0) {
              List<TopicPlayCount> topicPlayCountModels = topicPlayCount.map((value) => TopicPlayCount.fromJson(value));
              totalTimes = topicPlayCountModels.fold(0, (previousValue, element) => previousValue + (element.times ?? 0));
            }
            TopicInfoDTO topicInfoDTO = TopicInfoDTO(
              topic: topic,
              authorName: user.displayName,
              playersCount: totalTimes,
              termNumbers: vocabNumber,
              userAvatar: user.photoURL,
              vocabs: vocabs,
            );
            yield {"status": true, "data": topicInfoDTO};
          } else {
            yield {"status": false, "data": vocabResult["message"]};
          }
        } else {
          yield {"status": false, "data": result["message"]};
        }
      } else {
        yield {"status": false, "data": resultUser["message"]};
      }
    } else {
      yield {"status": false, "message": "Không tìm thấy topic."};
    }
  } catch (e) {
    yield {"status": false, "message": e.toString()};
  }
}

}
