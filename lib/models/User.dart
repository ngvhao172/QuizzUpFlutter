import 'package:firebase_auth/firebase_auth.dart';

class UserModel {

  String? id;
  String email;
  String displayName;
  String? phoneNumber;
  String? photoURL;
  List<UserInfo>? userInfos;

  UserModel({
    this.id,
    required this.email,
    required this.displayName,
    this.photoURL,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'phoneNumber': phoneNumber,
    };
  }
}
