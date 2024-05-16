import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/HistorySearch.dart';

class HistorySearchDao {
  final CollectionReference topicCollection =
      FirebaseFirestore.instance.collection('HistorySearch');

  Future<Map<String, dynamic>> addHistorySearch(HistorySearch history) async {
    try {
      Map<String, dynamic> historyData = history.toJson();

      await topicCollection.add(historyData);
      return {"status": true, "message": "Thêm history search thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getHistorySearchsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await topicCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> historyData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        for (var history in historyData) {
          if (history["id"] == null) {
            history["id"] = querySnapshot.docs.first.id;
            updateHistorySerch(HistorySearch.fromJson(history));
          }
        }
        return {"status": true, "data": historyData};
      } else {
        return {"status": true, "data": []};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateHistorySerch(HistorySearch history) async {
    try {
      await topicCollection.doc(history.id).update(history.toJson());

      return {"status": true, "message": "Cập nhật topic played thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật topic: $e"};
    }
  }
}
