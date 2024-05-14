import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/VocabStatus.dart';

class VocabularyStatusDao {
  final CollectionReference vocabStatusCollection =
      FirebaseFirestore.instance.collection('VocabularyStatus');

  Future<Map<String, dynamic>> addVocabularyStatus(
      VocabularyStatus vocab) async {
    try {
      Map<String, dynamic> vocabData = vocab.toJson();

      await vocabStatusCollection.add(vocabData);
      return {"status": true, "message": "Thêm trạng thái từ vựng thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getVocabularyStatusByVocabIdAndUserId(String vocabId, String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await vocabStatusCollection.where('vocabularyId', isEqualTo: vocabId).where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> vocabData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (vocabData["id"] == null) {
          vocabData["id"] = querySnapshot.docs.first.id;
          updateVocabularyStatus(VocabularyStatus.fromJson(vocabData));
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

  // Future<Map<String, dynamic>> getVocabularyFavByVocabIdAndTopicId(
  //     String vocabFavId, String topicId) async {
  //   try {
  //     QuerySnapshot querySnapshot = await vocabStatusCollection
  //         .where('id', isEqualTo: vocabFavId)
  //         .where('topicId', isEqualTo: topicId)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       Map<String, dynamic> vocabData =
  //           querySnapshot.docs.first.data() as Map<String, dynamic>;
  //       if (vocabData["id"] == null) {
  //         vocabData["id"] = querySnapshot.docs.first.id;
  //         updateVocabularyFav(VocabFavouriteModel.fromJson(vocabData));
  //       }
  //       return {"status": true, "data": vocabData};
  //     } else {
  //       return {
  //         "status": false,
  //         "message": "Không tìm thấy từ vựng yêu thích."
  //       };
  //     }
  //   } catch (e) {
  //     return {"status": false, "message": e.toString()};
  //   }
  // }

  Future<Map<String, dynamic>> getVocabularysStatusByUserIdAndTopicId(
      String userId, String topicId) async {
    try {
      QuerySnapshot querySnapshot = await vocabStatusCollection
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
            updateVocabularyStatus(VocabularyStatus.fromJson(vocabsData[i]));
          }
        }
        List<VocabularyStatus> vocabsDataFav = vocabsData
            .map((vocab) => VocabularyStatus.fromJson(vocab))
            .toList();
        return {"status": true, "data": vocabsDataFav};
      } else {
        return {
          "status": false,
          "message": "Không tìm thấy các trạng thái từ vựng."
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateVocabularyStatus(
      VocabularyStatus vocab) async {
    try {
      await vocabStatusCollection.doc(vocab.id).update(vocab.toJson());

      return {
        "status": true,
        "message": "Cập nhật từ vựng yêu thích thành công."
      };
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật từ vựng: $e"};
    }
  }

   Future<Map<String, dynamic>> updateVocabularyStatusStatus(String vocabStatusId, int status) async {
  try {
    await vocabStatusCollection.doc(vocabStatusId).update({
      'status': status,
    });

    var updatedDoc = await vocabStatusCollection.doc(vocabStatusId).get();
    var updatedData = updatedDoc.data() as Map<String, dynamic>;

    return {
      "status": true,
      "message": "Cập nhật trạng thái từ vựng thành công.",
      "data": VocabularyStatus.fromJson(updatedData) 
    };
  } catch (e) {
    return {
      "status": false,
      "message": "Lỗi khi cập nhật từ vựng: $e"
    };
  }
}

  Future<Map<String, dynamic>> deleteVocabularyStatus(
      String vocabFavId, String userId) async {
    try {
      await vocabStatusCollection
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
