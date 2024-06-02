import 'package:final_quizlet_english/blocs/folder/Folder.dart';
import 'package:final_quizlet_english/dtos/FolderInfo.dart';
import 'package:final_quizlet_english/dtos/TopicInfo.dart';
import 'package:final_quizlet_english/services/FolderDao.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FolderDetailBloc extends Bloc<FolderEvent, FolderState> {
  final FolderDao folderDao;

  late FolderInfoDTO currentFolder;

  FolderDetailBloc(this.folderDao) : super(FolderLoading()) {
    on<LoadFolder>((event, emit) async {
      emit(FolderLoading());
      var result = await FolderDao().getFolderInfoDTOByFolderId(event.folderId);
      print(result);
      if(result["status"]){
        currentFolder = result["data"];
      }
      emit(FolderDetailLoaded(currentFolder));
    });

    // on<LoadFoldersByCreatedDay>((event, emit) async {
    //   emit(FolderLoading());
    //   currentFolders.sort((a, b) => b.Folder.createdAt!.compareTo(a.Folder.createdAt!));

    //   emit(FolderLoaded(currentFolders));
    // });

    // on<AddFolder>((event, emit) async {
    //   var result = await FolderDao().addFolder(event.Folder);
    //   if (result["status"]) {
    //     print(result);
    //     String docId = result["data"];
    //     event.completer.complete(docId); // Trả về id
    //     // final Folders = await FolderDao.getFolderInfoDTOByUserId(event.Folder.userId);
    //     final newFolderAdded = await FolderDao().getFolderByDocId(docId);
    //     if(newFolderAdded["status"]) {
    //       currentFolders.add(newFolderAdded["data"]);
    //     }
    //     emit(FolderLoaded(currentFolders));
    //   } else {
    //     event.completer.completeError('Failed to add the Folder');
    //   }
    // });

    // on<UpdateFolder>((event, emit) async {
    //   var result = await FolderDao().updateFolder(event.Folder);
    //   currentFolders.removeWhere((FolderToDelete) => FolderToDelete.id == event.Folder.id);
    //   final newFolderAdded = await FolderDao().getFolderById(event.Folder.id!);
    //   if(newFolderAdded["status"]){
    //     currentFolders.add(newFolderAdded["data"]);
    //   }
    //   emit(FolderLoaded(currentFolders));
    // });

    
    // on<RemoveFolder>((event, emit) async {
    //   var result = await FolderDao().deleteFolderById(event.FolderId);
    //   if(result["status"]){
    //     currentFolders.removeWhere((FolderToDelete) => FolderToDelete.id == event.FolderId);
    //   }
    //   emit(FolderLoaded(currentFolders));
    //   print(result["message"]);
    // });
  }
}
