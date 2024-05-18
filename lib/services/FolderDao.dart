import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/dtos/FolderInfo.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/models/Topic.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/screens/library.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:final_quizlet_english/services/UserDao.dart';

class FolderDao {
  final CollectionReference folderCollection =
      FirebaseFirestore.instance.collection('Folder');

  Future<Map<String, dynamic>> addFolder(FolderModel folder) async {
    try {
      Map<String, dynamic> folderData = folder.toJson();

      var folderAdded = await folderCollection.add(folderData);
      String folderId = folderAdded.id;

      if (folderData['id'] == null) {
        folderData['id'] = folderId;
        await folderAdded.update({'id': folderId});
      }

      return {
        "status": true,
        "message": "Thêm folder thành công.",
        "data": folderId
      };
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolderByDocId(String folderId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await folderCollection.doc(folderId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> folderData =
            documentSnapshot.data() as Map<String, dynamic>;

        if (folderData["id"] == null) {
          folderData["id"] = documentSnapshot.id;
          updateFolder(FolderModel.fromJson(folderData));
        }
        var folderObj = FolderModel.fromJson(folderData);
        return {"status": true, "data": folderObj};
      } else {
        return {"status": false, "message": "Không tìm thấy folder."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getFolderById(String folderId) async {
    try {
      QuerySnapshot querySnapshot =
          await folderCollection.where('id', isEqualTo: folderId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> folderData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        if (folderData["id"] == null) {
          folderData["id"] = querySnapshot.docs.first.id;
          updateFolder(FolderModel.fromJson(folderData));
        }
        updateFolder(FolderModel.fromJson(folderData));
        return {"status": true, "data": folderData};
      } else {
        return {"status": false, "message": "Không tìm thấy folder."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getFoldersByTopicId(String topicId) async {
    try {
      QuerySnapshot querySnapshot = await folderCollection
          .where('topicIds', arrayContains: topicId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> foldersData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        for (var i = 0; i < foldersData.length; i++) {
          if (foldersData[i]["id"] == null) {
            foldersData[i]["id"] = querySnapshot.docs[i].id;
            updateFolder(FolderModel.fromJson(foldersData[i]));
          }
        }
        var foldersDataObj =
            foldersData.map((e) => FolderModel.fromJson(e)).toList();
        return {"status": true, "data": foldersDataObj};
      } else {
        return {"status": false, "message": "Không tìm thấy folder nào."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
  Future<Map<String, dynamic>> getTotalFoldersByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot = await folderCollection
          .where('userId', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> foldersData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        for (var i = 0; i < foldersData.length; i++) {
          if (foldersData[i]["id"] == null) {
            foldersData[i]["id"] = querySnapshot.docs[i].id;
            updateFolder(FolderModel.fromJson(foldersData[i]));
          }
        }
        return {"status": true, "data": foldersData.length};
      } else {
        return {"status": true, "data": 0};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  // Future<Map<String, dynamic>> getFoldersInfoDTOByUserId(String userId) async {
  //   try {
  //     var result = await getFoldersByUserId(userId);
  //     if(result["status"]){

  //     }

  //   } catch (e) {
  //     return {"status": false, "message": e.toString()};
  //   }
  // }

  Future<Map<String, dynamic>> getFolderInfoDTOByFolderIdAndUserId(
      String folderId, String userId) async {
    try {
      var resultFolder = await getFolderById(folderId);
      if (resultFolder["status"]) {
        FolderModel folder = FolderModel.fromJson(resultFolder["data"]);
        List<TopicInfoDTO> topics = [];
        if (folder.topicIds != null) {
          for (var i = 0; i < folder.topicIds!.length; i++) {
            var resultTopic =
                await TopicDao().getTopicInfoDTOByTopicIdAndUserId(folder.topicIds![i], userId);
            if (resultTopic["status"]) {
              TopicInfoDTO topic = resultTopic["data"];
              topics.add(topic);
            } else {
              print(resultTopic["message"]);
            }
          }
        }
        FolderInfoDTO folderInfoDTO = FolderInfoDTO(
            folder: folder,
            topics: topics,
            userName: "",
            userId: "",
            userAvatar: null);
        var resultUser = await UserDao().getUserById(folder.userId);

        if (resultUser["status"]) {
          UserModel user = UserModel.fromJson(resultUser["data"]);
          folderInfoDTO.userName = user.displayName;
          folderInfoDTO.userAvatar = user.photoURL;
          folderInfoDTO.userId = user.id!;
        }
        return {"status": true, "data": folderInfoDTO};
      } else {
        return {"status": false, "message": "Không tìm thấy folder."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateFolder(FolderModel folder) async {
    try {
      await folderCollection.doc(folder.id).update(folder.toJson());

      return {"status": true, "message": "Cập nhật folder thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật folder: $e"};
    }
  }

  Future<Map<String, dynamic>> getFolderNumberByfolderId(
      String folderId) async {
    try {
      QuerySnapshot querySnapshot =
          await folderCollection.where('folderId', isEqualTo: folderId).get();

      if (querySnapshot.docs.isNotEmpty) {
        int folderNumber = querySnapshot.docs.length;
        return {"status": true, "data": folderNumber};
      } else {
        return {"status": true, "data": 0};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getFoldersByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await folderCollection.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> foldersData = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
        for (var i = 0; i < foldersData.length; i++) {
          if (foldersData[i]["id"] == null) {
            foldersData[i]["id"] = querySnapshot.docs[i].id;
            updateFolder(FolderModel.fromJson(foldersData[i]));
          }
        }
        var foldersDataObj =
            foldersData.map((e) => FolderModel.fromJson(e)).toList();
        return {"status": true, "data": foldersDataObj};
      } else {
        return {"status": true, "data": []};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteFolderById(String folderId) async {
    try {
      await folderCollection.doc(folderId).delete();

      return {"status": true, "message": "Cập nhật folder thành công."};
    } catch (e) {
      return {"status": false, "message": "Lỗi khi cập nhật folder: $e"};
    }
  }

  Future<void> addTopicIdToFolder(String folderId, String topicId) async {
    try {
      DocumentReference folderRef = folderCollection.doc(folderId);

      await folderRef.update({
        'topicIds': FieldValue.arrayUnion([topicId])
      });
      print('TopicId added successfully to folder!');
    } catch (e) {
      print('Error adding topicId to folder: $e');
    }
  }

  Future<void> removeTopicIdFromFolder(String folderId, String topicId) async {
    try {
      DocumentReference folderRef = folderCollection.doc(folderId);

      await folderRef.update({
        'topicIds': FieldValue.arrayRemove([topicId])
      });
      print('TopicId removed successfully from folder!');
    } catch (e) {
      print('Error removing topicId from folder: $e');
    }
  }
}
