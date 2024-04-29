import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_quizlet_english/models/User.dart';

class UserDao {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

  Future<Map<String, dynamic>> addUser(UserModel user) async {
    try {
      QuerySnapshot querySnapshot =
          await userCollection.where('email', isEqualTo: user.email).get();
      if (querySnapshot.docs.isNotEmpty) {
        return {"status": false, "message": "User exists"};
      }

      Map<String, dynamic> userData = user.toJson();

      await userCollection.add(userData);
      return {"status": true, "message": "User added successfully"};
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
        return {"status": true, "data": userData};
      } else {
        return {"status": false, "message": "User not found"};
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateUser(UserModel user) async {
    try {
      await userCollection.doc(user.id).update(user.toJson());

      return {"status": true, "message": "User updated successfully"};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
}
