import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/TopicTypeSetting.dart';

class TypeSettingsDao{
  final CollectionReference TypeSettingsCollection =
      FirebaseFirestore.instance.collection('TypeSettings');

  Future<Map<String, dynamic>> addTypeSettings(TopicTypeSettings typeSettings) async {
    try {
      Map<String, dynamic> typeData = typeSettings.toJson();

      await TypeSettingsCollection.add(typeData);
      return {"status": true, "message": "Thêm type settings thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }  
    Future<Map<String, dynamic>> getTypeSettingsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await TypeSettingsCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> typeData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (typeData["id"] == null) {
          typeData["id"] = querySnapshot.docs.first.id;
          updateTypeSettings(TopicTypeSettings.fromJson(typeData));
        }
        return {"status": true, "data": typeData};
      } else {
        return {
          "status": false,
          "message": "Không tìm thấy type settings."
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateTypeSettings(TopicTypeSettings typeSettings) async {
    try {
      await TypeSettingsCollection.doc(typeSettings.id!).update(typeSettings.toJson());

      return {"status": true, "message": "Cập nhật type settings thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật topic: $e"};
    }
  }
}
