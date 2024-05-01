import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';
import 'package:final_quizlet_english/models/User.dart';

class VocabularyDao {
  final CollectionReference vocabCollection =
      FirebaseFirestore.instance.collection('Vocabulary');

  Future<Map<String, dynamic>> addVocabulary(VocabularyModel vocab) async {
    try {
      Map<String, dynamic> vocabData = vocab.toJson();

      await vocabCollection.add(vocabData);
      return {"status": true, "message": "Thêm từ vựng thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getVocabulary(String setId) async {
    try {
      QuerySnapshot querySnapshot =
          await vocabCollection.where('id', isEqualTo: setId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> setData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        return {"status": true, "data": setData};
      } else {
        return {"status": false, "message": "Không tìm thấy từ vựng."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateVocabulary(VocabularyModel vocab) async {
    try {
      await vocabCollection.doc(vocab.id).update(vocab.toJson());

      return {"status": true, "message": "Cập nhật từ vựng thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật từ vựng: " + e.toString()};
    }
  }
}
