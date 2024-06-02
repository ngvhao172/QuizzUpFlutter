import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/VocabFavourite.dart';

class VocabularyFavDao {
  final CollectionReference vocabFavCollection =
      FirebaseFirestore.instance.collection('VocabularyFavourite');

  Future<Map<String, dynamic>> addVocabularyFav(
      VocabFavouriteModel vocab) async {
    try {
      Map<String, dynamic> vocabData = vocab.toJson();

      await vocabFavCollection.add(vocabData);
      return {"status": true, "message": "Thêm từ vựng yêu thích thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getVocabularyFav(String vocabFavId) async {
    try {
      QuerySnapshot querySnapshot =
          await vocabFavCollection.where('id', isEqualTo: vocabFavId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> vocabData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (vocabData["id"] == null) {
          vocabData["id"] = querySnapshot.docs.first.id;
          updateVocabularyFav(VocabFavouriteModel.fromJson(vocabData));
        }
        return {"status": true, "data": vocabData};
      } else {
        return {
          "status": false,
          "message": "Không tìm thấy từ vựng yêu thích."
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getVocabularyFavByVocabIdAndTopicId(
      String vocabFavId, String topicId) async {
    try {
      QuerySnapshot querySnapshot = await vocabFavCollection
          .where('id', isEqualTo: vocabFavId)
          .where('topicId', isEqualTo: topicId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> vocabData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (vocabData["id"] == null) {
          vocabData["id"] = querySnapshot.docs.first.id;
          updateVocabularyFav(VocabFavouriteModel.fromJson(vocabData));
        }
        return {"status": true, "data": vocabData};
      } else {
        return {
          "status": false,
          "message": "Không tìm thấy từ vựng yêu thích."
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getVocabularysFavByUserIdAndTopicId(
      String userId, String topicId) async {
    try {
      QuerySnapshot querySnapshot = await vocabFavCollection
          .where('userId', isEqualTo: userId)
          .where('topicId', isEqualTo: topicId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> vocabsData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        for (var i = 0; i < vocabsData.length; i++) {
          if (vocabsData[i]["id"] == null) {
            vocabsData[i]["id"] = querySnapshot.docs[i].id;
            updateVocabularyFav(VocabFavouriteModel.fromJson(vocabsData[i]));
          }
        }
        List<VocabFavouriteModel> vocabsDataFav = vocabsData
            .map((vocab) => VocabFavouriteModel.fromJson(vocab))
            .toList();
        return {"status": true, "data": vocabsDataFav};
      } else {
        return {
          "status": false,
          "message": "Không tìm thấy từ vựng yêu thích."
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateVocabularyFav(
      VocabFavouriteModel vocab) async {
    try {
      await vocabFavCollection.doc(vocab.id).update(vocab.toJson());

      return {
        "status": true,
        "message": "Cập nhật từ vựng yêu thích thành công."
      };
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật từ vựng: $e"};
    }
  }

  Future<Map<String, dynamic>> deleteVocabularyFav(
      String vocabFavId, String userId) async {
    try {
      await vocabFavCollection
          .where("vocabularyId", isEqualTo: vocabFavId)
          .where("userId", isEqualTo: userId)
          .limit(1)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.delete();
        });
      });

      return {"status": true, "message": "Xóa từ vựng thành yêu thích thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi xóa từ vựng: $e"};
    }
  }
}
