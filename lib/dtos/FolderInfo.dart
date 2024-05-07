import 'package:final_quizlet_english/models/Folder.dart';

class FolderInfoDTO {

  int topicNumbers;
  FolderModel Folder;

  FolderInfoDTO({
    required this.topicNumbers,
    required this.Folder,
  }
  );

  factory FolderInfoDTO.fromJson(Map<String, dynamic> json) {
    return FolderInfoDTO(
        Folder: json['Folder'],
        topicNumbers: json['topicNumbers']
        );
  }

  Map<String, dynamic> toJson() {
    return {
      'Folder': Folder,
      'topicNumbers': topicNumbers,
    };
  }
}
