import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/TopicPlayedNumber.dart';

class TopicPlayedNumberDao {
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('TopicPlayedNumber');

  Future<Map<String, dynamic>> addTopicPlayedNumber(TopicPlayedNumber topic) async {
    try {
      Map<String, dynamic> topicData = topic.toJson();

      await topicCollection.add(topicData);
      return {"status": true, "message": "Thêm topic play thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTopicPlayedNumberByUserIdAndTopicId(String userId, String topicId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('userId', isEqualTo: userId).where("topicId", isEqualTo: topicId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> topicData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (topicData["id"] == null) {
          topicData["id"] = querySnapshot.docs.first.id;
          updateTopicPlayedNumber(TopicPlayedNumber.fromJson(topicData));
        }
        return {"status": true, "data": TopicPlayedNumber.fromJson(topicData)};
      } else {
        return {"status": false, "message": "Không tìm thấy topic."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  Future<Map<String, dynamic>> getTotalTopicPlayedNumberByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<TopicPlayedNumber> topicData =
            querySnapshot.docs.map((doc) => TopicPlayedNumber.fromJson(doc.data() as Map<String, dynamic>)).toList();
        int totalAttempts = 0;
        for (var topic in topicData) {
          totalAttempts += topic.times;
        }
        return {"status": true, "data": totalAttempts};
      } else {
        return {"status": true, "data": 0};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTopicPlayedNumbersByTopicId(String topicId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('topicId', isEqualTo: topicId).get();

      if (querySnapshot.docs.isNotEmpty) {
          List<TopicPlayedNumber> topicData =
            querySnapshot.docs.map((doc) => TopicPlayedNumber.fromJson(doc.data() as Map<String, dynamic>)).toList();
        return {"status": true, "data": topicData};
      } else {
        return {"status": true, "data": []};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  Future<Map<String, dynamic>> getTop5PublicTopicPlayedNumbers() async {
    try {
      QuerySnapshot querySnapshot = await topicCollection.get();

      if (querySnapshot.docs.isNotEmpty) {
          List<TopicPlayedNumber> topicData =
            querySnapshot.docs.map((doc) => TopicPlayedNumber.fromJson(doc.data() as Map<String, dynamic>)).toList();
        topicData.sort((a, b) => b.times.compareTo(a.times));

        List<TopicPlayedNumber> top5Topics = topicData.take(5).toList();
        return {"status": true, "data": top5Topics};
      } else {
        return {"status": true, "data": []};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  Future<Map<String, dynamic>> getTopicPlayedNumbersByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
          List<TopicPlayedNumber> topicData =
            querySnapshot.docs.map((doc) => TopicPlayedNumber.fromJson(doc.data() as Map<String, dynamic>)).toList();
        return {"status": true, "data": topicData};
      } else {
        return {"status": true, "data": []};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateTopicPlayedNumber(TopicPlayedNumber topic) async {
    try {
      topic.updatedAt = DateTime.now();
      await topicCollection.doc(topic.id).update(topic.toJson());

      return {"status": true, "message": "Cập nhật topic played thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật topic: $e"};
    }
  }
}
