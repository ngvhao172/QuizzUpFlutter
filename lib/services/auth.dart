import 'package:final_quizlet_english/models/User.dart';
import 'package:final_quizlet_english/services/UserDao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Future<User?> getCurrenUser() async {
  //   User? userLoggedIn = auth.currentUser;
  //   var user = await UserDao().getUserByEmail(auth.currentUser!.email.toString());
  //   userLoggedIn?.updateDisplayName(user["displayName"]);
  //   userLoggedIn?.updatePhotoURL(user["photoUrl"]);
  //   return userLoggedIn;
  // }
  Future<UserModel?> getCurrentUser() async {
    try {
      User? userLoggedIn = FirebaseAuth.instance.currentUser;
      if (userLoggedIn != null) {
        Map<String, dynamic> userMap =
            await UserDao().getUserByEmail(userLoggedIn.email.toString());
        if (userMap["status"]) {
          UserModel user = UserModel.fromJson(userMap["data"]);
          user.photoURL ??= userLoggedIn.photoURL.toString();
          return user;
        }
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
  Future<Map<String, dynamic>> updateEmail(String newEmail) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> result =
            await UserDao().getUserByEmail(newEmail);
    
    if(result["status"]==false){
      // await user?.updateEmail(newEmail);
      // await user?.sendEmailVerification();
      await user?.verifyBeforeUpdateEmail(newEmail);
      return {"status": true, "message": "An email has been sent to new email."};
    }
    else{
    return {"status": false, "message": "Email already in use."};
    }
  } on FirebaseAuthException catch (e) {

    return {"status": false, "message": e.message};
  } catch (e) {
    return {"status": false, "message": e.toString()};
  }
}

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        User? user = userCredential.user;

        if (user != null) {
          Map<String, dynamic> userInfoMap = {
            "email": user.email,
            "displayName": user.displayName,
            "photoURL": user.photoURL,
            "id": user.uid,
          };
          UserModel userSaved = UserModel.fromJson(userInfoMap);

          await UserDao().addUser(userSaved);
          return {"status": true, "message": "Login successful"};
        } else {
          return {"status": false, "message": "Login failed"};
        }
      } else {
        return {"status": false, "message": "User cancelled the login"};
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Error signing in with Google: $e",
      };
    }
  }

  void changePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
        print("Mật khẩu đã được thay đổi thành công!");
      } else {
        print("Người dùng chưa đăng nhập.");
      }
    } catch (e) {
      print("Lỗi khi thay đổi mật khẩu: $e");
    }
  }

  // signInWithGoogle() async {
  //   try {
  //     final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //     final GoogleSignIn googleSignIn = GoogleSignIn();

  //     final GoogleSignInAccount? googleSignInAccount =
  //         await googleSignIn.signIn();

  //     final GoogleSignInAuthentication? googleSignInAuthentication =
  //         await googleSignInAccount?.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //         idToken: googleSignInAuthentication?.idToken,
  //         accessToken: googleSignInAuthentication?.accessToken);

  //     UserCredential result =
  //         await firebaseAuth.signInWithCredential(credential);

  //     User? userDetails = result.user;

  //     if (result != null) {
  //       Map<String, dynamic> userInfoMap = {
  //         "email": userDetails!.email,
  //         "name": userDetails.displayName,
  //         "imgUrl": userDetails.photoURL,
  //         "id": userDetails.uid
  //       };
  //       // await UserDao().addUser(UserModel.fromJson(userInfoMap));
  //       return {"status": true, "message": "Login successful"};
  //     } else {
  //       return {"status": false, "message": "User cancelled the login"};
  //     }
  //   } catch (e) {
  //     return {
  //       "status": false,
  //       "message": "Error signing in with Google: $e",
  //     };
  //   }
  // }
}
