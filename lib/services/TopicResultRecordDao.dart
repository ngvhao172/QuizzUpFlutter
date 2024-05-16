import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/TopicResultRecord.dart';

class TopicResultRecordDao {
  final CollectionReference topicResultRecordCollection =
      FirebaseFirestore.instance.collection('TopicResultRecord');

  Future<Map<String, dynamic>> addTopicResultRecord(TopicResultRecord topic) async {
    try {
      Map<String, dynamic> topicData = topic.toJson();

      var res = await topicResultRecordCollection.add(topicData);
      return {"status": true, "message": "Thêm topic result record thành công.", "data": res.id};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  Future<Map<String, dynamic>> getTopicResultRecordByDocId(String docId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await topicResultRecordCollection.doc(docId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> topicData =
            documentSnapshot.data() as Map<String, dynamic>;
        
        if (topicData["id"] == null) {
          topicData["id"] = documentSnapshot.id;
          updateTopicResultRecord(TopicResultRecord.fromJson(topicData));
        }
        return {"status": true, "data": TopicResultRecord.fromJson(topicData)};
      } else {
        return {"status": false, "message": "Không tìm thấy topic result record."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  Future<Map<String, dynamic>> getTopicResultRecordByUserIdAndTopicId(String userId, String topicId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicResultRecordCollection.where('userId', isEqualTo: userId).where("topicId", isEqualTo: topicId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> topicData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (topicData["id"] == null) {
          topicData["id"] = querySnapshot.docs.first.id;
          updateTopicResultRecord(TopicResultRecord.fromJson(topicData));
        }
        return {"status": true, "data": TopicResultRecord.fromJson(topicData)};
      } else {
        return {"status": false, "message": "Không tìm thấy topic result record."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getTopicResultRecordsByTopicId(String topicId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicResultRecordCollection.where('topicId', isEqualTo: topicId).get();

      if (querySnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> topicData =
            querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        for (var i = 0; i < topicData.length; i++) {
          if (topicData[i]["id"] == null) {
            topicData[i]["id"] = querySnapshot.docs[i].id;
            updateTopicResultRecord(TopicResultRecord.fromJson(topicData[i]));
          }
        }
        List<TopicResultRecord> topics = [];
        for (var element in topicData) { topics.add(TopicResultRecord.fromJson(element));}
        return {"status": true, "data": topics};
      } else {
        return {"status": true, "data": []};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  Future<Map<String, dynamic>> getTopicResultRecordsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicResultRecordCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> topicData =
            querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        for (var i = 0; i < topicData.length; i++) {
          if (topicData[i]["id"] == null) {
            topicData[i]["id"] = querySnapshot.docs[i].id;
            updateTopicResultRecord(TopicResultRecord.fromJson(topicData[i]));
          }
        }
        List<TopicResultRecord> topics = [];
        for (var element in topicData) { topics.add(TopicResultRecord.fromJson(element));}
        return {"status": true, "data": topics};
      } else {
        return {"status": true, "data": []};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateTopicResultRecord(TopicResultRecord topic) async {
    try {
      topic.updatedAt = DateTime.now();
      await topicResultRecordCollection.doc(topic.id).update(topic.toJson());

      return {"status": true, "message": "Cập nhật topic result record thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật topic: $e"};
    }
  }
}
