import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/services/FolderDao.dart';
import 'package:final_quizlet_english/services/TopicDao.dart';
import 'package:final_quizlet_english/services/TopicPlayedNumberDao.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UserDao {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> addUser(UserModel user) async {
    try {
      QuerySnapshot querySnapshot =
          await userCollection.where('email', isEqualTo: user.email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return {"status": false, "message": "Người dùng đã tồn tại."};
      }

      Map<String, dynamic> userData = user.toJson();

      await userCollection.add(userData);
      return {"status": true, "message": "Đăng ký thành công."};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await userCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        userData['id'] = querySnapshot.docs.first.id;
        //cập nhật userId
        updateUser(UserModel.fromJson(userData));
        return {"status": true, "data": userData};
      } else {
        return {"status": false, "message": "Không tìm thấy người dùng."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getUserById(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await userCollection.where('id', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;
        userData['id'] = querySnapshot.docs.first.id;
        return {"status": true, "data": userData};
      } else {
        return {"status": false, "message": "Không tìm thấy người dùng."};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateUser(UserModel user) async {
    try {
      await userCollection.doc(user.id).update(user.toJson());

      return {
        "status": true,
        "message": "Cập nhật thông tin người dùng thành công."
      };
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> uploadImageToStorage(
      String childName, Uint8List file) async {
    try {
      Reference ref = _storage.ref().child(childName);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return {"status": true, "data": downloadUrl};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> getStatistic(String userId) async {
    try {
      int totalTopic = 0;
      int totalFolder = 0;
      int totalTimes = 0;
      var resTopics = await TopicDao().getTotalTopicsByUserId(userId);
      if(resTopics["status"]){
        totalTopic = resTopics["data"];
      }
      var resFolders = await FolderDao().getTotalFoldersByUserId(userId);
      if(resFolders["status"]){
        totalFolder = resFolders["data"];
      }
      var resTotalTimes = await TopicPlayedNumberDao().getTotalTopicPlayedNumberByUserId(userId);
      if(resTotalTimes["status"]){
        totalTimes = resTotalTimes["data"];
      }
      Map<String, int> res = {"totalTopics" : totalTopic, "totalFolders" : totalFolder, "totalAttempts" : totalTimes};
      return {"status": true, "data": res};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
}
