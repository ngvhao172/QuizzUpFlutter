import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/TopicRecentlyAccessed.dart';

class TopicRecentlyAccessedDao {
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('TopicRecentlyAccessed');

  Future<Map<String, dynamic>> addTopicRecentlyAccessed(TopicRecentlyAccessed topicAccessed) async {
    try {
      Map<String, dynamic> topicAccessedData = topicAccessed.toJson();

      await topicCollection.add(topicAccessedData);
      return {"status": true, "message": "Thêm topic accessed thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTopicRecentlyAccessedByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> topicAccessedData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (topicAccessedData["id"] == null) {
          topicAccessedData["id"] = querySnapshot.docs.first.id;
          updatetopicAccessed(TopicRecentlyAccessed.fromJson(topicAccessedData));
        }
        return {"status": true, "data": TopicRecentlyAccessed.fromJson(topicAccessedData)};
      } else {
        return {"status": false, "data": "Không tìm thấy topic acccessed"};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatetopicAccessed(TopicRecentlyAccessed topicAccessed) async {
    try {
      await topicCollection.doc(topicAccessed.id).update(topicAccessed.toJson());

      return {"status": true, "message": "Cập nhật topic accessed thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật topic: $e"};
    }
  }
}
