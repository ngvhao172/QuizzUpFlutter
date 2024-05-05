import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/TopicPlayCount.dart';

class TopicPlayCountDao {
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('TopicPlayCount');

  Future<Map<String, dynamic>> addTopicPlayCount(TopicPlayCount topic) async {
    try {
      Map<String, dynamic> topicData = topic.toJson();

      await topicCollection.add(topicData);
      return {"status": true, "message": "Thêm topic play thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTopicPlayCountByUserIdAndTopicId(String userId, String topicId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('userId', isEqualTo: userId).where("topicId", isEqualTo: topicId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> topicData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return {"status": true, "data": topicData};
      } else {
        return {"status": false, "message": "Không tìm thấy topic."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTopicsCountByTopicId(String topicId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('topicId', isEqualTo: topicId).get();

      if (querySnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> topicData =
            querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        return {"status": true, "data": topicData};
      } else {
        return {"status": true, "data": []};
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
}
