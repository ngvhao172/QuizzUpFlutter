import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';

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

  Future<Map<String, dynamic>> getVocabulary(String vocabId) async {
    try {
      QuerySnapshot querySnapshot =
          await vocabCollection.where('id', isEqualTo: vocabId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> vocabData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if(vocabData["id"] == null){
            vocabData["id"] = querySnapshot.docs.first.id;
            updateVocabulary(VocabularyModel.fromJson(vocabData));
          }
        updateVocabulary(VocabularyModel.fromJson(vocabData));
        return {"status": true, "data": vocabData};
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
      return {"status": false, "message": "Lỗi khi cập nhật từ vựng: $e"};
    }
  }

  Future<Map<String, dynamic>> getVocabNumberByTopicId(String topicId) async {
  try {
    QuerySnapshot querySnapshot =
        await vocabCollection.where('topicId', isEqualTo: topicId).get();

    if (querySnapshot.docs.isNotEmpty) {
      int vocabNumber = querySnapshot.docs.length;
      return {"status": true, "data": vocabNumber};
    } else {
      return {"status": true, "data": 0};
    }
  } catch (e) {
    return {"status": false, "message": e.toString()};
  }
}
Future<Map<String, dynamic>> getVocabsByTopicId(String topicId) async {
  try {
    QuerySnapshot querySnapshot =
        await vocabCollection.where('topicId', isEqualTo: topicId).get();

    if (querySnapshot.docs.isNotEmpty) {
      List<Map<String, dynamic>> vocabsData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        for (var i = 0; i < vocabsData.length; i++) {
          if(vocabsData[i]["id"] == null){
            vocabsData[i]["id"] = querySnapshot.docs[i].id;
            updateVocabulary(VocabularyModel.fromJson(vocabsData[i]));
          }
        }
      return {"status": true, "data": vocabsData};
    } else {
      return {"status": true, "data": 0};
    }
  } catch (e) {
    return {"status": false, "message": e.toString()};
  }
}

   Future<Map<String, dynamic>> deleteVocabulary(String vocabId) async {
    try {
      await vocabCollection.doc(vocabId).delete();

      return {"status": true, "message": "Cập nhật từ vựng thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật từ vựng: $e"};
    }
  }

}
