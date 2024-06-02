import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/models/Folder.dart';

class FolderInfoDTO {

  FolderModel folder;
  List<TopicInfoDTO> topics;
  String userName;
  String userId;
  String? userAvatar;

  FolderInfoDTO({
    required this.folder,
    required this.topics,
    required this.userName,
    required this.userId,
    this.userAvatar,
  }
  );

  factory FolderInfoDTO.fromJson(Map<String, dynamic> json) {
    return FolderInfoDTO(
        folder: json['folder'],
        topics: json['topics'],
        userName: json['userName'],
        userId: json['userId'],
        userAvatar: json['userAvatar']
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'folder': folder,
      'topics': topics,
      'userName': userName,
      'userId': userId,
      'userAvatar': userAvatar,
    };
  }
}
