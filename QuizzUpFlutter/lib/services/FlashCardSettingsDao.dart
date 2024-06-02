import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/FlashCardSettings.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/TopicPlayCount.dart';

class FlashCardSettingsDao{
  final CollectionReference flashCardSettingsCollection =
      FirebaseFirestore.instance.collection('FlashCardSettings');

  Future<Map<String, dynamic>> addFlashCardSettings(FlashCardSettings flashCardSettings) async {
    try {
      Map<String, dynamic> flashCardData = flashCardSettings.toJson();

      await flashCardSettingsCollection.add(flashCardData);
      return {"status": true, "message": "Thêm flashcard settings thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }  
    Future<Map<String, dynamic>> getFlashCardSettingsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await flashCardSettingsCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> flashCardData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (flashCardData["id"] == null) {
          flashCardData["id"] = querySnapshot.docs.first.id;
          updateFlashCardSettings(FlashCardSettings.fromJson(flashCardData));
        }
        return {"status": true, "data": flashCardData};
      } else {
        return {
          "status": false,
          "message": "Không tìm thấy flashcard settings."
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateFlashCardSettings(FlashCardSettings flashCardSettings) async {
    try {
      await flashCardSettingsCollection.doc(flashCardSettings.id!).update(flashCardSettings.toJson());

      return {"status": true, "message": "Cập nhật flash card settings thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật topic: $e"};
    }
  }
}
