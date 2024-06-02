import 'dart:async';

import 'package:final_quizlet_english/dtos/FolderInfo.dart';
import 'package:final_quizlet_english/models/Folder.dart';
import 'package:final_quizlet_english/models/VocabFavourite.dart';
import 'package:final_quizlet_english/models/Vocabulary.dart';

abstract class FolderEvent {}

class LoadFolders extends FolderEvent {
  final String userId;

  LoadFolders(this.userId);
}

class LoadFoldersByCreatedDay extends FolderEvent {
  final String userId;

  LoadFoldersByCreatedDay(this.userId);
}

class LoadFolder extends FolderEvent {
  final String folderId;

  LoadFolder(this.folderId);
}

class AddFolder extends FolderEvent {
  final FolderModel Folder;

  final Completer<String> completer;//mục đích lưu trữ id trả về của Folder

  AddFolder(this.Folder)  : completer = Completer<String>();
}

class UpdateFolder extends FolderEvent {
  final FolderModel Folder;

  UpdateFolder(this.Folder); 
}

class RemoveFolder extends FolderEvent {
  final String FolderId;

  RemoveFolder(this.FolderId);
}

abstract class FolderState {}

class FolderLoading extends FolderState {}

class FolderLoaded extends FolderState {
  final List<FolderModel> folders;

  FolderLoaded(this.folders);
}

class FolderDetailLoaded extends FolderState {
  final FolderInfoDTO folderInfoDTO;

  FolderDetailLoaded(this.folderInfoDTO);
}
