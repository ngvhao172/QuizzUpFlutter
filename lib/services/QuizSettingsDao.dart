import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/QuizSettings.dart';

class QuizSettingsDao{
  final CollectionReference quizSettingsCollection =
      FirebaseFirestore.instance.collection('QuizSettings');

  Future<Map<String, dynamic>> addQuizSettings(QuizSettings quizSettings) async {
    try {
      Map<String, dynamic> quizData = quizSettings.toJson();

      await quizSettingsCollection.add(quizData);
      return {"status": true, "message": "Thêm Quiz settings thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }  
    Future<Map<String, dynamic>> getQuizSettingsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await quizSettingsCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> quizData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (quizData["id"] == null) {
          quizData["id"] = querySnapshot.docs.first.id;
          updateQuizSettings(QuizSettings.fromJson(quizData));
        }
        return {"status": true, "data": quizData};
      } else {
        return {
          "status": false,
          "message": "Không tìm thấy Quiz settings."
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateQuizSettings(QuizSettings quizSettings) async {
    try {
      await quizSettingsCollection.doc(quizSettings.id!).update(quizSettings.toJson());

      return {"status": true, "message": "Cập nhật quiz settings thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật topic: $e"};
    }
  }
}
