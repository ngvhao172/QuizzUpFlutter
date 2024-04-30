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
      User? userLoggedIn = auth.currentUser;
      print(userLoggedIn?.providerData[0].providerId);
      if (userLoggedIn != null) {
        Map<String, dynamic> userMap =
            await UserDao().getUserByEmail(userLoggedIn.email.toString());
        if (userMap["status"]) {
          UserModel user = UserModel.fromJson(userMap["data"]);
          user.photoURL ??= userLoggedIn.photoURL.toString();
          user.userInfos = userLoggedIn.providerData;
          return user;
        }
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>> updateEmail(String newEmail) async {
    try {
      User? user = auth.currentUser;

      Map<String, dynamic> result = await UserDao().getUserByEmail(newEmail);

      if (result["status"] == false) {
        await user?.verifyBeforeUpdateEmail(newEmail);
        return {
          "status": true,
          "message": "Một email đã được gửi đến email mới để xác nhận."
        };
      } else {
        return {"status": false, "message": "Email này đã được sử dụng."};
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
            await auth.signInWithCredential(credential);

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
          return {"status": true, "message": "Đăng nhập thành công."};
        } else {
          return {"status": false, "message": "Đăng nhập thất bại."};
        }
      } else {
        return {"status": false, "message": "Người dùng hủy thao tác."};
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Lỗi đăng nhập với Google: $e",
      };
    }
  }

  
  reAuthAccount(String oldPassword) async {
    try {
      User? user = auth.currentUser;

      if (user != null && user.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!.trim().toString(),
        password: oldPassword.trim(),
      );
      UserCredential userReAuth = await user.reauthenticateWithCredential(credential);

      if(userReAuth.user!.email == user.email){
        return {"status": true, "message": "Re-authenticated thành công."};
      }
    }
   else {
    return {"status": false, "message": "Người dùng chưa đăng nhập."};
      }
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
       return {"status": false, "message": "Lỗi khi xác thực người dùng: ${e.message.toString()}."};
    }
  }

  creataNewPassword(String newPassword) async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        return {"status": true, "message": "Mật khẩu đã được thay đổi thành công!"};
      } else {
        return {"status": false, "message": "Người dùng chưa đăng nhập."};
      }
    }  on FirebaseAuthException catch (e) {
      print(e.message.toString());
       return {"status": false, "message": "Lỗi khi thay đổi mật khẩu: $e."};
    }
  }


  reAuthGoogle() async {
    try {
      User? user = auth.currentUser;

      if (user != null && user.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {

      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        UserCredential userReAuth = await user.reauthenticateWithCredential(credential);

        if(userReAuth.user!.email == user.email){
          return {"status": true, "message": "Re-authenticated thành công."};
        }
      }
    }
   else {
    return {"status": false, "message": "Người dùng chưa đăng nhập."};
      }
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
       return {"status": false, "message": "Lỗi khi xác thực người dùng: ${e.message}."};
    }
  }

  login(String email, String password) async {
    try {
      UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);

      if(userCredential.user!.emailVerified){
        return {"status": true, "message": "Đăng nhập thành công."};
      }
      return {"status": "not-verified", "message": "Vui lòng xác minh tài khoản trước khi đăng nhập."};
      
    } on FirebaseAuthException catch (e) {
      if(e.code == "invalid-credential"){
          return {"status": false, "message": "Tài khoản không tồn tại hoặc mật khẩu không chính xác."};
      }
      if(e.code == "invalid-email"){
        return {"status": false, "message": "Email không hợp lệ."};
      }
      return {"status": false, "message": e.message.toString()};
      
    }
  }

  register(String displayName, String email, String password) async {
    Map<String, dynamic> userInfoMap = {
      "displayName": displayName,
      "email": email,
      "password": password,
    };
    try {
      UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();

      Map<String, dynamic> result =
          await UserDao().addUser(UserModel.fromJson(userInfoMap));

      if (result["status"]) {
        User? user = FirebaseAuth.instance.currentUser;
        user?.updateDisplayName(displayName);
        return result;
      } else {
        await userCredential.user?.delete();
        return result;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      if(e.code == "weak-password"){
        return {"status": false, "message": "Mật khẩu phải chứa ít nhất 6 kí tự."};
      }
      if(e.code == "email-already-in-use"){
        return {"status": false, "message": "Tài khoản đã tồn tại."};
      }
      return {"status": false, "message": e.message.toString()};
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return {
        "status": true,
        "message": "Một email xác nhận đã được gửi đến email của bạn.",
      };
    } on FirebaseAuthException catch (e) {
      print(e);
      if(e.code == "invalid-email"){
        return {"status": false, "message": "Email không hợp lệ."};
      }
      return {
        "status": false,
        "message": e.message.toString(),
      };
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
